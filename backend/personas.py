"""The three voice agents and the four demo businesses they answer for.

The Flutter app sends an agent name (ERIC, JESSICA, LILY) and a business
label (Doctor, Restaurant, Real Estate, Bus Ticket). The token server and the
agent worker both read this file, so they always agree on what is valid.
"""

from __future__ import annotations

from dataclasses import dataclass

# The name the agent worker registers with LiveKit. The token server asks
# LiveKit to send this worker into every new call room, so both must match.
AGENT_NAME = "appointment-setter"


@dataclass(frozen=True)
class Persona:
    display_name: str
    # A Deepgram Aura-2 voice, served through LiveKit Inference.
    tts_voice: str


AGENTS: dict[str, Persona] = {
    "ERIC": Persona("Eric", "apollo"),  # casual male voice
    "JESSICA": Persona("Jessica", "athena"),  # smooth professional female voice
    "LILY": Persona("Lily", "theia"),  # expressive polite female voice
}


@dataclass(frozen=True)
class Business:
    name: str
    brief: str


BUSINESSES: dict[str, Business] = {
    "Doctor": Business(
        name="Riverside Family Clinic",
        brief=(
            "You answer the phone for a family doctor's clinic. Callers want to "
            "book, move or cancel an appointment. To book one you need the "
            "patient's full name, a phone number, the reason for the visit in a "
            "few words, and a preferred day and time. The clinic is open Monday "
            "to Saturday, 9 AM to 6 PM. You do not give medical advice. If a "
            "caller describes an emergency, tell them to call their local "
            "emergency number right away."
        ),
    ),
    "Restaurant": Business(
        name="The Olive Table",
        brief=(
            "You answer the phone for an Italian restaurant and take table "
            "reservations. For a booking you need the guest's name, the party "
            "size, the date and time, a phone number, and any special requests "
            "such as a birthday or a high chair. The restaurant is open Tuesday "
            "to Sunday, noon to 11 PM, and takes parties of up to twelve."
        ),
    ),
    "Real Estate": Business(
        name="Keystone Realty",
        brief=(
            "You answer the phone for a real estate agency. Callers want to view "
            "a property or speak with an agent. Find out whether they are "
            "buying, renting or selling, the area and budget they have in mind, "
            "their name and phone number, and a good time for a viewing or a "
            "call back. Viewings run every day from 10 AM to 7 PM."
        ),
    ),
    "Bus Ticket": Business(
        name="CityLink Coaches",
        brief=(
            "You answer the phone for an intercity bus company and book seats. "
            "You need the departure city, the destination, the travel date, the "
            "number of passengers, a preferred departure time, and the lead "
            "passenger's name and phone number. Coaches leave every two hours "
            "from 6 AM to 10 PM."
        ),
    ),
}

DEFAULT_AGENT = "ERIC"
DEFAULT_BUSINESS = "Doctor"


def normalize_agent(value: object) -> str | None:
    """Map whatever the app sent to a key of AGENTS, or None if unknown."""
    if not isinstance(value, str):
        return None
    key = value.strip().upper()
    return key if key in AGENTS else None


def normalize_business(value: object) -> str | None:
    """Map whatever the app sent to a key of BUSINESSES, or None if unknown."""
    if not isinstance(value, str):
        return None
    wanted = value.strip().lower()
    for key in BUSINESSES:
        if key.lower() == wanted:
            return key
    return None


def build_instructions(agent_key: str, business_key: str) -> str:
    persona = AGENTS[agent_key]
    business = BUSINESSES[business_key]
    return f"""You are {persona.display_name}, the receptionist who answers calls for {business.name}. You are talking with a caller on a live voice call from the {business.name} website.

{business.brief}

How the call works:
- This is a spoken conversation. Keep each reply to one or two short sentences, and ask one question at a time.
- Everything you write is read aloud by a text-to-speech voice, so write plain spoken sentences with no lists, markdown, emoji or symbols. Say times, dates and phone numbers the way a person would say them out loud.
- Before you finish a booking, read the key details back and ask the caller to confirm them.
- This is a demo line with no live calendar. Treat any time inside opening hours as available. Once the caller confirms, tell them the booking is done and that a confirmation text message will follow.
- If the caller asks about something unrelated to {business.name}, say politely that you can only help with {business.name} bookings and steer back to how you can help.
- If you did not catch something, ask the caller to repeat it rather than guessing."""


def build_greeting(agent_key: str, business_key: str) -> str:
    persona = AGENTS[agent_key]
    business = BUSINESSES[business_key]
    return (
        f"Greet the caller warmly in one short sentence, introduce yourself as "
        f"{persona.display_name} from {business.name}, and ask how you can help."
    )
