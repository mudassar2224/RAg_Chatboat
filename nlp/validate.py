"""Safety check for LLM-generated SQL. Runs before anything is executed,
regardless of how confident the model seemed. Only a single read-only
SELECT (optionally wrapped in a WITH/CTE) is allowed, and it may never
touch a column that holds credentials.
"""
import re

import sqlglot
from sqlglot import expressions as exp

_BLOCKED = re.compile(
    r"\b(INSERT|UPDATE|DELETE|DROP|ALTER|CREATE|TRUNCATE|GRANT|REVOKE|ATTACH|DETACH|PRAGMA)\b",
    re.IGNORECASE,
)

# Every column across the schema that holds a credential. Selecting any of
# these — explicitly, through an alias, or via SELECT * on one of these
# tables — is rejected outright. This is deliberately blunt (a name-based
# blocklist, not a permissions system) because the schema is small and
# every one of these columns is genuinely a password, nothing more
# sophisticated is needed here.
_SENSITIVE_COLUMNS = {"pass", "password"}
_SENSITIVE_TABLES = {"cods", "coordiantor", "deans", "faculty", "student", "user"}


def _check_sensitive(tree: exp.Expression) -> tuple[bool, str]:
    for col in tree.find_all(exp.Column):
        if col.name.lower() in _SENSITIVE_COLUMNS:
            return False, f"the '{col.name}' column can't be returned — it holds a credential"

    # Only a wildcard in the SELECT projection returns every column. A
    # star inside COUNT(*) is an aggregate argument, not SELECT *.
    for select in tree.find_all(exp.Select):
        projects_all_columns = any(
            isinstance(projection, exp.Star)
            or (
                isinstance(projection, exp.Column)
                and isinstance(projection.this, exp.Star)
            )
            for projection in select.expressions
        )
        if not projects_all_columns:
            continue
        from_clause = select.args.get("from_")
        sources = []
        if from_clause is not None:
            sources.append(from_clause.this)
            sources.extend(from_clause.expressions)
        sources.extend(
            join.this for join in (select.args.get("joins") or [])
        )

        # Inspect only this SELECT's direct table sources. A CTE name is
        # not itself a sensitive table; its own SELECT is checked
        # separately by the outer tree traversal above.
        for source in sources:
            if not isinstance(source, exp.Table):
                continue
            table = source
            if table.name.lower() in _SENSITIVE_TABLES:
                return False, (
                    f"'SELECT *' on '{table.name}' would include a credential column — "
                    "list the specific columns you need instead"
                )
    return True, "ok"


def is_safe(sql: str) -> tuple[bool, str]:
    """Returns (is_safe, reason). ``reason`` explains the rejection when
    False, or is "ok" when True.
    """
    if not sql or not sql.strip():
        return False, "empty query"

    stripped = sql.strip().rstrip(";").strip()

    if ";" in stripped:
        return False, "multiple statements separated by ';' aren't allowed"

    if _BLOCKED.search(stripped):
        return False, "only read-only SELECT queries are allowed"

    try:
        tree = sqlglot.parse_one(stripped, read="mysql")
    except Exception as e:
        return False, f"couldn't parse the SQL: {e}"

    if not isinstance(tree, (exp.Select, exp.Union)):
        return False, f"only SELECT statements are allowed, got {type(tree).__name__}"

    ok, reason = _check_sensitive(tree)
    if not ok:
        return False, reason

    return True, "ok"
