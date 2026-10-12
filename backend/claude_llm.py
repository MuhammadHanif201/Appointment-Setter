"""Connects the LiveKit voice pipeline to Claude through the official Anthropic SDK.

LiveKit's own Anthropic plugin pins the SDK below 1.0 and predates the current
Claude models, so this small adapter does the one job the voice agent needs:
stream Claude's reply back to LiveKit as it is written, so speech can start
before the whole answer is ready.
"""

from __future__ import annotations

import logging
from typing import Any

import anthropic
from livekit.agents import APIConnectionError, APIStatusError, APITimeoutError, llm
from livekit.agents.llm import ToolChoice
from livekit.agents.llm.tool_context import Tool
from livekit.agents.types import (
    DEFAULT_API_CONNECT_OPTIONS,
    NOT_GIVEN,
    APIConnectOptions,
    NotGivenOr,
)

logger = logging.getLogger("claude-llm")

# Server-side refusal fallback. If a safety classifier declines a turn, the API
# reruns it on Anthropic's recommended fallback model inside the same request.
FALLBACK_BETA = "server-side-fallback-2026-07-01"

# Models that accept fallbacks="default". Haiku has no server-side fallback.
_FALLBACK_MODEL_PREFIXES = ("claude-opus-5", "claude-fable-5", "claude-sonnet-5-5")

# Spoken when every model declines a turn before saying anything.
REFUSAL_LINE = "Sorry, I can't help with that. Is there anything else I can do for your booking?"


class ClaudeLLM(llm.LLM):
    def __init__(
        self,
        *,
        model: str = "claude-opus-5-5",
        effort: str = "low",
        max_tokens: int = 16000,
    ) -> None:
        super().__init__()
        self._model = model
        self._effort = effort
        self._max_tokens = max_tokens
        self._use_fallbacks = model.startswith(_FALLBACK_MODEL_PREFIXES)
        self._warned_about_tools = False
        # LiveKit retries a failed turn itself, so the SDK should not retry too.
        # The key comes from ANTHROPIC_API_KEY in the environment.
        self._client = anthropic.AsyncAnthropic(max_retries=0)

    @property
    def model(self) -> str:
        return self._model

    @property
    def provider(self) -> str:
        return "anthropic"

    def chat(
        self,
        *,
        chat_ctx: llm.ChatContext,
        tools: list[Tool] | None = None,
        conn_options: APIConnectOptions = DEFAULT_API_CONNECT_OPTIONS,
        parallel_tool_calls: NotGivenOr[bool] = NOT_GIVEN,
        tool_choice: NotGivenOr[ToolChoice] = NOT_GIVEN,
        extra_kwargs: NotGivenOr[dict[str, Any]] = NOT_GIVEN,
    ) -> ClaudeStream:
        if tools and not self._warned_about_tools:
            self._warned_about_tools = True
            logger.warning("ClaudeLLM only produces speech; the %d tool(s) are ignored", len(tools))
        return ClaudeStream(self, chat_ctx=chat_ctx, tools=tools or [], conn_options=conn_options)

    def _request_params(self, chat_ctx: llm.ChatContext, timeout: float) -> dict[str, Any]:
        # Current Claude models reject a conversation that ends on an assistant
        # turn, so LiveKit appends a short user turn when that happens.
        messages, fmt = chat_ctx.to_provider_format(
            "anthropic",
            inject_dummy_user_message=True,
            inject_trailing_user_message=True,
        )
        params: dict[str, Any] = {
            "model": self._model,
            "max_tokens": self._max_tokens,
            "messages": messages,
            "output_config": {"effort": self._effort},
            # Caches the growing conversation so each turn re-reads it cheaply.
            "cache_control": {"type": "ephemeral"},
            "timeout": timeout,
        }
        if fmt.system_messages:
            params["system"] = "\n\n".join(fmt.system_messages)
        if self._use_fallbacks:
            params["betas"] = [FALLBACK_BETA]
            params["fallbacks"] = "default"
        return params

    async def aclose(self) -> None:
        await self._client.close()
        await super().aclose()


class ClaudeStream(llm.LLMStream):
    _llm: ClaudeLLM

    async def _run(self) -> None:
        params = self._llm._request_params(self._chat_ctx, self._conn_options.timeout)
        message_id = ""
        spoke = False

        try:
            async with self._llm._client.beta.messages.stream(**params) as stream:
                async for event in stream:
                    if event.type == "message_start":
                        message_id = event.message.id
                    elif event.type == "text" and event.text:
                        spoke = True
                        self._event_ch.send_nowait(
                            llm.ChatChunk(
                                id=message_id,
                                delta=llm.ChoiceDelta(role="assistant", content=event.text),
                            )
                        )
                final = await stream.get_final_message()
        except anthropic.APITimeoutError as e:
            raise APITimeoutError(retryable=not spoke) from e
        except anthropic.APIStatusError as e:
            raise APIStatusError(
                e.message,
                status_code=e.status_code,
                request_id=e.request_id,
                body=e.body,
                retryable=None if not spoke else False,
            ) from e
        except anthropic.APIConnectionError as e:
            raise APIConnectionError(retryable=not spoke) from e

        if final.stop_reason == "refusal":
            category = final.stop_details.category if final.stop_details else None
            logger.warning("Claude declined a turn (category: %s)", category)
            if not spoke:
                self._event_ch.send_nowait(
                    llm.ChatChunk(
                        id=final.id,
                        delta=llm.ChoiceDelta(role="assistant", content=REFUSAL_LINE),
                    )
                )

        usage = final.usage
        cache_write = usage.cache_creation_input_tokens or 0
        cache_read = usage.cache_read_input_tokens or 0
        prompt_tokens = usage.input_tokens + cache_write + cache_read
        self._event_ch.send_nowait(
            llm.ChatChunk(
                id=final.id,
                usage=llm.CompletionUsage(
                    completion_tokens=usage.output_tokens,
                    prompt_tokens=prompt_tokens,
                    total_tokens=prompt_tokens + usage.output_tokens,
                    prompt_cached_tokens=cache_read,
                    cache_creation_tokens=cache_write,
                    cache_read_tokens=cache_read,
                ),
            )
        )
