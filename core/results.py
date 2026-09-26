"""Privacy-aware, deterministic rendering of DuckDB result rows."""
from __future__ import annotations

import re
from html import escape

import pandas as pd

MAX_RESULT_ROWS = 100

_PRIVATE_COLUMN_NAMES = {
    "email", "emailaddress", "contact", "contactno", "contactnumber",
    "phone", "phonenumber", "mobile", "password", "pass",
    "studid", "studentid", "studentnumber", "studno", "studentno",
    "createdby", "createdon", "createdat", "gender",
}
_ID_COLUMN_NAMES = {"id", "fid", "did", "didid", "ccode", "dcode", "cocode", "rowid"}


def _normalize_column(column: object) -> str:
    return re.sub(r"[^a-z0-9]", "", str(column).casefold())


def _requested(question: str, *phrases: str) -> bool:
    text = " ".join(re.sub(r"[^\w\s]", " ", question.casefold()).split())
    return any(phrase in text for phrase in phrases)


def _column_is_requested(column: object, question: str) -> bool:
    name = _normalize_column(column)
    if "password" in name or name == "pass":
        return False
    if "email" in name:
        return _requested(question, "email", "e mail")
    if any(term in name for term in ("contact", "phone", "mobile", "telephone")):
        return _requested(question, "phone", "contact", "mobile")
    if ("student" in name or name.startswith("stud")) and any(
        term in name for term in ("id", "number", "no", "identifier")
    ):
        return _requested(
            question,
            "student id", "student ids", "student number", "student no",
            "student identifier", "student identifiers", "stud id", "stud ids",
            "stud no", "ids of all students", "identifier", "identifiers",
        )
    if name in {"createdby", "createdon", "createdat"}:
        return _requested(question, "created by", "created on", "created at", "when was the record", "record creation")
    if name == "gender":
        return _requested(question, "gender", "male", "female")
    if name == "depcode":
        return _requested(question, "department code", "depcode")
    if name in {"fcode", "facultycode"}:
        return _requested(question, "faculty code", "fcode")
    if name in {"dcode", "deancode"}:
        return _requested(question, "dean code", "dcode")
    if name in _ID_COLUMN_NAMES:
        return _requested(question, " id", "identifier", "record id")
    return True


def sanitize_result_frame(frame: pd.DataFrame, question: str) -> tuple[pd.DataFrame, str | None]:
    """Drop unrequested private fields while allowing explicitly requested student data."""
    keep = []
    frame = frame.copy()
    normalized_columns = {_normalize_column(column): column for column in frame.columns}
    first_column = normalized_columns.get("firstname")
    last_column = normalized_columns.get("lastname")
    if first_column is not None and last_column is not None and "name" not in normalized_columns:
        first_names = frame[first_column].fillna("").astype(str).str.strip()
        last_names = frame[last_column].fillna("").astype(str).str.strip()
        position = min(frame.columns.get_loc(first_column), frame.columns.get_loc(last_column))
        frame.insert(position, "Name", (first_names + " " + last_names).str.strip())
        frame = frame.drop(columns=[first_column, last_column])

    for column in frame.columns:
        normalized = _normalize_column(column)
        is_private = (
            normalized in _PRIVATE_COLUMN_NAMES
            or normalized in _ID_COLUMN_NAMES
            or any(term in normalized for term in ("email", "contact", "phone", "mobile", "telephone", "password"))
            or (("student" in normalized or normalized.startswith("stud")) and any(
                term in normalized for term in ("id", "number", "no", "identifier")
            ))
        )
        if is_private:
            if _column_is_requested(column, question):
                keep.append(column)
        else:
            keep.append(column)

    safe_frame = frame.loc[:, keep].copy()
    for column in safe_frame.columns:
        if _normalize_column(column) in {"filename", "file"}:
            safe_frame[column] = safe_frame[column].map(
                lambda value: (
                    "[salary-related filename withheld]"
                    if isinstance(value, str)
                    and re.search(r"salary\s*slip|payslip", value, re.IGNORECASE)
                    else value
                )
            )
    if len(frame.columns) and not len(safe_frame.columns):
        return safe_frame, (
            "The matching records contain only personal details that weren’t requested. "
            "Ask for a non-sensitive detail, such as a role or department."
        )
    return safe_frame, None


def _display_value(value: object) -> str:
    if value is None or (not isinstance(value, (list, dict)) and pd.isna(value)):
        return "—"
    text = str(value).replace("\r\n", " ").replace("\n", " ")
    return escape(text, quote=True).replace("|", r"\|")


def _markdown_table(frame: pd.DataFrame) -> str:
    columns = [_display_value(column) for column in frame.columns]
    header = "| " + " | ".join(columns) + " |"
    separator = "| " + " | ".join("---" for _ in columns) + " |"
    rows = [
        "| " + " | ".join(_display_value(value) for value in row) + " |"
        for row in frame.itertuples(index=False, name=None)
    ]
    return "\n".join([header, separator, *rows])


def format_result_frame(frame: pd.DataFrame, question: str) -> str:
    """Render all safe query rows deterministically; no LLM can omit or invent rows."""
    safe_frame, refusal = sanitize_result_frame(frame, question)
    if refusal:
        return refusal
    if safe_frame.empty:
        return "No matching records were found. Check the spelling or code and try again."

    if safe_frame.shape == (1, 1):
        return _display_value(safe_frame.iat[0, 0])

    display_frame = safe_frame.head(MAX_RESULT_ROWS)
    if len(display_frame.columns) == 1:
        values = [f"- {_display_value(value)}" for value in display_frame.iloc[:, 0]]
        answer = "\n".join(values)
    else:
        answer = _markdown_table(display_frame)

    if len(safe_frame) > MAX_RESULT_ROWS:
        answer += f"\n\nShowing {MAX_RESULT_ROWS} of {len(safe_frame)} matching rows."
    return answer
