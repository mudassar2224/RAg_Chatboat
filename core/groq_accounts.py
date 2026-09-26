"""Ordered fallback across explicitly configured Groq API accounts."""
from __future__ import annotations

import logging
import re
import threading
import time
from dataclasses import dataclass
from types import SimpleNamespace
from typing import Callable

from groq import APIError, Groq

from core.config import get_secret

logger = logging.getLogger("sfms_chatbot.groq_accounts")
_KEY_NAMES = ("GROQ_API_KEY", "GROQ_API_KEY_1", "GROQ_API_KEY_2")


@dataclass(frozen=True)
class GroqAccount:
    key_name: str
    api_key: str


class NoGroqAccountsConfigured(RuntimeError):
    """Raised if none of the Groq API key slots has a value."""


class GroqAccountsError(RuntimeError):
    """Raised when every configured Groq account fails for this request."""


class GroqAccountPool:
    """Client facade compatible with the existing chat-completions calls."""

    def __init__(
        self,
        accounts: list[GroqAccount],
        model: str,
        client_factory: Callable[..., object] = Groq,
    ) -> None:
        self.model = model
        self._accounts = [
            (account, client_factory(api_key=account.api_key, max_retries=0, timeout=45.0))
            for account in accounts
        ]
        self._cooldown_until: dict[str, float] = {}
        self._cooldown_lock = threading.Lock()
        self.chat = SimpleNamespace(completions=self)

    @staticmethod
    def _cooldown_seconds(exc: APIError) -> float:
        headers = getattr(getattr(exc, "response", None), "headers", {}) or {}
        for header in ("retry-after", "x-ratelimit-reset-tokens", "x-ratelimit-reset-requests"):
            value = headers.get(header)
            if value:
                parsed = GroqAccountPool._parse_duration(str(value))
                if parsed is not None:
                    return max(1.0, parsed)
                try:
                    return max(1.0, float(value))
                except ValueError:
                    pass

        parsed = GroqAccountPool._parse_duration(str(exc))
        return max(1.0, parsed) if parsed is not None else 60.0

    @staticmethod
    def _parse_duration(value: str) -> float | None:
        match = re.search(
            r"(?:(\d+(?:\.\d+)?)m)?\s*(\d+(?:\.\d+)?)s",
            value,
            re.IGNORECASE,
        )
        if not match:
            return None
        return float(match.group(1) or 0) * 60 + float(match.group(2) or 0)

    def create(self, **kwargs):
        if not self._accounts:
            raise NoGroqAccountsConfigured(
                "No Groq API keys are configured. Add GROQ_API_KEY or a numbered Groq key to .env."
            )

        failures: list[str] = []
        for account, client in self._accounts:
            now = time.monotonic()
            with self._cooldown_lock:
                cooldown_until = self._cooldown_until.get(account.key_name, 0.0)
            if cooldown_until > now:
                remaining = cooldown_until - now
                failures.append(f"{account.key_name} (cooldown {remaining:.0f}s)")
                logger.info(
                    "groq_key_slot=%s skipped cooldown_remaining_seconds=%.0f",
                    account.key_name,
                    remaining,
                )
                continue

            request = dict(kwargs)
            request["model"] = self.model
            try:
                response = client.chat.completions.create(**request)
                with self._cooldown_lock:
                    self._cooldown_until.pop(account.key_name, None)
                logger.info("groq_key_slot=%s status=success", account.key_name)
                return response
            except APIError as exc:
                status = getattr(exc, "status_code", None)
                failures.append(f"{account.key_name} (HTTP {status or type(exc).__name__})")
                if status == 429:
                    cooldown = self._cooldown_seconds(exc)
                    with self._cooldown_lock:
                        self._cooldown_until[account.key_name] = time.monotonic() + cooldown
                    logger.warning(
                        "groq_key_slot=%s rate_limited cooldown_seconds=%.0f",
                        account.key_name,
                        cooldown,
                    )
                logger.warning(
                    "groq_key_slot=%s failed status=%s; trying next configured Groq account",
                    account.key_name,
                    status or type(exc).__name__,
                )
            except Exception as exc:
                failures.append(f"{account.key_name} ({type(exc).__name__})")
                logger.warning(
                    "groq_key_slot=%s transport failure=%s; trying next configured Groq account",
                    account.key_name,
                    type(exc).__name__,
                )

        raise GroqAccountsError(
            "All configured Groq accounts failed: " + ", ".join(failures)
        )


def build_groq_account_pool(
    secret_getter=get_secret,
    client_factory: Callable[..., object] = Groq,
) -> GroqAccountPool:
    """Build a pool from GROQ_API_KEY and its two numbered slots."""
    accounts: list[GroqAccount] = []
    seen_keys: set[str] = set()
    for key_name in _KEY_NAMES:
        api_key = secret_getter(key_name)
        if not api_key or api_key in seen_keys:
            continue
        seen_keys.add(api_key)
        accounts.append(GroqAccount(key_name=key_name, api_key=api_key))

    model = secret_getter("GROQ_MODEL", "openai/gpt-oss-120b") or "openai/gpt-oss-120b"
    logger.info("configured_groq_key_slots=%s", [account.key_name for account in accounts])
    return GroqAccountPool(accounts, model, client_factory=client_factory)
