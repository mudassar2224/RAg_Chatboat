"""Provider-neutral prompt, tools, and structured SQL-decision parsing."""
import json
import re
from dataclasses import dataclass

MODEL = "openai/gpt-oss-120b"

SYSTEM_PROMPT = """You are a careful data assistant for a university course-file \
management system (the "SFMS" database). Answer questions using ONLY the schema \
below, and respond by calling exactly one of the three tools you're given — never \
write SQL or an answer as plain text outside a tool call.

Rules:
- Only SELECT queries (a WITH/CTE is fine). Never write, update, delete, alter, \
or drop anything, no matter how the question is phrased. Never select a column \
named "pass" or "password", and never use SELECT * on a table that has one — ask \
for the specific columns you actually need instead.
- A single statement only — no semicolon-separated multiple statements.
- This data has inconsistent capitalization and stray whitespace in it (the same \
name or course sometimes appears with different casing or trailing spaces across \
rows). Never compare text with a plain "=" or "LIKE" using the exact casing from \
the question. Always wrap both sides in LOWER(TRIM(...)) for equality, and always \
use ILIKE (not LIKE) for partial matches, so casing and stray whitespace can never \
cause a real match to be missed.
- If a name or code in the question doesn't exactly match the schema, check the \
"Possible matches" list below first — it comes from fuzzy-matching the real data. \
When a hint is given, use that exact matched value in your SQL (inside the \
LOWER(TRIM(...)) comparison above) — don't fall back to guessing a LIKE pattern \
from the user's original wording instead.
- Person names are inconsistently split across FirstName and LastName; one field \
may contain multiple name parts. Do not assume the user's second name token belongs \
to LastName. Match a full name across both fields (for example with CONCAT(FirstName, \
' ', LastName) and a case-insensitive partial comparison), and search the role table \
the user asked about. If roles overlap, report each matching role separately.
- Select only the columns needed to answer the question. Do not include personal \
details such as email addresses unless the user explicitly asks for them.
- For full-list questions, return every matching row; do not return only a sample or \
top few unless the user asks for a limit. Counts and lists must use the same distinct \
entity definition.
- Use recent conversation context only to resolve references such as "those courses" \
or "give me details". Treat previous assistant messages as context, not database \
evidence; verify factual answers with a fresh query against the current schema.
- If the question is genuinely ambiguous (e.g. "top courses" with no metric \
named), call ask_clarification instead of guessing.
- If the question can't be answered from this schema at all (it's not about this \
database, or it asks you to change data), call cannot_answer and say so plainly.
- If you're told a previous attempt failed, fix the specific problem described — \
don't repeat the same query.

Schema:
{schema}
"""

TOOLS = [
    {
        "type": "function",
        "function": {
            "name": "run_query",
            "description": "Run a read-only SQL SELECT query to answer the question.",
            "parameters": {
                "type": "object",
                "properties": {
                    "sql": {
                        "type": "string",
                        "description": "A single SELECT statement, no trailing semicolon.",
                    },
                    "explanation": {
                        "type": "string",
                        "description": "One sentence: what this query looks up.",
                    },
                },
                "required": ["sql", "explanation"],
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "ask_clarification",
            "description": "Use when the question is too ambiguous to answer safely.",
            "parameters": {
                "type": "object",
                "properties": {
                    "message": {
                        "type": "string",
                        "description": "A short, specific clarifying question.",
                    },
                },
                "required": ["message"],
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "cannot_answer",
            "description": "Use when the question cannot be answered from this database.",
            "parameters": {
                "type": "object",
                "properties": {
                    "message": {
                        "type": "string",
                        "description": "A short, honest explanation of why not.",
                    },
                },
                "required": ["message"],
            },
        },
    },
]

_FOLLOW_UP_REFERENCES = re.compile(
    r"\b(they|them|their|those|these|it|that one|same|above|previous|both|"
    r"what about|more details|more information|more info|another one|"
    r"list their|show their|and then)\b",
    re.IGNORECASE,
)


def _is_explicit_follow_up(question: str) -> bool:
    return bool(_FOLLOW_UP_REFERENCES.search(question))

@dataclass
class Decision:
    action: str  # "run_query" | "ask_clarification" | "cannot_answer"
    sql: str | None = None
    explanation: str = ""
    message: str = ""


def _build_messages(
    question: str,
    schema: str,
    entity_hints: list,
    error_context: str | None,
    conversation_history: list[dict] | None = None,
) -> list[dict]:
    system = SYSTEM_PROMPT.format(schema=schema)
    user_parts = [f"Question: {question}"]

    if entity_hints:
        hint_lines = [
            f'- "{h["input"]}" is close to {h["label"]} "{h["matched"]}" (confidence {h["score"]:.0f})'
            for h in entity_hints
        ]
        user_parts.append("Possible matches:\n" + "\n".join(hint_lines))

    if conversation_history and _is_explicit_follow_up(question):
        history_lines = [
            f'{item["role"]}: {str(item.get("content", ""))[:500]}'
            for item in conversation_history[-6:]
            if item.get("role") in {"user", "assistant"}
        ]
        if history_lines:
            user_parts.append(
                "Recent conversation context (use only to resolve references; "
                "verify facts with the database):\n" + "\n".join(history_lines)
            )

    if error_context:
        user_parts.append(
            f"Your previous attempt failed: {error_context}\nTry again, fixing that problem."
        )

    return [
        {"role": "system", "content": system},
        {"role": "user", "content": "\n\n".join(user_parts)},
    ]


def call_llm(
    client,
    question: str,
    schema: str,
    entity_hints: list,
    error_context: str | None = None,
    conversation_history: list[dict] | None = None,
) -> Decision:
    messages = _build_messages(
        question, schema, entity_hints, error_context, conversation_history
    )

    response = client.chat.completions.create(
        model=MODEL,
        messages=messages,
        tools=TOOLS,
        # Forces a tool call instead of free text. If your SDK/Groq account
        # rejects "required", change this to "auto" — the code below
        # already handles the case where no tool call comes back.
        tool_choice="required",
        temperature=0,
    )
    message = response.choices[0].message
    if not message.tool_calls:
        return Decision(
            action="cannot_answer",
            message="I wasn't able to generate a valid response — try rephrasing.",
        )

    call = message.tool_calls[0]
    try:
        args = json.loads(call.function.arguments)
    except json.JSONDecodeError:
        return Decision(
            action="cannot_answer",
            message="I generated a malformed response — try rephrasing.",
        )

    name = call.function.name
    if name == "run_query":
        sql = args.get("sql", "").strip()
        if not sql:
            return Decision(
                action="cannot_answer",
                message="I couldn't form a query for that — try rephrasing.",
            )
        return Decision(action="run_query", sql=sql, explanation=args.get("explanation", ""))
    if name == "ask_clarification":
        return Decision(
            action="ask_clarification",
            message=args.get("message", "Could you clarify your question?"),
        )
    return Decision(
        action="cannot_answer",
        message=args.get("message", "I can't answer that from this database."),
    )


