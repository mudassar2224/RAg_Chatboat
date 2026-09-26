"""Formats the DuckDB snapshot's schema as compact text for the LLM
prompt, plus static notes about how tables relate. There are no real
foreign keys in the source database, so the model has to be told.
"""
import duckdb

RELATIONSHIP_NOTES = """Notes (informal relationships — there are no enforced \
foreign keys in this database, so treat these as hints, not guarantees):
- departments.depcode is referenced by cods.depcode, deans.depcode, \
coordiantor.depcode, and faculty.depcode
- faculty.fcode is referenced by courses_assign.fcode and storage.fcode
- Names are not consistently split into given and family names across faculty, \
    coordinator, dean, and COD records. A FirstName field may contain multiple name \
    parts while LastName contains a later part. Do not assign each user name token to a \
    separate column. Match across CONCAT(FirstName, ' ', LastName) case-insensitively, \
    and search the role table(s) the user asked about.
- storage.fcode can be used to report files associated with a faculty record. \
    The field name alone does not prove that the faculty member personally uploaded \
    the file, so say "associated with" unless the source data explicitly establishes uploader identity.
- For department course counts, count distinct courses (courses_assign.corsecode), \
    not assignment rows or course-section offerings. When listing courses, include \
    every distinct course code returned and keep any requested section details.
- courses.coursecode is referenced by courses_assign.corsecode and \
courses_section.coursecode
- There is NO direct link between courses and departments. To find which \
courses "belong to" a department, you must go through faculty: match \
departments.depcode = faculty.depcode, then faculty.fcode = \
courses_assign.fcode, then read courses_assign.courseName/corsecode. \
Apply this every time such a question comes up, regardless of how the \
department name is spelled in the question.
- storage.coursename is free text typed by whoever uploaded the file — it \
is NOT a reliable match against courses.courseName (it may combine \
several course names, use different wording, or be misspelled). Prefer \
filtering storage by fcode or Assessment_type when possible; treat any \
coursename match as approximate, and use ILIKE rather than an exact match.
- The table named "coordiantor" is spelled that way in the real schema \
(missing an 'n') — use that exact spelling, it is not a typo to correct
- courses_section.row_id is a surrogate key added when this snapshot was \
built; the original sid column was unusable (always 0)
- departments does not have a row for every depcode referenced elsewhere — \
in particular, the SSH school has no rows there at all
- coordiantor has many rows sharing the same email address; don't assume \
email uniquely identifies a coordinator
"""


def get_schema_text(con: duckdb.DuckDBPyConnection) -> str:
    tables = con.execute(
        """
        SELECT table_name FROM information_schema.tables
        WHERE table_schema = 'main' AND table_name != '_meta'
        ORDER BY table_name
        """
    ).fetchall()

    lines = []
    for (table,) in tables:
        cols = con.execute(
            """
            SELECT column_name, data_type FROM information_schema.columns
            WHERE table_schema = 'main' AND table_name = ?
            ORDER BY ordinal_position
            """,
            [table],
        ).fetchall()
        col_text = ", ".join(f"{name} {dtype}" for name, dtype in cols)
        lines.append(f"{table}({col_text})")

    return "\n".join(lines) + "\n\n" + RELATIONSHIP_NOTES
