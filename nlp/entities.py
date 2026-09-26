"""Builds a cache of known names/codes from the database and resolves
fuzzy or misspelled mentions of them in a user's question. This runs
*before* the LLM call so the model gets a correction hint instead of
having to guess spellings itself.
"""
import re

import duckdb
from rapidfuzz import fuzz, process

# (table, single-value columns, [pairs of columns to also join as a full
# name], label used in hints). Matching "Adnan Abed" against a combined
# "Adnan Abid" full name scores far better than matching single words —
# most questions name a person by their full name, so both need to be in
# the cache.
SOURCES = [
    ("faculty", ["FirstName", "LastName", "fcode"], [("FirstName", "LastName")], "faculty"),
    ("deans", ["FirstName", "LastName", "dcode"], [("FirstName", "LastName")], "dean"),
    ("coordiantor", ["FirstName", "LastName", "ccode"], [("FirstName", "LastName")], "coordinator"),
    ("cods", ["FirstName", "LastName", "cocode"], [("FirstName", "LastName")], "cod"),
    ("courses", ["courseName", "coursecode"], [], "course"),
    ("departments", ["depname", "depcode"], [], "department"),
    ("student", ["firstname", "lastname"], [("firstname", "lastname")], "student"),
]

_QUESTION_WORDS = {
    "a", "about", "all", "an", "and", "are", "by", "can", "could", "data",
    "database", "do", "does", "each", "file", "files", "find", "for", "from",
    "give", "has", "have", "hello", "help", "how", "i", "in", "is", "list",
    "many", "me", "of", "on", "or", "please", "show", "student", "students",
    "tell", "that", "the", "there", "to", "uploaded", "what", "which", "who", "with",
    "associated", "assessment", "code", "courses", "department", "faculty", "match",
    "members", "name", "recorded", "teach", "taught", "types",
}


def _normalize_phrase(text: str) -> str:
    """Remove surrounding punctuation without damaging hyphenated codes."""
    text = text.replace("’", "'").replace("‘", "'").replace("“", '"').replace("”", '"')
    return " ".join(re.sub(r"[^\w\s-]", " ", text, flags=re.UNICODE).casefold().split())


def build_cache(con: duckdb.DuckDBPyConnection) -> dict[str, list[str]]:
    cache: dict[str, set[str]] = {}
    for table, columns, name_pairs, label in SOURCES:
        values = cache.setdefault(label, set())
        for col in columns:
            try:
                rows = con.execute(
                    f"SELECT DISTINCT {col} FROM {table} WHERE {col} IS NOT NULL"
                ).fetchall()
            except Exception:
                continue  # table/column not present in this snapshot
            values.update(str(r[0]) for r in rows if r[0])
        for first_col, last_col in name_pairs:
            try:
                rows = con.execute(
                    f"SELECT DISTINCT {first_col}, {last_col} FROM {table} "
                    f"WHERE {first_col} IS NOT NULL AND {last_col} IS NOT NULL"
                ).fetchall()
            except Exception:
                continue
            values.update(f"{first} {last}" for first, last in rows if first and last)
    return {label: sorted(values) for label, values in cache.items()}


def _best_match(phrase: str, values: list[str], score_cutoff: int):
    """Like process.extractOne, but breaks ties in favor of the candidate
    whose length is closest to the phrase's. WRatio's partial-ratio
    component can score a short substring (e.g. "Adnan" inside "Adnan
    Abed") exactly as high as a longer, more complete match ("Adnan
    Abid") — plain extractOne would then arbitrarily return whichever one
    happens to sort first, which is usually the less useful one.
    """
    # Single-word names need a stricter threshold than full names: this catches
    # clear typos such as "Adan" -> "Adnan" without guessing the weaker
    # "Rana" -> "Raza" match.
    is_code = bool(re.search(r"\d", phrase))
    if " " in phrase:
        values = [value for value in values if " " in _normalize_phrase(value)]
        if not values:
            return None
    if " " in phrase:
        scorer = lambda left, right, **_kwargs: fuzz.token_set_ratio(
            left.casefold(), right.casefold()
        )
    else:
        scorer = lambda left, right, **_kwargs: fuzz.ratio(
            left.casefold(), right.casefold()
        )
    effective_cutoff = score_cutoff if " " in phrase or is_code else max(score_cutoff, 88)
    results = process.extract(
        phrase,
        values,
        scorer=scorer,
        score_cutoff=effective_cutoff,
        limit=None,
    )
    if not results:
        return None
    top_score = max(r[1] for r in results)
    # Token-set matching can score a first-name-only candidate above a
    # near-complete full name (e.g. "Adnan" 100 vs "Adnan Abid" 90).
    # Keep near-top candidates for multiword phrases and prefer the most
    # complete cached entity; single-word code matching stays strict.
    margin = 12 if " " in phrase else 1
    near_top = [r for r in results if r[1] >= top_score - margin]
    return max(
        near_top,
        key=lambda r: (len(r[0]), -abs(len(r[0]) - len(phrase)), r[1]),
    )


def resolve(question: str, cache: dict[str, list[str]], score_cutoff: int = 75) -> list[dict]:
    """Finds words/phrases in the question that closely — but not exactly
    — match a known name or code. Returns hints sorted best-match first,
    each as {"input", "matched", "label", "score"}.
    """
    words = [
        word
        for word in _normalize_phrase(question).split()
        if word not in _QUESTION_WORDS and len(word) >= 3
    ]
    candidates = set(words)
    for n in (2, 3):
        candidates.update(" ".join(words[i : i + n]) for i in range(len(words) - n + 1))

    best: dict[tuple[str, str], dict] = {}
    for phrase in sorted(candidates):
        clean = _normalize_phrase(phrase)
        if len(clean) < 3 or all(word in _QUESTION_WORDS for word in clean.split()):
            continue
        exact_labels = {
            label
            for label, values in cache.items()
            if any(clean == _normalize_phrase(value) for value in values)
        }
        for label, values in cache.items():
            if not values:
                continue
            if exact_labels and label not in exact_labels:
                continue  # exact names/codes must not fuzzy-match another entity type
            result = _best_match(clean, values, score_cutoff)
            if not result:
                continue
            matched, score, _ = result
            if _normalize_phrase(matched) == clean:
                continue  # exact match, nothing to hint
            key = (clean, label)
            if key not in best or score > best[key]["score"]:
                best[key] = {"input": clean, "matched": matched, "label": label, "score": score}

    # Different candidate phrases can still resolve to the same underlying
    # entity at different levels of completeness (one matching "Adnan",
    # another matching "Adnan Abid"). Keep only the most complete match
    # per entity — the one with the longest matched value — and drop the
    # redundant, less specific ones.
    by_match_length = sorted(best.values(), key=lambda m: -len(m["matched"]))
    kept: list[dict] = []
    for hint in by_match_length:
        if any(
            hint["label"] == previous["label"]
            and _normalize_phrase(hint["matched"]) in _normalize_phrase(previous["matched"])
            for previous in kept
        ):
            continue
        kept.append(hint)

    return sorted(kept, key=lambda m: -m["score"])
