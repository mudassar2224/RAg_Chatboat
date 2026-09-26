import time
from types import SimpleNamespace

import pytest

from core.groq_accounts import (
    GroqAccountPool,
    GroqAccountsError,
    build_groq_account_pool,
)


class _Completions:
    def __init__(self, action, calls):
        self.action = action
        self.calls = calls

    def create(self, **kwargs):
        self.calls.append(kwargs)
        if isinstance(self.action, Exception):
            raise self.action
        return self.action


class _FakeGroqClient:
    def __init__(self, action, calls):
        self.chat = type(
            "Chat",
            (),
            {"completions": _Completions(action, calls)},
        )()


def _factory_for(responses, calls_by_key):
    def factory(*, api_key, **_kwargs):
        return _FakeGroqClient(responses[api_key], calls_by_key[api_key])

    return factory


def test_build_pool_uses_three_key_slots_in_order_and_deduplicates():
    values = {
        "GROQ_API_KEY": "key-primary",
        "GROQ_API_KEY_1": "key-backup-one",
        "GROQ_API_KEY_2": "key-backup-two",
        "GROQ_MODEL": "test-model",
    }
    pool = build_groq_account_pool(
        lambda name, default=None: values.get(name, default),
        client_factory=lambda **kwargs: object(),
    )

    account_names = [account.key_name for account, _client in pool._accounts]
    assert account_names == ["GROQ_API_KEY", "GROQ_API_KEY_1", "GROQ_API_KEY_2"]
    assert pool.model == "test-model"

    values["GROQ_API_KEY_2"] = "key-primary"
    deduplicated = build_groq_account_pool(
        lambda name, default=None: values.get(name, default),
        client_factory=lambda **kwargs: object(),
    )
    assert [account.key_name for account, _client in deduplicated._accounts] == [
        "GROQ_API_KEY", "GROQ_API_KEY_1"
    ]


def test_fallback_uses_next_account_and_same_model():
    calls = {key: [] for key in ("key-one", "key-two")}
    responses = {
        "key-one": RuntimeError("quota exhausted"),
        "key-two": {"success": True},
    }
    pool = build_groq_account_pool(
        lambda name, default=None: {
            "GROQ_API_KEY": "key-one",
            "GROQ_API_KEY_1": "key-two",
            "GROQ_MODEL": "shared-model",
        }.get(name, default),
        client_factory=_factory_for(responses, calls),
    )

    result = pool.chat.completions.create(model="ignored-model", messages=[])

    assert result == {"success": True}
    assert calls["key-one"][0]["model"] == "shared-model"
    assert calls["key-two"][0]["model"] == "shared-model"


def test_pool_skips_key_during_cooldown():
    calls = {key: [] for key in ("key-one", "key-two")}
    pool = build_groq_account_pool(
        lambda name, default=None: {
            "GROQ_API_KEY": "key-one",
            "GROQ_API_KEY_1": "key-two",
        }.get(name, default),
        client_factory=_factory_for(
            {"key-one": {"unused": True}, "key-two": {"backup": True}},
            calls,
        ),
    )
    pool._cooldown_until["GROQ_API_KEY"] = time.monotonic() + 120

    assert pool.chat.completions.create(model="ignored", messages=[]) == {"backup": True}
    assert calls["key-one"] == []
    assert len(calls["key-two"]) == 1


def test_cooldown_parser_reads_duration_from_daily_limit_message():
    error = RuntimeError("Token limit reached. Please try again in 10m16.8s.")
    assert GroqAccountPool._cooldown_seconds(error) == pytest.approx(616.8)


def test_all_account_failures_do_not_include_api_keys():
    calls = {key: [] for key in ("private-key-one", "private-key-two")}
    pool = GroqAccountPool(
        accounts=[],
        model="test-model",
    )
    pool._accounts = [
        (SimpleNamespace(key_name="GROQ_API_KEY"), _FakeGroqClient(RuntimeError("offline"), [])),
        (SimpleNamespace(key_name="GROQ_API_KEY_1"), _FakeGroqClient(RuntimeError("offline"), [])),
    ]

    with pytest.raises(GroqAccountsError) as error:
        pool.chat.completions.create(model="ignored", messages=[])

    assert "GROQ_API_KEY" in str(error.value)
    assert "private-key-one" not in str(error.value)
    assert "private-key-two" not in str(error.value)
