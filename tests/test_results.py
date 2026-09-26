import pandas as pd

from core.results import format_result_frame, sanitize_result_frame


def test_full_list_renderer_includes_every_course_row_and_matching_count():
    courses = pd.DataFrame(
        [(f"CS{i:03}", f"V{i % 3 + 1}") for i in range(10)],
        columns=["course_code", "section"],
    )

    answer = format_result_frame(courses, "List all distinct course codes and sections")

    assert answer.count("| CS") == 10
    assert "CS009" in answer
    assert len(courses) == 10


def test_single_aggregate_result_is_returned_exactly():
    answer = format_result_frame(
        pd.DataFrame({"student_count": [50]}),
        "How many students are there? Return only the count.",
    )
    assert answer == "50"


def test_unrequested_contacts_and_audit_metadata_are_removed():
    frame = pd.DataFrame(
        {
            "FirstName": ["Rana"],
            "LastName": ["Marwat Hussain"],
            "email": ["private@example.invalid"],
            "contactno": ["0000000000"],
            "createdby": ["internal-user"],
            "createdon": ["2025-09-27"],
            "depname": ["Computer Science"],
        }
    )

    safe_frame, refusal = sanitize_result_frame(frame, "Tell me about Rana Marwat")

    assert refusal is None
    assert list(safe_frame.columns) == ["Name", "depname"]
    assert safe_frame.iloc[0]["Name"] == "Rana Marwat Hussain"
    answer = format_result_frame(frame, "Tell me about Rana Marwat")
    assert "private@example.invalid" not in answer
    assert "0000000000" not in answer
    assert "internal-user" not in answer


def test_contact_field_is_retained_only_when_explicitly_requested():
    frame = pd.DataFrame({"email": ["staff@example.invalid"], "phone": ["111"]})

    safe_frame, _ = sanitize_result_frame(frame, "Show the email address")

    assert list(safe_frame.columns) == ["email"]


def test_sensitive_aliases_and_passwords_are_filtered():
    frame = pd.DataFrame(
        {
            "contact_details": ["private@example.invalid"],
            "student_identifier": ["STUDENT-123"],
            "password_hint": ["secret-looking-value"],
            "role": ["Faculty"],
        }
    )

    answer = format_result_frame(frame, "List the person's role")

    assert "Faculty" in answer
    assert "private@example.invalid" not in answer
    assert "STUDENT-123" not in answer
    assert "secret-looking-value" not in answer


def test_student_roster_can_be_shown_but_identifiers_need_an_explicit_request():
    roster = pd.DataFrame(
        {
            "firstname": ["Student A", "Student B"],
            "stud_no": ["A1", "B2"],
            "gender": ["Female", "Male"],
        }
    )
    names_only = format_result_frame(roster, "Show all students")
    assert "Student A" in names_only and "Student B" in names_only
    assert "A1" not in names_only and "B2" not in names_only
    assert "Female" not in names_only and "Male" not in names_only

    include_numbers = format_result_frame(roster, "Show all student names and student numbers")
    assert "A1" in include_numbers and "B2" in include_numbers

    include_gender = format_result_frame(roster, "Show student names and gender")
    assert "Female" in include_gender and "Male" in include_gender

    grouped = pd.DataFrame(
        {"gender": ["Female", "Male"], "section": ["V21", "V21"], "count": [10, 10]}
    )
    allowed = format_result_frame(grouped, "Count students by gender and section")
    assert "Female" in allowed and "Male" in allowed

def test_salary_slip_filename_is_redacted():
    frame = pd.DataFrame(
        {"filename": ["quiz1.pdf", "Salary Slip - employee 12345.pdf"]}
    )

    answer = format_result_frame(frame, "List uploaded files")

    assert "quiz1.pdf" in answer
    assert "12345" not in answer
    assert "salary-related filename withheld" in answer


def test_database_text_is_escaped_before_markdown_rendering():
    answer = format_result_frame(
        pd.DataFrame({"Course name": ["<script>alert(1)</script>"]}),
        "List course names",
    )

    assert "<script>" not in answer
    assert "&lt;script&gt;" in answer
