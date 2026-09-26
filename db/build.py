"""Builds/refreshes the local DuckDB snapshot directly from the bundled
``data/db_sfms.sql`` dump. No MySQL, no XAMPP, no database server of any
kind — the dump file *is* the data, committed straight into the repo, and
this script parses it and loads it into DuckDB entirely in Python.

Runs automatically the first time app.py starts if no snapshot exists
yet. To force a rebuild (e.g. after replacing data/db_sfms.sql with a
newer dump)::

    uv run python -m db.build
"""
import re
from datetime import datetime, timezone
from pathlib import Path

import duckdb
import sqlglot
from sqlglot import expressions as exp

DUMP_PATH = "data/db_sfms.sql"
SNAPSHOT_PATH = "data/snapshot.duckdb"

# String values are trimmed of leading/trailing whitespace on the way in.
# The dump has plenty of that noise ('Computer Science ' vs 'Computer
# Science', 'RANA MARWAT  ' with a different number of trailing spaces on
# almost every row) and it was silently breaking exact-match queries —
# the LLM writes 'RANA MARWAT' and gets zero rows back because the real
# value has invisible trailing spaces. Trimming is safe because it only
# removes whitespace, never touches spelling — real typos in the data
# ('Civic Educaiton', 'thoeyr of automata') are left exactly as they are,
# since those are the actual test case for fuzzy matching.

_TYPE_MAP = {
    "TINYINT": "TINYINT",
    "SMALLINT": "SMALLINT",
    "MEDIUMINT": "INTEGER",
    "INT": "INTEGER",
    "BIGINT": "BIGINT",
    "VARCHAR": "VARCHAR",
    "CHAR": "VARCHAR",
    "TEXT": "VARCHAR",
    "LONGTEXT": "VARCHAR",
    "DATE": "DATE",
    "DATETIME": "TIMESTAMP",
    "TIMESTAMP": "TIMESTAMP",
    "DECIMAL": "DOUBLE",
    "FLOAT": "DOUBLE",
    "DOUBLE": "DOUBLE",
}

_CREATE_RE = re.compile(r"CREATE TABLE `(\w+)`.*?\n\) ENGINE=.*?;\n", re.DOTALL)
_INSERT_RE = re.compile(r"INSERT INTO `(\w+)`.*?VALUES\n(.*?);\n", re.DOTALL)


def _extract_statements(dump_text: str) -> tuple[dict[str, str], dict[str, str]]:
    """Pulls each table's CREATE TABLE block and INSERT...VALUES block out
    of the raw dump, skipping phpMyAdmin's SET/COMMIT/conditional-comment
    noise around them.
    """
    creates = {m.group(1): m.group(0) for m in _CREATE_RE.finditer(dump_text)}
    inserts = {m.group(1): m.group(0) for m in _INSERT_RE.finditer(dump_text)}
    return creates, inserts


def _columns_from_create(create_sql: str) -> list[tuple[str, str]]:
    """Returns [(name, duckdb_type), ...] for one CREATE TABLE block."""
    tree = sqlglot.parse_one(create_sql, read="mysql")
    columns = []
    for col_def in tree.find_all(exp.ColumnDef):
        kind = col_def.args.get("kind")
        raw_type = kind.sql(dialect="mysql").upper() if kind else "VARCHAR"
        base_type_match = re.match(r"[A-Z]+", raw_type)
        base_type = base_type_match.group(0) if base_type_match else "VARCHAR"
        columns.append((col_def.name, _TYPE_MAP.get(base_type, "VARCHAR")))
    return columns


def _literal_value(expr: exp.Expression):
    if isinstance(expr, exp.Null):
        return None
    if isinstance(expr, exp.Literal):
        if expr.is_string:
            return expr.this.strip()  # normalize whitespace noise (see below); never touch spelling
        text = expr.this
        return float(text) if "." in text else int(text)
    return expr.sql()


def _rows_from_insert(insert_sql: str) -> list[list]:
    tree = sqlglot.parse_one(insert_sql, read="mysql")
    return [[_literal_value(v) for v in tup.expressions] for tup in tree.find_all(exp.Tuple)]


def build() -> None:
    dump_text = Path(DUMP_PATH).read_text(encoding="utf-8")
    creates, inserts = _extract_statements(dump_text)
    if not creates:
        raise RuntimeError(f"No CREATE TABLE statements found in {DUMP_PATH} — is this the right file?")

    Path("data").mkdir(exist_ok=True)
    con = duckdb.connect(SNAPSHOT_PATH)

    for table, create_sql in creates.items():
        columns = _columns_from_create(create_sql)
        col_defs = ", ".join(f'"{name}" {dtype}' for name, dtype in columns)
        con.execute(f'CREATE OR REPLACE TABLE main."{table}" ({col_defs})')

        if table not in inserts:
            continue
        rows = _rows_from_insert(inserts[table])
        if not rows:
            continue
        placeholders = ", ".join("?" for _ in columns)
        con.executemany(f'INSERT INTO main."{table}" VALUES ({placeholders})', rows)

    _apply_fixes(con)

    con.execute("CREATE OR REPLACE TABLE main._meta (synced_at TIMESTAMP, source VARCHAR)")
    con.execute("INSERT INTO main._meta VALUES (?, ?)", [datetime.now(timezone.utc), DUMP_PATH])

    con.close()
    print(f"Built {len(creates)} tables into {SNAPSHOT_PATH} from {DUMP_PATH}")


def _apply_fixes(con: duckdb.DuckDBPyConnection) -> None:
    # storage.fcode is INT in the dump but faculty.fcode is VARCHAR
    # (values like 'F-SST-001'). Cast on the way in so string joins work.
    con.execute(
        """
        CREATE OR REPLACE TABLE main.storage AS
        SELECT store_id, filename, file_type, Assessment_type, date_uploaded,
               CAST(fcode AS VARCHAR) AS fcode, pattern, coursename, section
        FROM main.storage
        """
    )
    # courses_section has no usable primary key in the dump (sid is 0 for
    # every row, and there's no PRIMARY KEY on the table at all). Add a
    # real surrogate key.
    con.execute(
        """
        CREATE OR REPLACE TABLE main.courses_section AS
        SELECT ROW_NUMBER() OVER () AS row_id,
               coursecode, coursename, coursesection, session, creadedby
        FROM main.courses_section
        """
    )


if __name__ == "__main__":
    build()
