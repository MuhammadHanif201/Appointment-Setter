# Appointment Setter backend

This folder holds the server side of the "talk to our AI agent" demo in the
Flutter app. It has two programs that run side by side.

| Program | What it does |
| --- | --- |
| `token_server.py` | A small web API. The app calls `POST /start-session`, and it answers with a LiveKit token for a fresh call room. |
| `agent.py` | The AI voice agent. LiveKit sends it into every new call room, where it listens, writes a reply with Gemini or Claude, and talks back. |

## How a call flows

1. The caller picks an agent (ERIC, JESSICA or LILY) and a business (Doctor, Restaurant, Real Estate or Bus Ticket) and taps the call button.
2. The app sends those choices to `POST /start-session` on the token server.
3. The token server creates a new room name and signs a LiveKit token. The token also tells LiveKit to dispatch the `appointment-setter` agent into that room with the caller's choices attached.
4. The app joins the room on LiveKit Cloud with that token and turns on the microphone.
5. LiveKit starts a job on `agent.py`. The agent reads the caller's choices, picks a voice and a business script, and greets the caller.
6. From then on, LiveKit Inference turns the caller's speech into text, Gemini or Claude writes the reply, and LiveKit Inference speaks it back.

The voices, businesses and the agent's instructions all live in `personas.py`.
Change them there.

## What you need

- **Python 3.10 or newer.** The macOS system Python is 3.9 and is too old. Use `python3.13` or install a newer Python from python.org.
- **A LiveKit Cloud project.** Sign in at https://cloud.livekit.io, open the project, and create an API key under Settings. You need the project URL, the API key and the API secret. Speech-to-text and text-to-speech run on LiveKit Inference and bill to this project, so no other speech keys are needed.
- **A key for the AI that writes the replies.** The default is Gemini, which has a free tier: sign in at https://aistudio.google.com/apikey and create an API key. To use Claude instead, set `LLM_PROVIDER=claude` and add a key from the Claude Console at https://platform.claude.com, which needs prepaid credits.

## First-time setup

```bash
cd backend
python3.13 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python -m livekit.agents download-files
cp .env.example .env
```

Then open `.env` and fill in `LIVEKIT_URL`, `LIVEKIT_API_KEY`,
`LIVEKIT_API_SECRET` and `GOOGLE_API_KEY`. Fill in `ANTHROPIC_API_KEY` only
if you switch `LLM_PROVIDER` to `claude`.

## Running it

The quickest way starts both programs from one terminal:

```bash
./backend/start.sh
```

In VS Code you can also open the Command Palette, choose "Tasks: Run Task",
and pick "Start backend". Keep that terminal open while you test, and press
Ctrl+C there to stop both programs. The agent needs about 15 seconds to load
before the first call.

To run them separately instead, open two terminals. In each one, run `cd backend && source .venv/bin/activate` first.

Terminal 1 starts the token server on port 8000:

```bash
python token_server.py
```

Terminal 2 starts the voice agent and registers it with LiveKit Cloud:

```bash
python agent.py dev
```

Check the token server with:

```bash
curl -X POST http://localhost:8000/start-session \
  -H 'Content-Type: application/json' \
  -d '{"selectedAgent":"ERIC","selectedLabel":"Doctor"}'
```

A working server answers with `participantToken`, `roomName` and `serverUrl`.

## Pointing the Flutter app at the backend

By default the app calls `http://localhost:8000`, or `http://10.0.2.2:8000`
on the Android emulator. That covers the iOS simulator, the Android emulator
and the web build running on the same computer.

A real phone cannot reach `localhost` on your computer. Expose the token server
with a tunnel such as ngrok and pass its URL when you run the app:

```bash
ngrok http 8000
flutter run --dart-define=BACKEND_URL=https://<your-subdomain>.ngrok-free.app
```

Only the token server needs a tunnel. The agent connects out to LiveKit Cloud
on its own.

## Settings

All settings live in `.env`. See `.env.example` for the full list.

| Setting | Default | Notes |
| --- | --- | --- |
| `LLM_PROVIDER` | `gemini` | Which AI writes the agent's replies: `gemini` or `claude`. |
| `GEMINI_MODEL` | `gemini-3.5-flash-lite` | On the free tier and the quickest to start speaking. `gemini-3.8-flash` is smarter but slower. The agent keeps Gemini's hidden reasoning short either way. |
| `AGENT_CLAUDE_MODEL` | `claude-opus-5-5` | `claude-haiku-5-5` answers faster and costs far less, which suits phone calls. |
| `AGENT_CLAUDE_EFFORT` | `low` | How much Claude reasons before speaking. Higher values add delay before each reply. |
| `ALLOWED_ORIGINS` | `*` | Browser origins allowed to call the token server. Set it to your website's address in production. |
| `PORT` | `8000` | Port for the token server. |

The Claude settings start with `AGENT_` because Claude Code sets its own
`CLAUDE_EFFORT` variable, which would otherwise override this one.

Gemini's free tier has rate limits, and Google may use free-tier requests to
improve its products. Use a paid Gemini key, or Claude, for real customers.

On Claude Opus, Sonnet 5.5 and Fable models the agent turns on Anthropic's
server-side refusal fallback. If a safety check declines a reply, the API
retries it on a fallback model automatically.

## Before going live

- **Anyone who can reach `/start-session` can start a call**, and every call spends LiveKit credit and AI quota. Add rate limiting or a sign-in check before publishing the URL.
- **Host both programs somewhere permanent.** The token server is a normal FastAPI app that runs on any Python host. LiveKit Cloud can host the agent itself; see LiveKit's agent deployment docs.
- **Keep `.env` out of git.** The `.gitignore` in this folder already excludes it.
