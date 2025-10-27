"""Tests for the main application."""

import pytest
from app.main import greet
from app.utils import mask_secret, validate_env_var


def test_greet_with_env_vars(monkeypatch):
    """Test greet function with environment variables set."""
    monkeypatch.setenv("USER_NAME", "TestUser")
    monkeypatch.setenv("API_TOKEN", "1234567890abcdef")

    result = greet()
    assert "Hello TestUser" in result
    assert "1234***" in result


def test_greet_without_env_vars(monkeypatch):
    """Test greet function without environment variables."""
    monkeypatch.delenv("USER_NAME", raising=False)
    monkeypatch.delenv("API_TOKEN", raising=False)

    result = greet()
    assert "Anonymous" in result


def test_mask_secret():
    """Test the mask_secret utility function."""
    assert mask_secret("1234567890") == "1234***"
    assert mask_secret("123") == "***"
    assert mask_secret("", 4) == "***"


def test_mask_secret_custom_length():
    """Test mask_secret with custom visible characters."""
    assert mask_secret("1234567890", 2) == "12***"
    assert mask_secret("1234567890", 6) == "123456***"


def test_validate_env_var(monkeypatch):
    """Test validate_env_var function."""
    monkeypatch.setenv("TEST_VAR", "test_value")
    assert validate_env_var("TEST_VAR") == "test_value"


def test_validate_env_var_with_default(monkeypatch):
    """Test validate_env_var with default value."""
    monkeypatch.delenv("MISSING_VAR", raising=False)
    assert validate_env_var("MISSING_VAR", "default") == "default"


def test_validate_env_var_missing(monkeypatch):
    """Test validate_env_var raises error when variable is missing."""
    monkeypatch.delenv("REQUIRED_VAR", raising=False)

    with pytest.raises(ValueError, match="REQUIRED_VAR is required"):
        validate_env_var("REQUIRED_VAR")
