# fix_pyproject.ps1 - 修复 pyproject.toml 文件语法错误

Write-Host "Fixing pyproject.toml Syntax Error..." -ForegroundColor Green

# 备份当前文件
Write-Host "`n1. Backing up current pyproject.toml..." -ForegroundColor Yellow
Copy-Item "pyproject.toml" "pyproject.toml.backup" -Force

# 检查文件编码和内容
Write-Host "`n2. Checking file encoding and content..." -ForegroundColor Yellow
Write-Host "File size: $(Get-Item 'pyproject.toml').Length bytes" -ForegroundColor Gray

# 以十六进制查看文件开头，检查是否有 BOM 或其他特殊字符
Write-Host "First 20 bytes in hex:" -ForegroundColor Gray
$bytes = Get-Content "pyproject.toml" -Encoding Byte -TotalCount 20
$hexString = ($bytes | ForEach-Object { $_.ToString("X2") }) -join " "
Write-Host $hexString -ForegroundColor White

# 显示文件内容
Write-Host "`n3. Current file content:" -ForegroundColor Yellow
Get-Content "pyproject.toml" -Encoding UTF8

# 重新创建正确的 pyproject.toml 文件
Write-Host "`n4. Recreating pyproject.toml with correct format..." -ForegroundColor Yellow
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
include = "\.pyi?$"

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

Write-Host "`n5. New file content:" -ForegroundColor Yellow
Get-Content "pyproject.toml" -Encoding UTF8

Write-Host "`npyproject.toml fix completed!" -ForegroundColor Green