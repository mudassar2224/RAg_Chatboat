"""Central place to read secrets/config. Works both as a plain script
(``python -m db.sync``) and inside Streamlit (``st.secrets`` once you
deploy to Streamlit Community Cloud) without changing any calling code.
"""
import os

from dotenv import load_dotenv

load_dotenv()


def get_secret(key: str, default: str | None = None) -> str | None:
    try:
        import streamlit as st

        if key in st.secrets:
            return st.secrets[key]
    except Exception:
        pass
    return os.environ.get(key, default)
