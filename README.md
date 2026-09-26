# SFMS chatbot

Natural-language Q&A over the UMT SFMS database. No MySQL, no XAMPP, no
database server of any kind — `data/db_sfms.sql` is committed straight
into this repo, and the app builds a local DuckDB file from it directly.

## 1. Install dependencies

```
uv sync
```

If pytest doesn't get installed, run `uv sync --all-groups`.

## 2. Configure Groq accounts

Copy `.env.example` to `.env` if you do not already have an `.env` file. On
Windows PowerShell, use `Copy-Item .env.example .env`.

Set up to three Groq keys in `.env` (or Streamlit Secrets when deployed):

- `GROQ_API_KEY`
- `GROQ_API_KEY_1`
- `GROQ_API_KEY_2`

The app tries the keys in that order. Empty keys are skipped. When one account
is rate-limited or unavailable, the app tries the next configured key and
temporarily skips the limited key according to its reset delay. Set
`GROQ_MODEL` to change the model. See `.env.example` for the variable names.
Groq quotas can be shared at the organization level: multiple keys from one
organization do not necessarily provide extra quota. Use account failover only
where it complies with Groq's terms and each account's limits.

**Security:** never commit `.env` or paste API keys into chat, screenshots, or
logs. If a key was exposed, revoke it with that provider and replace it.

## 3. Run the tests

```
uv run pytest
```

Tests, no skips — none of them need a network connection, a database
server, or your `.env`. `tests/test_build.py` runs the real parser
against the real committed `data/db_sfms.sql`; the rest use an in-memory
DuckDB and a fake LLM client to check the SQL safety filter (including
the credential-column blocklist), fuzzy-entity matching, and the
retry/branching logic. Snapshot-backed regression checks cover course-list
completeness, role/name matching, assessment totals, privacy filtering, and
result rendering without provider calls.

## 4. Run the app

```
uv run streamlit run app.py
```

Opens at http://localhost:8501. The first run builds
`data/snapshot.duckdb` from the SQL dump automatically.

**The UI shows only the final, natural-language answer** — no SQL, no
raw tables, no debug panel. Run the app from a terminal and *that*
terminal is where the generated SQL, entity-resolution hints, retries
and row counts get logged (`logging.INFO` level) — useful for you while
developing, invisible to anyone using the app.

## Project layout

```
app.py                  Streamlit chat UI — answer-only, no debug UI
core/config.py           secrets (env var locally, st.secrets once deployed)
core/groq_accounts.py   ordered fallback across configured Groq API keys
core/known_answers.py   deterministic department-course and staff lookups
core/results.py         complete-row formatting and output privacy filtering
core/pipeline.py          deterministic answers or resolve -> generate -> validate -> execute
db/build.py                parses data/db_sfms.sql straight into DuckDB — no MySQL, ever
db/schema_text.py           formats the schema (+ relationship notes) for the LLM prompt
nlp/entities.py               fuzzy name/code matching (RapidFuzz), no embeddings needed at this scale
nlp/llm.py                     tool-calling prompt and the 3 model actions
nlp/validate.py                  SQL safety check — read-only, and blocks credential columns outright
quality/checks.py                 read-only data-quality queries for maintenance
data/db_sfms.sql                    the actual data — committed, portable, the single source of truth
tests/                                see step 3
```

## How "handle any question carefully" actually works here

- The full schema is always in the prompt — the model is never left to
  guess a column name.
- **Text comparisons are case- and whitespace-insensitive by instruction.**
  The real data has inconsistent capitalization and stray trailing spaces
  throughout (fixed at the whitespace level during `db/build.py`, but
  casing varies too), so the system prompt requires `LOWER(TRIM(...))`
  for equality and `ILIKE` for partial matches on every query — this is
  what was silently causing "no results" on several real test questions
  before (e.g. a case-sensitive `LIKE '%Automata%'` against data stored
  as lowercase `automata`).
- Typos and near-misses in names/codes are caught by `nlp/entities.py`
  *before* the LLM call and passed in as hints, and the prompt now
  explicitly requires using that hinted value rather than guessing a
  pattern from the user's original spelling.
- The model has exactly three moves: run a query, ask a clarifying
  question, or say it can't answer from this database — never silently
  invent an answer.
- Every generated query is parsed and checked by `nlp/validate.py` before
  it touches the database: only a single read-only `SELECT`/`WITH` gets
  through, **and any column named `pass` or `password` — or a `SELECT *`
  on a table that has one — is rejected outright**, regardless of how the
  question was phrased. This was a real gap earlier: asking directly for
  "every faculty member's password" actually returned real plaintext
  passwords, since only write operations were blocked before. Fixed at
  the validator level, not by relying on the model to refuse.
- A failed query (rejected by the validator, or a real DB error) is fed
  back to the model with the specific problem, capped at 2 retries.
- Known department-course and person lookups use parameterized local SQL,
  with no LLM request. Other query rows are rendered deterministically so
  the model cannot omit list items or invent result details. This also
  avoids sending database result rows to a second LLM call.
- Unrequested contact details, internal audit fields, and student identifiers
  are removed before display. Student names are available for authorized
  local use; student numbers and gender appear only when explicitly asked for.
  Add authentication before exposing real student records beyond a trusted
  environment.
- There is no direct courses-to-departments link in the schema — the
  system prompt now spells out the exact join path (department → faculty
  → courses_assign) so this works consistently regardless of typos in
  the department name, instead of the model reasoning it out fresh (and
  inconsistently) each time.

## Replacing the data later

When your sir hands over the real UMT database (or you just want newer
demo data), drop the new dump in as `data/db_sfms.sql` (same filename,
same table names), delete `data/snapshot.duckdb`, and run
`uv run python -m db.build` — or just restart the app, which rebuilds
automatically when the snapshot is missing. If the new dump's table or
column names differ, `nlp/entities.py`'s `SOURCES` list,
`db/schema_text.py`'s `RELATIONSHIP_NOTES`, and `nlp/validate.py`'s
`_SENSITIVE_COLUMNS`/`_SENSITIVE_TABLES` are the places that reference
specific column names and will need updating to match.

## When you're ready to deploy

Since there's no live database dependency, deployment is simple: commit
`data/db_sfms.sql` (already done), push to GitHub, connect the repo on
Streamlit Community Cloud, and add the Groq account keys you want to use in
its Secrets (`GROQ_API_KEY`, `GROQ_API_KEY_1`, and `GROQ_API_KEY_2`). The
first load there builds the snapshot the same way it does locally. Ask
when you're ready and we'll do that step together.
