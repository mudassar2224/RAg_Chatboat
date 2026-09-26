from nlp.validate import is_safe


def test_select_allowed():
    ok, _ = is_safe("SELECT * FROM courses")
    assert ok


def test_select_with_cte_allowed():
    ok, _ = is_safe("WITH x AS (SELECT 1) SELECT * FROM x")
    assert ok


def test_case_insensitive_concatenated_name_query_is_safe():
    ok, _ = is_safe(
        "SELECT FirstName, LastName FROM faculty "
        "WHERE LOWER(CONCAT(FirstName, ' ', LastName)) ILIKE '%rana marwat%'"
    )
    assert ok


def test_select_star_from_safe_cte_over_sensitive_table_allowed():
    ok, _ = is_safe(
        "WITH safe_faculty AS (SELECT FirstName, LastName FROM faculty) "
        "SELECT * FROM safe_faculty"
    )
    assert ok


def test_select_star_inside_sensitive_cte_still_blocked():
    ok, reason = is_safe(
        "WITH unsafe_faculty AS (SELECT * FROM faculty) "
        "SELECT FirstName FROM unsafe_faculty"
    )
    assert not ok
    assert "SELECT *" in reason


def test_drop_blocked():
    ok, reason = is_safe("DROP TABLE faculty")
    assert not ok
    assert "read-only" in reason


def test_delete_blocked():
    ok, _ = is_safe("DELETE FROM faculty WHERE fid = 1")
    assert not ok


def test_update_blocked():
    ok, _ = is_safe("UPDATE faculty SET email = 'x' WHERE fid = 1")
    assert not ok


def test_stacked_statements_blocked():
    ok, reason = is_safe("SELECT * FROM faculty; DROP TABLE faculty;")
    assert not ok
    assert "multiple statements" in reason


def test_empty_blocked():
    ok, _ = is_safe("")
    assert not ok


def test_garbage_blocked():
    ok, _ = is_safe("this is not sql at all !!!")
    assert not ok


def test_keyword_in_comment_still_blocked():
    # Overly cautious on purpose: the keyword filter doesn't parse
    # comments, so a blocked word anywhere in the string is rejected.
    # Safer to over-block than to let a clever comment sneak one through.
    ok, _ = is_safe("SELECT * FROM faculty -- mentions INSERT in a comment")
    assert not ok


def test_create_prefix_in_column_name_not_falsely_blocked():
    # "createdon" contains "create" as a prefix but isn't the CREATE
    # keyword — word-boundary matching should not flag it.
    ok, _ = is_safe("SELECT createdon FROM faculty")
    assert ok


def test_password_column_blocked():
    ok, reason = is_safe("SELECT pass FROM faculty")
    assert not ok
    assert "credential" in reason


def test_password_column_blocked_with_table_alias():
    ok, _ = is_safe("SELECT f.pass FROM faculty f")
    assert not ok


def test_password_column_blocked_in_other_tables():
    ok, _ = is_safe("SELECT password FROM student")
    assert not ok
    ok, _ = is_safe("SELECT pass FROM coordiantor")
    assert not ok


def test_password_column_blocked_among_other_columns():
    ok, _ = is_safe("SELECT fcode, FirstName, LastName, pass FROM faculty")
    assert not ok


def test_select_star_on_sensitive_table_blocked():
    ok, reason = is_safe("SELECT * FROM faculty")
    assert not ok
    assert "SELECT *" in reason


def test_count_star_on_sensitive_table_allowed():
    ok, _ = is_safe("SELECT COUNT(*) AS student_count FROM student")
    assert ok


def test_qualified_select_star_on_sensitive_table_blocked():
    ok, reason = is_safe("SELECT f.* FROM faculty f")
    assert not ok
    assert "SELECT *" in reason


def test_select_star_on_non_sensitive_table_allowed():
    ok, _ = is_safe("SELECT * FROM courses")
    assert ok


def test_normal_faculty_columns_still_allowed():
    ok, _ = is_safe("SELECT fcode, FirstName, LastName, email FROM faculty")
    assert ok
