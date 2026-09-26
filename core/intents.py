"""Handle common conversational messages without calling the LLM."""
import re


_GREETING = re.compile(
    r"^(?:hi|hello|hey|good morning|good afternoon|good evening)\b[\s,!.:-]*",
    re.IGNORECASE,
)
_GOODBYE_SUFFIX = re.compile(
    r"(?:[\s,!.;]+(?:bye|goodbye|see you(?: later)?|thanks|thank you)[\s,!.?;]*)+$",
    re.IGNORECASE,
)
_PUNCTUATION = re.compile(r"[^\w\s]", re.UNICODE)
_HELP_REPLY = (
    "I can answer questions about students, faculty, courses, departments, "
    "and uploaded files in the SFMS data. For example: “How many students "
    "are there?” or “Which faculty teach Artificial Intelligence?”"
)
_GREETING_REPLY = (
    "Hi! I can help with questions about SFMS students, faculty, courses, "
    "departments, and uploaded files. Type “help” for examples."
)


def route_message(message: str) -> tuple[str | None, str]:
    """Return a local reply for small talk, or a cleaned DB question.

    A greeting before a real question is stripped so the question still
    reaches the database pipeline. The tuple is (local_reply, question).
    """
    text = " ".join(message.strip().split())
    normalized = " ".join(_PUNCTUATION.sub(" ", text).casefold().split())

    if normalized in {"helo", "heel", "hii", "helloo", "heyy"}:
        return _GREETING_REPLY, ""

    if normalized in {
        "help", "help me", "i need help", "what can you do", "how can you help",
    }:
        return _HELP_REPLY, ""

    if normalized in {"how are you", "how are you doing"}:
        return "I'm doing well, thanks! I can help with questions about the SFMS data.", ""

    if normalized in {"thanks", "thank you", "thanks a lot", "thank you very much"}:
        return "You're welcome! Ask me whenever you have another SFMS question.", ""

    if normalized in {"ok", "okay", "got it", "understood", "sure"}:
        return "Sounds good. What would you like to know about the SFMS data?", ""

    if normalized in {"bye", "goodbye", "see you", "see you later"}:
        return "Goodbye! Have a great day.", ""

    remainder = text
    saw_help = False
    for _ in range(6):
        before = remainder
        remainder = _GREETING.sub("", remainder, count=1).strip()
        remainder = re.sub(r"^(?:there|friend|sir|ma'am|maam)[\s,!.:-]*", "", remainder, flags=re.IGNORECASE)
        if re.match(r"^(?:i need help|help me)[\s,!.:-]*", remainder, re.IGNORECASE):
            saw_help = True
            remainder = re.sub(r"^(?:i need help|help me)[\s,!.:-]*", "", remainder, count=1, flags=re.IGNORECASE)
        if remainder == before:
            break

    remainder = _GOODBYE_SUFFIX.sub("", remainder).strip()
    remainder_normalized = " ".join(
        _PUNCTUATION.sub(" ", remainder).casefold().split()
    )

    if not remainder:
        return (_HELP_REPLY if saw_help else _GREETING_REPLY), ""
    if remainder_normalized in {"help", "what can you do", "how can you help"}:
        return _HELP_REPLY, ""
    if remainder_normalized in {"bye", "goodbye", "see you", "see you later"}:
        return "Goodbye! Have a great day.", ""
    if remainder_normalized in {"ok", "okay", "got it", "understood", "sure"}:
        return "Sounds good. What would you like to know about the SFMS data?", ""
    return None, remainder