# manual_fix_flake8.ps1 - 手动修复特定的 Flake8 问题

Write-Host "Manual Flake8 Fixes..." -ForegroundColor Green

# 修复 app/main.py
Write-Host "`nFixing app/main.py..." -ForegroundColor Yellow
$mainContent = @'
"""Main application module."""

import os
from dotenv import load_dotenv

load_dotenv()


def greet():
    """Main function that greets the user with their name and masked token."""
    user = os.getenv("USER_NAME", "Anonymous")
    token = os.getenv("API_TOKEN", "No Token")
    masked_token = token[:4] + "***" if len(token) > 4 else "***"
    return f"Hello {user}, your token is {masked_token}"


def main():
    """Entry point for the application."""
    print(greet())
    print("Application is running successfully!")


if __name__ == "__main__":
    main()
'@
$mainContent | Out-File -FilePath "app\main.py" -Encoding utf8

# 修复 app/utils.py
Write-Host "Fixing app/utils.py..." -ForegroundColor Yellow
$utilsContent = @'
"""Utility functions for the application."""

import os


def mask_secret(secret, visible_chars=4):
    """Mask a secret string, showing only the first few characters.

    Args:
        secret: The secret string to mask
        visible_chars: Number of characters to show (default: 4)

    Returns:
        Masked string
    """
    if len(secret) <= visible_chars:
        return "***"
    return secret[:visible_chars] + "***"


def validate_env_var(var_name, default=None):
    """Validate and retrieve an environment variable.

    Args:
        var_name: Name of the environment variable
        default: Default value if not found

    Returns:
        Value of the environment variable or default

    Raises:
        ValueError: If environment variable is required but not set
    """
    value = os.getenv(var_name, default)
    if value is None:
        raise ValueError(f"Environment variable {var_name} is required but not set")
    return value
'@
$utilsContent | Out-File -FilePath "app\utils.py" -Encoding utf8

# 修复 tests/test_main.py
Write-Host "Fixing tests/test_main.py..." -ForegroundColor Yellow
$testContent = @'
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
'@
$testContent | Out-File -FilePath "tests\test_main.py" -Encoding utf8

# 确保 __init__.py 文件存在且正确
Write-Host "Ensuring __init__.py files are correct..." -ForegroundColor Yellow
$appInitContent = @'
"""My Project - A simple Python application with best practices."""

__version__ = "0.1.0"
__author__ = "Your Name"
'@
$appInitContent | Out-File -FilePath "app\__init__.py" -Encoding utf8

$testsInitContent = @'
"""Tests package."""
'@
$testsInitContent | Out-File -FilePath "tests\__init__.py" -Encoding utf8

# 运行 Black 确保格式一致
Write-Host "Running Black..." -ForegroundColor Yellow
black .

# 检查结果
Write-Host "Checking Flake8 results..." -ForegroundColor Yellow
flake8 . --statistics

Write-Host "Manual fix completed!" -ForegroundColor Green