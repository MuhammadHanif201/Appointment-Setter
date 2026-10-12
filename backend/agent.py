"""The AI voice agent. LiveKit sends it into each call room the token server creates.

Speech-to-text and text-to-speech run on LiveKit Inference, so they only need
the LiveKit keys. Gemini or Claude writes what the agent says, picked by
LLM_PROVIDER in .env.

Run it with:  python agent.py dev
"""

from __future__ import annotations

import json
import logging
import os
import sys

from dotenv import load_dotenv
from livekit.agents import (
    NOT_GIVEN,
    Agent,
    AgentServer,
    AgentSession,
    JobContext,
    JobProcess,
    cli,
    inference,
    MetricsCollectedEvent,
    llm,
    metrics,
)
from livekit.agents.worker import ServerEnvOption
from livekit.plugins import google, silero

from claude_llm import ClaudeLLM
from personas import (
    AGENT_NAME,
    AGENTS,
    DEFAULT_AGENT,
    DEFAULT_BUSINESS,
    build_greeting,
    build_instructions,
    normalize_agent,
    normalize_business,
)

load_dotenv()
logger = logging.getLogger("appointment-agent")

# Keep one agent process loaded in dev mode too. Starting a fresh process takes
# about ten seconds, which the caller would hear as silence after connecting.
server = AgentServer(
    num_idle_processes=ServerEnvOption(
        dev_default=1,
        prod_default=AgentServer._default_num_idle_processes.prod_default,
    ),
    # Loading the AI libraries takes around ten seconds on a laptop, and longer
    # while a call is running. The default limit of ten seconds is too tight.
    initialize_process_timeout=60.0,
)


def prewarm(proc: JobProcess) -> None:
    # Load the voice-activity model once per process so calls start quickly.
    proc.userdata["vad"] = silero.VAD.load()


server.setup_fnc = prewarm

LLM_PROVIDERS = ("gemini", "claude")


def llm_provider() -> str:
    return os.environ.get("LLM_PROVIDER", "gemini").strip().lower()


def gemini_api_key() -> str | None:
    # Google's docs use either name, so accept both.
    return os.environ.get("GOOGLE_API_KEY") or os.environ.get("GEMINI_API_KEY")


def fast_gemini_thinking(model: str) -> dict:
    """Keep Gemini's hidden reasoning short so each spoken reply starts quickly."""
    name = model.lower()
    if "gemini-3" in name:
        # "low" is the lowest level every Gemini 3 model accepts.
        return {"thinking_level": "low"}
    if "gemini-2.5-flash" in name:
        return {"thinking_budget": 0}
    return {}


def build_llm() -> llm.LLM:
    """The model that writes the agent's replies, chosen by LLM_PROVIDER."""
    provider = llm_provider()
    if provider == "gemini":
        model = os.environ.get("GEMINI_MODEL", "gemini-3.5-flash-lite")
        thinking = fast_gemini_thinking(model)
        return google.LLM(
            model=model,
            api_key=gemini_api_key() or NOT_GIVEN,
            thinking_config=thinking if thinking else NOT_GIVEN,
        )
    if provider == "claude":
        return ClaudeLLM(
            model=os.environ.get("AGENT_CLAUDE_MODEL", "claude-opus-5-5"),
            effort=os.environ.get("AGENT_CLAUDE_EFFORT", "low"),
        )
    raise ValueError(f"LLM_PROVIDER must be one of {LLM_PROVIDERS}, got {provider!r}")


def warn_about_missing_settings() -> None:
    """Point at a missing key at startup instead of failing silently on the first call."""
    provider = llm_provider()
    if provider not in LLM_PROVIDERS:
        problem = f"LLM_PROVIDER must be one of {LLM_PROVIDERS}, got {provider!r}"
    elif provider == "gemini" and not gemini_api_key():
        problem = "LLM_PROVIDER is gemini but GOOGLE_API_KEY is empty in .env"
    elif provider == "claude" and not os.environ.get("ANTHROPIC_API_KEY"):
        problem = "LLM_PROVIDER is claude but ANTHROPIC_API_KEY is empty in .env"
    else:
        print(f"Agent replies will be written by {provider}.", file=sys.stderr)
        return
    print(f"WARNING: {problem}. Calls will connect but the agent will stay silent.", file=sys.stderr)


def read_call_details(raw_metadata: str) -> tuple[str, str]:
    """Pull the agent and business the caller picked out of the job metadata."""
    try:
        data = json.loads(raw_metadata) if raw_metadata else {}
    except json.JSONDecodeError:
        data = {}
    if not isinstance(data, dict):
        data = {}
    agent = normalize_agent(data.get("agent")) or DEFAULT_AGENT
    business = normalize_business(data.get("business")) or DEFAULT_BUSINESS
    return agent, business


@server.rtc_session(agent_name=AGENT_NAME)
async def entrypoint(ctx: JobContext) -> None:
    agent_key, business_key = read_call_details(ctx.job.metadata)
    logger.info("call started: agent=%s business=%s room=%s", agent_key, business_key, ctx.room.name)

    session = AgentSession(
        stt=inference.STT(model="deepgram/nova-3", language="en"),
        llm=build_llm(),
        tts=inference.TTS(model="deepgram/aura-2", voice=AGENTS[agent_key].tts_voice, language="en"),
        vad=ctx.proc.userdata["vad"],
    )

    @session.on("metrics_collected")
    def _log_speed(event: MetricsCollectedEvent) -> None:
        # Logs how long the AI took to start replying (ttft) and how long the
        # voice took to start speaking (ttfb), which is where call delays come from.
        if isinstance(event.metrics, (metrics.LLMMetrics, metrics.TTSMetrics)):
            metrics.log_metrics(event.metrics, logger=logger)

    await session.start(
        room=ctx.room,
        agent=Agent(instructions=build_instructions(agent_key, business_key)),
    )
    await session.generate_reply(instructions=build_greeting(agent_key, business_key))


if __name__ == "__main__":
    warn_about_missing_settings()
    cli.run_app(server)
