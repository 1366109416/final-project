# fix_backslash_issue.ps1 - 修复未转义的反斜杠问题

Write-Host "Fixing Unescaped Backslash in pyproject.toml..." -ForegroundColor Green

# 显示有问题的行
Write-Host "`n1. Showing problematic line (line 13):" -ForegroundColor Yellow
$lines = Get-Content "pyproject.toml" -Encoding UTF8
if ($lines.Count -ge 13) {
    Write-Host "Line 13: $($lines[12])" -ForegroundColor Red
}

# 重新创建正确的 pyproject.toml
Write-Host "`n2. Recreating pyproject.toml with proper escaping..." -ForegroundColor Yellow
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
target-version = ["py310"]
include = "\\.pyi?$"

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

# 使用 UTF-8 无 BOM 编码保存
$utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText("pyproject.toml", $pyprojectContent, $utf8NoBomEncoding)

Write-Host "`n3. Verifying the fix..." -ForegroundColor Yellow

# 使用 Python 验证 TOML 语法
$pythonCheckScript = @'
import sys
try:
    if sys.version_info >= (3, 11):
        import tomllib
    else:
        import tomli as tomllib
    with open("pyproject.toml", "rb") as f:
        tomllib.load(f)
    print("✓ pyproject.toml syntax is now valid")
except Exception as e:
    print(f"✗ pyproject.toml syntax error: {e}")
    sys.exit(1)
'@

$pythonCheckScript | python

Write-Host "`nBackslash fix completed!" -ForegroundColor Green