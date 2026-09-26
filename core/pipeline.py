"""Tie deterministic query handling, entity resolution, SQL generation,
validation, execution, privacy filtering, and rendering into one function.
Kept separate from app.py so it can be tested without Streamlit or a live
Groq/database connection (see tests/test_pipeline.py).

Every step logs to the standard `logging` module rather than returning
debug detail for the UI to show — run `streamlit run app.py` in a
terminal and that terminal is where the SQL, retries and entity hints
show up. Nothing about how an answer was produced reaches the browser.
"""
import logging
from dataclasses import dataclass

import duckdb

from core.known_answers import answer_known_question
from core.results import format_result_frame
from db.schema_text import get_schema_text
from nlp.entities import resolve
from nlp.llm import call_llm
from nlp.validate import is_safe

MAX_RETRIES = 2

logger = logging.getLogger("sfms_chatbot")


@dataclass
class PipelineResult:
    kind: str  # "query" | "clarification" | "cannot_answer" | "failed"
    answer: str = ""  # the one thing app.py should show the user
    attempts: int = 1


def answer_question(
    question: str,
    con: duckdb.DuckDBPyConnection,
    client,
    entity_cache: dict,
    max_retries: int = MAX_RETRIES,
    conversation_history: list[dict] | None = None,
) -> PipelineResult:
    known_answer = answer_known_question(question, con)
    if known_answer is not None:
        logger.info("answered_with=deterministic_database_query")
        return PipelineResult(kind="query", answer=known_answer, attempts=0)

    entity_hints = resolve(question, entity_cache)
    schema = get_schema_text(con)
    logger.info("question=%r entity_hints=%s", question, entity_hints)

    error_context = None
    attempt = 0
    while attempt <= max_retries:
        try:
            decision = call_llm(
                client,
                question,
                schema,
                entity_hints,
                error_context,
                conversation_history,
            )
        except Exception:
            # The SDK may retry rate limits internally; if it still fails,
            # stop cleanly instead of surfacing a traceback in the chat UI.
            logger.exception("LLM request failed")
            return PipelineResult(
                kind="failed",
                answer=(
                    "The assistant service is temporarily unavailable. "
                    "Please try again in a little while."
                ),
                attempts=attempt + 1,
            )
        attempt += 1
        logger.info("attempt=%d decision=%s", attempt, decision)

        if decision.action == "run_query":
            ok, reason = is_safe(decision.sql)
            if not ok:
                logger.warning("rejected sql=%r reason=%r", decision.sql, reason)
                error_context = f"Query rejected: {reason}. Query was: {decision.sql}"
                continue
            try:
                df = con.execute(decision.sql).df()
            except Exception as e:
                logger.warning("execution failed sql=%r error=%s", decision.sql, e)
                error_context = f"Execution failed: {e}. Query was: {decision.sql}"
                continue

            logger.info("sql=%r rows=%d", decision.sql, len(df))
            if df.empty:
                if entity_hints:
                    hint = entity_hints[0]
                    answer = (
                        f"No matching records were found for {hint['label']} "
                        f"'{hint['matched']}' (matched from '{hint['input']}')."
                    )
                else:
                    answer = "No matching records were found. Check the spelling or code and try again."
                return PipelineResult(kind="query", answer=answer, attempts=attempt)
            answer = format_result_frame(df, question)
            return PipelineResult(kind="query", answer=answer, attempts=attempt)

        if decision.action == "ask_clarification":
            return PipelineResult(kind="clarification", answer=decision.message, attempts=attempt)

        return PipelineResult(kind="cannot_answer", answer=decision.message, attempts=attempt)

    logger.warning("gave up after %d attempts, last error=%s", attempt, error_context)
    return PipelineResult(
        kind="failed",
        answer="I couldn't find a safe way to answer that after a few tries. Try rephrasing it.",
        attempts=attempt,
    )
