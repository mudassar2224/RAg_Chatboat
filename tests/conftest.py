"""Shared pytest fixtures — a tiny in-memory DuckDB shaped like the real
snapshot, so most tests don't need a live MySQL connection.
"""
import duckdb
import pytest


@pytest.fixture
def db():
    con = duckdb.connect(":memory:")
    con.execute(
        """
        CREATE TABLE faculty (
            fid INTEGER, fcode VARCHAR, FirstName VARCHAR, LastName VARCHAR,
            email VARCHAR, depcode VARCHAR
        )
        """
    )
    con.execute(
        """
        INSERT INTO faculty VALUES
            (1, 'F-SST-003', 'Adnan', 'Abid', 'adnan.abid@umt.edu.pk', 'SST-01'),
            (2, 'F-SST-001', 'Sara', 'Khan', 'sara.khan@umt.edu.pk', 'SST-01')
        """
    )
    con.execute(
        """
        CREATE TABLE courses (
            cid INTEGER, coursecode VARCHAR, courseName VARCHAR
        )
        """
    )
    con.execute("INSERT INTO courses VALUES (1, 'CS3022', 'Artificial Intelligence')")
    con.execute(
        """
        CREATE TABLE departments (
            did INTEGER, depcode VARCHAR, depname VARCHAR, depschool VARCHAR
        )
        """
    )
    con.execute("INSERT INTO departments VALUES (1, 'SST-01', 'Computer Science', 'SST')")
    con.execute(
        """
        CREATE TABLE student (
            stud_id INTEGER, firstname VARCHAR, lastname VARCHAR
        )
        """
    )
    con.execute("INSERT INTO student VALUES (1, 'Bilal', 'Hassan')")
    con.execute("CREATE TABLE _meta (synced_at TIMESTAMP)")
    con.execute("INSERT INTO _meta VALUES (CURRENT_TIMESTAMP)")
    yield con
    con.close()
