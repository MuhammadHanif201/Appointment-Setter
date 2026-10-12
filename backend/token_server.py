"""Hands out LiveKit access tokens for voice calls started from the Flutter app.

POST /start-session
    body:    {"selectedAgent": "ERIC", "selectedLabel": "Doctor", "participantId": "..."}
    returns: {"participantToken": "...", "roomName": "...", "serverUrl": "wss://..."}

The token lets the app join a brand-new LiveKit room. It also tells LiveKit to
send the AI agent (agent.py) into that room, along with the agent and business
the caller picked.

Run it with:  python token_server.py
"""

from __future__ import annotations

import json
import os
import uuid
from datetime import timedelta

from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from livekit.api import AccessToken, RoomAgentDispatch, RoomConfiguration, VideoGrants
from pydantic import BaseModel, Field

from personas import AGENT_NAME, AGENTS, BUSINESSES, normalize_agent, normalize_business

load_dotenv()

TOKEN_TTL = timedelta(minutes=15)
REQUIRED_ENV = ("LIVEKIT_URL", "LIVEKIT_API_KEY", "LIVEKIT_API_SECRET")

app = FastAPI(title="Appointment Setter token server")

# Lets the Flutter web build call this server from the browser.
_origins = [o.strip() for o in os.environ.get("ALLOWED_ORIGINS", "*").split(",") if o.strip()]
app.add_middleware(
    CORSMiddleware,
    allow_origins=_origins,
    allow_methods=["GET", "POST", "OPTIONS"],
    allow_headers=["*"],
)


class StartSessionRequest(BaseModel):
    selectedAgent: str
    selectedLabel: str
    participantId: str | None = Field(default=None, max_length=128)
    # Accepted so older app builds keep working. The server always picks the
    # room itself, so one caller can never join another caller's room.
    roomName: str | None = None


class StartSessionResponse(BaseModel):
    participantToken: str
    roomName: str
    serverUrl: str


@app.get("/")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.post("/start-session", response_model=StartSessionResponse)
def start_session(body: StartSessionRequest) -> StartSessionResponse:
    missing = [name for name in REQUIRED_ENV if not os.environ.get(name)]
    if missing:
        raise HTTPException(500, f"The server's .env is missing: {', '.join(missing)}")

    agent = normalize_agent(body.selectedAgent)
    if agent is None:
        raise HTTPException(422, f"Unknown agent '{body.selectedAgent}'. Use one of: {', '.join(AGENTS)}")

    business = normalize_business(body.selectedLabel)
    if business is None:
        raise HTTPException(
            422, f"Unknown label '{body.selectedLabel}'. Use one of: {', '.join(BUSINESSES)}"
        )

    room_name = f"call-{uuid.uuid4()}"
    identity = body.participantId or f"caller-{uuid.uuid4()}"
    call_details = json.dumps({"agent": agent, "business": business})

    token = (
        AccessToken(os.environ["LIVEKIT_API_KEY"], os.environ["LIVEKIT_API_SECRET"])
        .with_identity(identity)
        .with_name("Website caller")
        .with_ttl(TOKEN_TTL)
        .with_grants(
            VideoGrants(
                room_join=True,
                room=room_name,
                can_publish=True,
                can_subscribe=True,
                can_publish_data=True,
            )
        )
        .with_room_config(
            RoomConfiguration(
                agents=[RoomAgentDispatch(agent_name=AGENT_NAME, metadata=call_details)],
            )
        )
        .to_jwt()
    )

    return StartSessionResponse(
        participantToken=token,
        roomName=room_name,
        serverUrl=os.environ["LIVEKIT_URL"],
    )


if __name__ == "__main__":
    import uvicorn

    # 0.0.0.0 lets a phone on the same Wi-Fi reach this laptop.
    uvicorn.run("token_server:app", host="0.0.0.0", port=int(os.environ.get("PORT", "8000")))
