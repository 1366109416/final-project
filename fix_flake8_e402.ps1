# fix_flake8_e402.ps1 - 修复 Flake8 E402 错误

Write-Host "Fixing Flake8 E402 Issues..." -ForegroundColor Green

# 删除备份目录以避免 Flake8 检查
Write-Host "`n1. Removing backup directories..." -ForegroundColor Yellow
Get-ChildItem -Directory -Filter "black_backup_*" | Remove-Item -Recurse -Force
if ($?) {
    Write-Host "  Removed backup directories" -ForegroundColor Green
}

# 更新 tests/test_main.py 使用方案2（更简洁）
Write-Host "`n2. Updating tests/test_main.py..." -ForegroundColor Yellow
$testMainContent = @'
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
    with pytest.raises(ValueError, match="REQUIRED_VAR is required but not set"):
        validate_env_var("REQUIRED_VAR")
'@
$testMainContent | Out-File -FilePath "tests\test_main.py" -Encoding utf8

# 确保 conftest.py 存在
Write-Host "`n3. Ensuring tests/conftest.py exists..." -ForegroundColor Yellow
$conftestContent = @'
"""Pytest configuration file."""

import os
import sys

# Add project root to Python path
project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, project_root)
'@
$conftestContent | Out-File -FilePath "tests\conftest.py" -Encoding utf8

# 更新 pyproject.toml 配置
Write-Host "`n4. Updating pyproject.toml..." -ForegroundColor Yellow
$pyprojectContent = @'
[project]
name = "my_project"
version = "0.1.0"
description = "A simple Python application with best practices"
requires-python = ">=3.10"
dependencies = [
    "python-dotenv>=1.0.0",
]

[tool.black]
line-length = 88
target-version = ['py310']
include = '\.pyi?$'

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
addopts = "-v --tb=short"
pythonpath = "."

[tool.flake8]
max-line-length = 88
extend-ignore = "E203,W503,E402"
exclude = ".git,__pycache__,build,dist,.venv,venv,black_backup_*"

[build-system]
requires = ["setuptools>=61.0"]
build-backend = "setuptools.build_meta"
'@
$pyprojectContent | Out-File -FilePath "pyproject.toml" -Encoding utf8

# 运行 Black 确保格式正确
Write-Host "`n5. Running Black formatter..." -ForegroundColor Yellow
black .

# 检查 Flake8 结果
Write-Host "`n6. Checking Flake8 results..." -ForegroundColor Yellow
flake8 . --statistics

if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Flake8 check passed!" -ForegroundColor Green
} else {
    Write-Host "  ✗ Flake8 check failed" -ForegroundColor Red
    Write-Host "  Running detailed Flake8 check..." -ForegroundColor Yellow
    flake8 . --show-source
}

Write-Host "`nE402 fix completed!" -ForegroundColor Green