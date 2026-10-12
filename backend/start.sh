#!/usr/bin/env bash
# Starts the token server and the voice agent together.
# Leave this terminal open while you test. Press Ctrl+C to stop both.
set -euo pipefail
cd "$(dirname "$0")"

if [ ! -x .venv/bin/python ]; then
  echo "The Python environment is missing. Follow 'First-time setup' in backend/README.md." >&2
  exit 1
fi
if [ ! -f .env ]; then
  echo "backend/.env is missing. Copy .env.example to .env and fill in the keys." >&2
  exit 1
fi
if lsof -nP -iTCP:"${PORT:-8000}" -sTCP:LISTEN >/dev/null 2>&1; then
  echo "Port ${PORT:-8000} is already in use. The backend may already be running in another terminal." >&2
  exit 1
fi

.venv/bin/python agent.py dev &
AGENT_PID=$!
trap 'kill "$AGENT_PID" 2>/dev/null || true; wait "$AGENT_PID" 2>/dev/null || true' EXIT INT TERM

echo "Starting the token server. The agent needs about 15 seconds to load before the first call."
.venv/bin/python token_server.py
