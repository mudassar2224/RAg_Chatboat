"""Read-only data-quality checks, grounded in the actual issues found in
this database. Each entry is (name, sql, explanation); the SQL returns
the offending rows so the UI shows real, current numbers — never
hard-coded ones.
"""

CHECKS = [
    (
        "Departments referenced but missing",
        """
        SELECT DISTINCT depcode, depschool FROM (
            SELECT depcode, depschool FROM cods
            UNION SELECT depcode, depschool FROM deans
            UNION SELECT depcode, depschool FROM coordiantor
            UNION SELECT depcode, depschool FROM faculty
        ) refs
        WHERE depcode NOT IN (SELECT depcode FROM departments)
        ORDER BY depschool, depcode
        """,
        "Department codes used by staff records but absent from the departments table.",
    ),
    (
        "Duplicate coordinator emails",
        """
        SELECT email, COUNT(*) AS n
        FROM coordiantor
        GROUP BY email
        HAVING COUNT(*) > 1
        ORDER BY n DESC
        """,
        "The same email address is used across more than one coordinator record.",
    ),
    (
        "Tripled COD department assignments",
        """
        SELECT cocode, COUNT(*) AS n
        FROM cod_assigndep
        GROUP BY cocode
        HAVING COUNT(*) <> 1
        ORDER BY n DESC
        """,
        "Each COD should have exactly one assignment row per department; anything else is a duplicate insert.",
    ),
    (
        "Storage records with no matching faculty",
        """
        SELECT DISTINCT s.fcode
        FROM storage s
        LEFT JOIN faculty f ON s.fcode = f.fcode
        WHERE f.fcode IS NULL
        """,
        "File uploads whose fcode doesn't match any faculty record.",
    ),
]
