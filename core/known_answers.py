"""Deterministic DuckDB answers for high-value, schema-sensitive intents."""
from __future__ import annotations

import re

import duckdb
import pandas as pd

from core.results import format_result_frame

_STOP_WORDS = {
    "a", "about", "all", "an", "and", "are", "as", "at", "both", "by",
    "check", "code", "courses", "course", "dean", "deans", "department", "each",
    "details", "does", "faculty", "file", "files", "for", "from", "give",
    "has", "have", "he", "her", "him", "his", "i", "identify", "in", "include",
    "is", "it", "list", "me", "member", "members", "name", "of", "on", "only",
    "person", "please", "record", "records", "role", "school", "show", "staff",
    "teach", "teacher", "teachers", "teaches", "teaching", "tell", "the", "their",
    "them", "they", "to", "what", "which", "who", "with", "would", "do", "not",
    "dr", "doctor", "mr", "mrs", "ms", "miss", "prof", "professor",
}
_ROLE_TABLES = (
    ("faculty", "Faculty"),
    ("deans", "Dean"),
    ("coordiantor", "Coordinator"),
    ("cods", "COD"),
)


def _normalized(text: str) -> str:
    return " ".join(re.sub(r"[^\w\s]", " ", text.casefold()).split())


def _question_name_tokens(question: str) -> set[str]:
    return {
        token
        for token in _normalized(question).split()
        if len(token) > 1 and token not in _STOP_WORDS and not token.isdigit()
    }


def _question_is_person_lookup(question: str) -> bool:
    normalized = _normalized(question)
    starts_as_lookup = normalized.startswith(("who is ", "who are ", "tell me about ", "check both "))
    if not starts_as_lookup or " all " in f" {normalized} ":
        return False
    if re.search(r"\b(courses?\s+(?:does|do|is|are)|files?\s+(?:does|do|is|are))\b", normalized):
        return False
    return True


def _person_records(con: duckdb.DuckDBPyConnection) -> pd.DataFrame:
    records: list[tuple[str, str, str, str]] = []
    for table, role in _ROLE_TABLES:
        try:
            rows = con.execute(
                f'SELECT FirstName, LastName, depname, depschool FROM "{table}"'
            ).fetchall()
        except Exception:
            continue
        for first, last, department, school in rows:
            full_name = " ".join(str(part).strip() for part in (first, last) if part)
            records.append((role, full_name, str(department or ""), str(school or "")))
    return pd.DataFrame(records, columns=["Role", "Name", "Department", "School"])


def _matching_people(question: str, records: pd.DataFrame) -> pd.DataFrame:
    tokens = _question_name_tokens(question)
    if not tokens:
        return records.iloc[0:0].copy()
    normalized_question = _normalized(question)
    search_both_roles = bool(
        re.search(r"\bboth\b", normalized_question)
        and re.search(r"\bfaculty\b", normalized_question)
        and re.search(r"\bdean\b", normalized_question)
    )

    def name_matches(name: str) -> bool:
        name_tokens = set(_normalized(name).split())
        if tokens.issubset(name_tokens):
            return True
        # If the user explicitly asks to inspect both role tables, include a
        # close partial-name record as a distinct candidate, not as the same
        # person. This distinguishes e.g. a dean with a three-part name from
        # a faculty record containing only its first two parts.
        return search_both_roles and len(tokens & name_tokens) >= 2 and len(tokens & name_tokens) == len(name_tokens)

    matches = records["Name"].map(name_matches)
    return records.loc[matches].drop_duplicates().reset_index(drop=True)


def _answer_person_lookup(question: str, con: duckdb.DuckDBPyConnection) -> str | None:
    if not _question_is_person_lookup(question):
        return None
    matches = _matching_people(question, _person_records(con))
    if matches.empty:
        return None
    return format_result_frame(matches, question)


def _department_name_in_question(question: str, con: duckdb.DuckDBPyConnection) -> str | None:
    question_text = _normalized(question)
    names = con.execute(
        "SELECT DISTINCT TRIM(depname) FROM departments WHERE depname IS NOT NULL"
    ).fetchall()
    matches = [name for (name,) in names if _normalized(name) and _normalized(name) in question_text]
    if not matches:
        return None
    return max(matches, key=len)


def _answer_department_courses(question: str, con: duckdb.DuckDBPyConnection) -> str | None:
    normalized = _normalized(question)
    if not re.search(r"\bcourses?\b", normalized):
        return None
    if re.search(r"\b(top|best|popular|highest|ranked|ranking)\b", normalized) and not re.search(
        r"\b(by|based on|most|highest)\s+(?:file|student|enrollment|assignment|assessment|section)",
        normalized,
    ):
        return None  # leave under-specified ranking questions to the clarification path
    department = _department_name_in_question(question, con)
    if not department:
        return None

    base_sql = """
        FROM departments d
        JOIN faculty f ON LOWER(TRIM(f.depcode)) = LOWER(TRIM(d.depcode))
        JOIN courses_assign ca ON LOWER(TRIM(ca.fcode)) = LOWER(TRIM(f.fcode))
        WHERE LOWER(TRIM(d.depname)) = LOWER(TRIM(?))
    """
    is_count_request = bool(re.search(r"\b(how many|count|number of|total)\b", normalized))
    is_list_request = bool(re.search(r"\b(list|show|which|give|include)\b", normalized))

    if is_count_request and not is_list_request:
        count = con.execute(
            "SELECT COUNT(DISTINCT LOWER(TRIM(ca.corsecode))) " + base_sql,
            [department],
        ).fetchone()[0]
        return str(count)

    include_course_name = not (
        "course code" in normalized and "section" in normalized and "full details" not in normalized
    )
    projections = "ca.corsecode AS course_code"
    if include_course_name:
        projections += ", ca.courseName AS course_name"
    projections += ", ca.coursesection AS section"
    courses = con.execute(
        f"SELECT DISTINCT {projections} {base_sql} ORDER BY ca.corsecode, ca.coursesection",
        [department],
    ).df()

    course_count = con.execute(
        "SELECT COUNT(DISTINCT LOWER(TRIM(ca.corsecode))) " + base_sql,
        [department],
    ).fetchone()[0]
    rendered = format_result_frame(courses, question)
    if is_count_request and is_list_request:
        return f"Distinct course-code count: {course_count}.\n\n{rendered}"
    return rendered


def _answer_person_courses(question: str, con: duckdb.DuckDBPyConnection) -> str | None:
    normalized = _normalized(question)
    if not re.search(r"\bcourses?\b", normalized) or not re.search(
        r"\b(teaches|teach|taught|assigned|assignments?)\b", normalized
    ):
        return None

    faculty_rows = con.execute(
        "SELECT fcode, FirstName, LastName FROM faculty WHERE fcode IS NOT NULL"
    ).fetchall()
    tokens = _question_name_tokens(question)
    if not tokens:
        return None

    requested_codes = {
        re.sub(r"[^a-z0-9]", "", match)
        for match in re.findall(r"\b(?:f-sst-\d+|\d{3,})\b", question.casefold())
    }
    matched_codes = []
    for code, first, last in faculty_rows:
        full_name_tokens = set(_normalized(f"{first} {last}").split())
        normalized_code = re.sub(r"[^a-z0-9]", "", str(code).casefold())
        if (requested_codes and normalized_code in requested_codes) or (
            not requested_codes and tokens.issubset(full_name_tokens)
        ):
            matched_codes.append((str(code), f"{first} {last}".strip()))
    if not matched_codes:
        return None

    assignments: list[tuple[str, str, str, str]] = []
    for code, full_name in matched_codes:
        rows = con.execute(
            """
            SELECT DISTINCT corsecode, courseName, coursesection
            FROM courses_assign
            WHERE LOWER(TRIM(fcode)) = LOWER(TRIM(?))
            ORDER BY corsecode, coursesection
            """,
            [code],
        ).fetchall()
        assignments.extend((full_name, course_code, course_name, section) for course_code, course_name, section in rows)
    if not assignments:
        return "No course assignments were found for the matching faculty record."
    frame = pd.DataFrame(
        assignments,
        columns=["Faculty", "Course code", "Course name", "Section"],
    ).drop_duplicates()
    return format_result_frame(frame, question)


def answer_known_question(question: str, con: duckdb.DuckDBPyConnection) -> str | None:
    """Answer high-value, well-defined questions directly from DuckDB."""
    person_courses = _answer_person_courses(question, con)
    if person_courses is not None:
        return person_courses

    department_courses = _answer_department_courses(question, con)
    if department_courses is not None:
        return department_courses

    return _answer_person_lookup(question, con)
