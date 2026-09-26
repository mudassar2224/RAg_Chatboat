import logging
from pathlib import Path

import duckdb
import streamlit as st

from core.intents import route_message
from core.groq_accounts import build_groq_account_pool
from core.pipeline import answer_question
from db.build import DUMP_PATH, SNAPSHOT_PATH, build as build_snapshot
from nlp.entities import build_cache

# Everything about how an answer was produced (generated SQL, retries,
# entity-resolution hints) goes here, not into the UI. Run
# `streamlit run app.py` in a terminal and watch that terminal.
logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")

st.set_page_config(page_title="SFMS chatbot", page_icon="🎓", layout="wide")


@st.cache_resource
def get_connection(snapshot_signature: tuple[int, int]):
    # The signature is a cache key so rebuilding the snapshot refreshes the
    # read-only connection on the next Streamlit rerun.
    return duckdb.connect(SNAPSHOT_PATH, read_only=True)


@st.cache_resource
def ensure_snapshot():
    if not Path(DUMP_PATH).exists():
        st.error(f"`{DUMP_PATH}` is missing — the app has no data to build from.")
        st.stop()
    if not Path(SNAPSHOT_PATH).exists():
        with st.spinner("First run — building the database from data/db_sfms.sql..."):
            build_snapshot()


@st.cache_resource
def get_client():
    return build_groq_account_pool()


@st.cache_resource
def get_entity_cache(_con, snapshot_signature: tuple[int, int]):
    return build_cache(_con)


ensure_snapshot()
snapshot_stat = Path(SNAPSHOT_PATH).stat()
snapshot_signature = (snapshot_stat.st_mtime_ns, snapshot_stat.st_size)
con = get_connection(snapshot_signature)
cache = get_entity_cache(con, snapshot_signature)

st.title("SFMS assistant", anchor=False)
st.caption("Ask about students, faculty, courses, departments, and uploaded files.")

if "history" not in st.session_state:
    st.session_state.history = []

for turn in st.session_state.history:
    with st.chat_message(turn["role"]):
        st.write(turn["content"])

if not st.session_state.history:
    st.markdown("#### Welcome! What would you like to know?")
    st.caption("Try: “How many students are there?” or “Which faculty teach Artificial Intelligence?”")

question = st.chat_input("Message the SFMS assistant…")
if question:
    st.session_state.history.append({"role": "user", "content": question})
    with st.chat_message("user"):
        st.write(question)

    local_reply, db_question = route_message(question)
    with st.chat_message("assistant"):
        if local_reply is not None:
            answer = local_reply
            st.write(answer)
        else:
            with st.spinner("Checking the SFMS data…"):
                result = answer_question(
                    db_question,
                    con,
                    get_client(),
                    cache,
                    conversation_history=st.session_state.history[:-1][-6:],
                )
            answer = result.answer
            st.write(answer)

    st.session_state.history.append({"role": "assistant", "content": answer})

if st.session_state.history and st.button("Clear conversation"):
    st.session_state.history = []
    st.rerun()
