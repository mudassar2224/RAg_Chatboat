"""Test the SQL pipeline with a scripted client and no provider credentials."""
import json

from core.pipeline import answer_question
from nlp.entities import build_cache

EMPTY_CACHE = {"faculty": [], "course": [], "department": [], "student": []}


class _FakeFunction:
    def __init__(self, name, arguments):
        self.name = name
        self.arguments = json.dumps(arguments)


class _FakeToolCall:
    def __init__(self, name, arguments):
        self.id = "call_1"
        self.function = _FakeFunction(name, arguments)


class _FakeMessage:
    def __init__(self, tool_calls=None, content=None):
        self.tool_calls = tool_calls
        self.content = content


class _FakeChoice:
    def __init__(self, message):
        self.message = message


class _FakeResponse:
    def __init__(self, message):
        self.choices = [_FakeChoice(message)]


def tool_response(tool_name, arguments):
    """A scripted response representing a tool-call decision."""
    return _FakeResponse(_FakeMessage(tool_calls=[_FakeToolCall(tool_name, arguments)]))


class FakeGroqClient:
    """Returns scripted tool decisions for the SQL-generation call."""

    def __init__(self, script):
        self._script = list(script)
        self.call_count = 0
        self.calls = []
        outer = self

        class _Completions:
            def create(self, **kwargs):
                outer.call_count += 1
                outer.calls.append(kwargs)
                return outer._script.pop(0)

        class _Chat:
            completions = _Completions()

        self.chat = _Chat()


def test_answers_directly_with_valid_query(db):
    client = FakeGroqClient(
        [
            tool_response("run_query", {"sql": "SELECT FirstName, LastName FROM faculty", "explanation": "lists all faculty"}),
        ]
    )

    result = answer_question("list all faculty", db, client, EMPTY_CACHE)

    assert result.kind == "query"
    assert "Adnan" in result.answer
    assert "Sara" in result.answer
    assert client.call_count == 1
    assert result.attempts == 1


def test_retries_after_invalid_sql_then_succeeds(db):
    client = FakeGroqClient(
        [
            tool_response("run_query", {"sql": "DROP TABLE faculty", "explanation": "oops"}),
            tool_response("run_query", {"sql": "SELECT FirstName, LastName FROM faculty", "explanation": "lists all faculty"}),
        ]
    )

    result = answer_question("list all faculty", db, client, EMPTY_CACHE)

    assert result.kind == "query"
    assert result.attempts == 2


def test_retries_after_sensitive_column_then_succeeds(db):
    client = FakeGroqClient(
        [
            tool_response("run_query", {"sql": "SELECT pass FROM faculty", "explanation": "oops"}),
            tool_response(
                "run_query",
                {"sql": "SELECT FirstName FROM faculty", "explanation": "lists first names"},
            ),
        ]
    )

    result = answer_question("list all faculty passwords", db, client, EMPTY_CACHE)

    assert result.kind == "query"
    assert result.attempts == 2


def test_retries_after_execution_error_then_succeeds(db):
    client = FakeGroqClient(
        [
            tool_response("run_query", {"sql": "SELECT FirstName FROM not_a_real_table", "explanation": "oops"}),
            tool_response("run_query", {"sql": "SELECT FirstName, LastName FROM faculty", "explanation": "lists all faculty"}),
        ]
    )

    result = answer_question("list all faculty", db, client, EMPTY_CACHE)

    assert result.kind == "query"
    assert result.attempts == 2


def test_gives_up_after_max_retries(db):
    client = FakeGroqClient(
        [
            tool_response("run_query", {"sql": "DROP TABLE faculty", "explanation": "oops"}),
            tool_response("run_query", {"sql": "DROP TABLE faculty", "explanation": "oops"}),
            tool_response("run_query", {"sql": "DROP TABLE faculty", "explanation": "oops"}),
        ]
    )

    result = answer_question("list all faculty", db, client, EMPTY_CACHE, max_retries=2)

    assert result.kind == "failed"
    assert result.attempts == 3


def test_clarification_returned_without_touching_db(db):
    client = FakeGroqClient(
        [tool_response("ask_clarification", {"message": "Top courses by what — enrollment or uploads?"})]
    )

    result = answer_question("show me the top courses", db, client, EMPTY_CACHE)

    assert result.kind == "clarification"
    assert "enrollment" in result.answer


def test_cannot_answer_for_out_of_scope_question(db):
    client = FakeGroqClient(
        [tool_response("cannot_answer", {"message": "That's not something this database covers."})]
    )

    result = answer_question("what's the weather today", db, client, EMPTY_CACHE)

    assert result.kind == "cannot_answer"


def test_provider_failure_returns_friendly_message(db):
    class _BrokenCompletions:
        def create(self, **kwargs):
            raise RuntimeError("provider rate limit")

    client = type(
        "BrokenClient",
        (),
        {"chat": type("Chat", (), {"completions": _BrokenCompletions()})()},
    )()

    result = answer_question("list all faculty", db, client, EMPTY_CACHE)

    assert result.kind == "failed"
    assert "temporarily unavailable" in result.answer


def test_followup_context_is_sent_as_context_not_database_evidence(db):
    client = FakeGroqClient(
        [tool_response("cannot_answer", {"message": "Not covered by this database."})]
    )
    history = [
        {"role": "user", "content": "Which courses are in Computer Science?"},
        {"role": "assistant", "content": "Here are the matching courses."},
    ]

    answer_question("Give me more details", db, client, EMPTY_CACHE, conversation_history=history)

    user_prompt = client.calls[0]["messages"][1]["content"]
    assert "Recent conversation context" in user_prompt
    assert "Computer Science" in user_prompt
    assert "verify facts with the database" in user_prompt


def test_unrelated_long_message_does_not_inherit_previous_query_context(db):
    client = FakeGroqClient(
        [tool_response("cannot_answer", {"message": "That is outside the SFMS database."})]
    )
    history = [
        {"role": "user", "content": "How many students are in the database?"},
        {"role": "assistant", "content": "There are 50 students."},
    ]

    answer_question(
        "Hugging Face loaded a model and started training a dataset.",
        db,
        client,
        EMPTY_CACHE,
        conversation_history=history,
    )

    user_prompt = client.calls[0]["messages"][1]["content"]
    assert "Recent conversation context" not in user_prompt
    assert "There are 50 students" not in user_prompt


def test_empty_result_reports_resolved_name_without_extra_model_call(db):
    client = FakeGroqClient(
        [
            tool_response(
                "run_query",
                {"sql": "SELECT FirstName FROM faculty WHERE 1 = 0", "explanation": "look up faculty"},
            )
        ]
    )

    result = answer_question(
        "Show files for Adnan Abed",
        db,
        client,
        build_cache(db),
    )

    assert result.kind == "query"
    assert "adnan abid" in result.answer.casefold()
    assert "matched from 'adnan abed'" in result.answer.casefold()
    assert client.call_count == 1


def test_pipeline_removes_unrequested_contact_columns(db):
    client = FakeGroqClient(
        [
            tool_response(
                "run_query",
                {
                    "sql": "SELECT FirstName, LastName, email FROM faculty WHERE FirstName = 'Adnan'",
                    "explanation": "retrieve requested faculty details",
                },
            )
        ]
    )

    result = answer_question("Tell me about Adnan Abid", db, client, EMPTY_CACHE)

    assert "Adnan" in result.answer
    assert "adnan.abid@umt.edu.pk" not in result.answer
    assert client.call_count == 1


def test_pipeline_returns_student_names_but_hides_unrequested_ids(db):
    client = FakeGroqClient(
        [
            tool_response(
                "run_query",
                {
                    "sql": "SELECT firstname, lastname, stud_id FROM student "
                    "UNION ALL SELECT 'Ada', 'Lovelace', 2",
                    "explanation": "list all student records",
                },
            )
        ]
    )

    result = answer_question("Show all students", db, client, EMPTY_CACHE)

    assert "Bilal" in result.answer
    assert "Lovelace" in result.answer
    assert "stud_id" not in result.answer
    assert "1" not in result.answer
    assert "2" not in result.answer
