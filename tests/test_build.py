"""Runs db.build against the real, committed data/db_sfms.sql and checks
the result — no MySQL, no mocking, no skip condition. This is the
strongest test in the suite: it exercises the exact code path the app
uses on first launch, against your actual data.
"""
from pathlib import Path

import duckdb
import pytest

from db.build import DUMP_PATH, SNAPSHOT_PATH, build
from db.schema_text import get_schema_text
from core.known_answers import answer_known_question
from core.pipeline import answer_question
from core.results import format_result_frame
from nlp.entities import build_cache, resolve
from quality.checks import CHECKS

# Known row counts from the current data/db_sfms.sql. If you replace that
# file with a different dump, update these — a mismatch here means the
# parser silently dropped or duplicated rows, which is exactly the kind
# of thing you want a test to catch rather than notice later in the UI.
EXPECTED_ROW_COUNTS = {
    "cods": 55,
    "cod_assigndep": 165,
    "coordiantor": 101,
    "coordiantor_assigndep": 51,
    "courses": 38,
    "courses_assign": 38,
    "courses_section": 38,
    "deans": 6,
    "deans_assigndep": 6,
    "departments": 16,
    "faculty": 29,
    "sessions": 3,
    "storage": 20,
    "student": 50,
    "user": 11,
}


@pytest.fixture(scope="module")
def built_con():
    Path(SNAPSHOT_PATH).unlink(missing_ok=True)
    build()
    con = duckdb.connect(SNAPSHOT_PATH, read_only=True)
    yield con
    con.close()


def test_dump_file_exists():
    assert Path(DUMP_PATH).exists(), f"{DUMP_PATH} should be committed in the repo"


def test_all_tables_built_with_correct_row_counts(built_con):
    for table, expected in EXPECTED_ROW_COUNTS.items():
        actual = built_con.execute(f'SELECT COUNT(*) FROM "{table}"').fetchone()[0]
        assert actual == expected, f"{table}: expected {expected} rows, got {actual}"


def test_storage_fcode_is_varchar(built_con):
    dtype = built_con.execute(
        "SELECT data_type FROM information_schema.columns "
        "WHERE table_name = 'storage' AND column_name = 'fcode'"
    ).fetchone()[0]
    assert dtype == "VARCHAR"


def test_courses_section_has_unique_surrogate_key(built_con):
    total = built_con.execute("SELECT COUNT(*) FROM courses_section").fetchone()[0]
    distinct = built_con.execute("SELECT COUNT(DISTINCT row_id) FROM courses_section").fetchone()[0]
    assert total == distinct


def test_string_values_are_trimmed(built_con):
    # The raw dump has 'Computer Science ' (trailing space) on some rows
    # and 'Computer Science' (clean) on others for the same department —
    # after trimming there should be exactly one form.
    values = built_con.execute(
        "SELECT DISTINCT depname FROM faculty WHERE TRIM(depname) = 'Computer Science'"
    ).fetchall()
    assert values == [("Computer Science",)]

    # Real typos in the data must survive trimming untouched — only
    # whitespace is normalized, never spelling.
    course = built_con.execute(
        "SELECT courseName FROM courses WHERE courseName ILIKE '%civic%'"
    ).fetchone()[0]
    assert course == "Civic Educaiton"


def test_schema_text_is_non_empty(built_con):
    assert len(get_schema_text(built_con)) > 100


def test_quality_checks_run_without_error(built_con):
    for _name, sql, _explanation in CHECKS:
        built_con.execute(sql).df()  # just confirm it runs; findings vary with the data


def test_computer_science_course_list_has_all_ten_code_section_pairs(built_con):
    actual = built_con.execute(
        """
        SELECT DISTINCT ca.corsecode, ca.coursesection
        FROM departments d
        JOIN faculty f ON LOWER(TRIM(f.depcode)) = LOWER(TRIM(d.depcode))
        JOIN courses_assign ca ON LOWER(TRIM(ca.fcode)) = LOWER(TRIM(f.fcode))
        WHERE LOWER(TRIM(d.depname)) = LOWER(TRIM('Computer Science'))
        ORDER BY ca.corsecode, ca.coursesection
        """
    ).fetchall()

    assert actual == [
        ("1212", "V21"),
        ("CC432", "V22"),
        ("CS110", "V21"),
        ("CS210", "V21"),
        ("CS220", "V21"),
        ("CS3022", "V21"),
        ("CS312", "V21"),
        ("CS321", "V21"),
        ("CS422", "V21"),
        ("CS431", "V22"),
    ]
    assert len({course_code for course_code, _section in actual}) == 10


def test_assessment_file_counts_for_faculty_23623(built_con):
    actual = dict(
        built_con.execute(
            """
            SELECT Assessment_type, COUNT(*)
            FROM storage
            GROUP BY Assessment_type
            ORDER BY Assessment_type
            """
        ).fetchall()
    )
    expected = {
        "Attendance": 1,
        "Awared_Sheet": 2,
        "Best_Folder": 9,
        "Course_Outline": 2,
        "FinalTerm": 2,
        "MidTerm": 2,
        "Quizzes": 2,
    }
    assert actual == expected

    by_faculty = dict(
        built_con.execute(
            """
            SELECT Assessment_type, COUNT(*)
            FROM storage
            WHERE TRIM(fcode) = '23623'
            GROUP BY Assessment_type
            """
        ).fetchall()
    )
    assert by_faculty == {
        "Awared_Sheet": 2,
        "Best_Folder": 9,
        "Course_Outline": 2,
        "FinalTerm": 1,
        "MidTerm": 2,
        "Quizzes": 2,
    }


def test_student_roster_returns_all_50_names_without_student_numbers_by_default(built_con):
    students = built_con.execute(
        'SELECT stud_id, stud_no, firstname, lastname, gender, "yr&sec" AS year_section FROM student ORDER BY stud_id'
    ).df()

    names_only = format_result_frame(students, "Tell me about all students")
    assert "Muhammad Ali" in names_only
    assert "Kinza Muneer" in names_only
    assert "202300501" not in names_only
    assert "202600110" not in names_only
    assert "Female" not in names_only
    assert len([line for line in names_only.splitlines() if line.startswith("|")]) == 52

    with_numbers = format_result_frame(students, "List all student names and student numbers")
    assert "202300501" in with_numbers
    assert "202600110" in with_numbers

    with_gender = format_result_frame(students, "Count and list student names and gender")
    assert "Female" in with_gender
    assert "Male" in with_gender


def test_full_person_name_match_handles_name_parts_in_either_field(built_con):
    rana = built_con.execute(
        """
        SELECT fcode, FirstName, LastName
        FROM faculty
        WHERE LOWER(CONCAT(TRIM(FirstName), ' ', TRIM(LastName))) ILIKE '%rana marwat%'
        """
    ).fetchall()
    assert rana == [("23623", "RANA MARWAT", "Hussain")]

    navid_roles = built_con.execute(
        """
        SELECT 'faculty' AS role, fcode AS role_code, FirstName, LastName
        FROM faculty
        WHERE LOWER(TRIM(FirstName)) ILIKE '%navid%'
          AND LOWER(TRIM(LastName)) ILIKE '%jamil%'
        UNION ALL
        SELECT 'dean' AS role, dcode AS role_code, FirstName, LastName
        FROM deans
        WHERE LOWER(CONCAT(TRIM(FirstName), ' ', TRIM(LastName))) ILIKE '%navid%jamil%malik%'
        """
    ).fetchall()
    assert {row[0] for row in navid_roles} == {"faculty", "dean"}

    adan_hints = resolve("who is Adan", build_cache(built_con))
    assert any(hint["matched"].casefold() == "adnan" for hint in adan_hints)


def test_known_answer_lists_all_computer_science_course_pairs(built_con):
    answer = answer_known_question(
        "List distinct course codes and sections associated with Computer Science",
        built_con,
    )

    assert answer is not None
    for course_code in ["1212", "CC432", "CS110", "CS210", "CS220", "CS3022", "CS312", "CS321", "CS422", "CS431"]:
        assert course_code in answer
    result_rows = [line for line in answer.splitlines() if line.startswith("|")]
    assert len(result_rows) == 12  # header + separator + all 10 data rows


def test_pipeline_answers_known_course_list_without_calling_groq(built_con):
    class _Completions:
        def create(self, **_kwargs):
            raise AssertionError("Groq should not be called for this known query")

    class _NoNetworkClient:
        def __init__(self):
            self.chat = type("Chat", (), {"completions": _Completions()})()

    result = answer_question(
        "List distinct course codes and sections associated with Computer Science",
        built_con,
        _NoNetworkClient(),
        {"faculty": [], "course": [], "department": [], "student": []},
    )

    assert result.kind == "query"
    assert result.attempts == 0
    assert "CS431" in result.answer


def test_known_answer_course_count_and_list_share_one_definition(built_con):
    count = answer_known_question(
        "How many distinct course codes are associated with the Computer Science department?",
        built_con,
    )
    combined = answer_known_question(
        "List the distinct course codes and sections for Computer Science and give the total distinct course-code count.",
        built_con,
    )

    assert count == "10"
    assert combined is not None
    assert "Distinct course-code count: 10." in combined
    assert combined.count("| CS") >= 8


def test_under_specified_top_courses_still_requires_clarification(built_con):
    assert answer_known_question("What are the top courses in Computer Science?", built_con) is None


def test_known_person_lookup_handles_compound_name_fields_and_roles(built_con):
    rana = answer_known_question("Tell me about Rana Marwat", built_con)
    navid = answer_known_question("Who is Dr. Navid Jamil Malik?", built_con)
    both_navid_roles = answer_known_question(
        "Check both dean and faculty records for Navid Jamil Malik and identify each role",
        built_con,
    )

    assert rana is not None
    assert "RANA MARWAT Hussain" in rana
    assert "Faculty" in rana
    assert "Coordinator" in rana
    assert "@" not in rana
    assert "23623" not in rana

    assert navid is not None
    assert "Dean" in navid
    assert "Navid" in navid
    assert "Management" in navid
    assert "NAVID Jamil" not in navid

    assert both_navid_roles is not None
    assert "Dean" in both_navid_roles
    assert "Faculty" in both_navid_roles
    assert "Navid Jamil" in both_navid_roles

    hints = resolve("Who is Dr. Navid Jamil Malik?", build_cache(built_con))
    assert {hint["label"] for hint in hints} >= {"dean", "faculty"}


def test_known_faculty_course_lookup_uses_full_name_and_preserves_codes(built_con):
    answer = answer_known_question(
        "Which courses does Rana Marwat teach?",
        built_con,
    )

    assert answer is not None
    assert "CC432" in answer
    assert "CS3022" in answer
    assert "thoeyr of automata" in answer
    assert "Civic Educaiton" in answer


def test_known_faculty_course_lookup_accepts_hyphenated_code(built_con):
    answer = answer_known_question(
        "Which courses are assigned to faculty code F-SST-003?",
        built_con,
    )

    assert answer is not None
    assert "Course code" in answer
