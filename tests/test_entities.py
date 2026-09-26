from nlp.entities import build_cache, resolve


def test_build_cache_includes_faculty_names(db):
    cache = build_cache(db)
    assert "Abid" in cache["faculty"]
    assert "F-SST-003" in cache["faculty"]


def test_build_cache_includes_courses_and_departments(db):
    cache = build_cache(db)
    assert "Artificial Intelligence" in cache["course"]
    assert "Computer Science" in cache["department"]


def test_resolve_finds_close_misspelling(db):
    cache = build_cache(db)
    hints = resolve("show files uploaded by Adnan Abed", cache)
    matched_names = [h["matched"] for h in hints]
    # Should resolve to the full, correct name — not just a partial
    # fragment like "Adnan" (which is already spelled correctly in the
    # question and isn't the useful correction here).
    assert "Adnan Abid" in matched_names


def test_resolve_does_not_guess_from_a_single_person_name(db):
    cache = build_cache(db)
    assert resolve("tell me about Rana", cache) == []


def test_resolve_high_confidence_single_name_typo():
    cache = {
        "faculty": ["Adnan", "Sara"],
        "dean": [],
        "coordinator": [],
        "cod": [],
        "course": [],
        "department": [],
        "student": [],
    }
    hints = resolve("who is Adan", cache)
    assert any(hint["matched"] == "Adnan" for hint in hints)


def test_exact_single_name_does_not_suggest_similar_person():
    cache = {
        "faculty": ["Rana"],
        "dean": ["Raza"],
        "coordinator": [],
        "cod": [],
        "course": [],
        "department": [],
        "student": [],
    }
    hints = resolve("tell me about Rana", cache)
    assert not any(hint["matched"] == "Raza" for hint in hints)


def test_resolve_full_partial_name_without_changing_first_name():
    cache = {
        "faculty": ["Rana", "Raza", "RANA MARWAT", "RANA MARWAT Hussain"],
        "course": [],
        "department": [],
        "student": [],
    }
    hints = resolve("tell me about Rana Marwat", cache)
    assert any(
        hint["label"] == "faculty"
        and hint["matched"].casefold() == "rana marwat hussain"
        for hint in hints
    )
    assert not any(hint["matched"].casefold() == "raza" for hint in hints)


def test_full_name_typo_prefers_faculty_name_over_student_first_name():
    cache = {
        "faculty": ["Adnan", "Adnan Abid"],
        "course": [],
        "department": [],
        "student": ["Adnan"],
    }
    hints = resolve("show files for Adnan Abed", cache)
    assert any(
        hint["label"] == "faculty" and hint["matched"] == "Adnan Abid"
        for hint in hints
    )
    assert not any(hint["matched"] == "Adnan" for hint in hints)


def test_resolve_ignores_exact_matches(db):
    cache = build_cache(db)
    hints = resolve("show courses taught by Sara Khan", cache)
    # "Khan" is an exact match already in the cache, so it shouldn't be
    # flagged as a correction
    assert not any(h["input"].lower() == "khan" for h in hints)


def test_resolve_empty_question(db):
    cache = build_cache(db)
    assert resolve("", cache) == []


def test_resolve_ignores_generic_words_in_count_question(db):
    cache = build_cache(db)
    assert resolve("How many students are in the database?", cache) == []


def test_resolve_normalizes_curly_quotes_and_exact_code(db):
    cache = build_cache(db)
    known_code = next(value for value in cache["faculty"] if value.startswith("F-SST-"))
    assert resolve(f"What files match ‘{known_code}’？", cache) == []
