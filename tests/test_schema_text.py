from db.schema_text import get_schema_text


def test_schema_text_includes_all_tables(db):
    text = get_schema_text(db)
    for table in ["faculty", "courses", "departments", "student"]:
        assert table in text
    assert "_meta" not in text  # internal table, not part of the schema shown to the model


def test_schema_text_includes_relationship_notes(db):
    text = get_schema_text(db)
    assert "coordiantor" in text  # the spelling note should be present
    assert "courses_assign.corsecode" in text
    assert 'say "associated with"' in text
    assert "Do not assign each user name token to a" in text
    assert "CONCAT(FirstName" in text
