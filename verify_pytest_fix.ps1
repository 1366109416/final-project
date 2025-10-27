# verify_pytest_fix.ps1 - 验证 pytest 修复

Write-Host "Verifying Pytest Fix..." -ForegroundColor Green

# 1. 检查 pyproject.toml 语法
Write-Host "`n1. Checking pyproject.toml syntax..." -ForegroundColor Yellow
try {
    # 尝试使用 Python 的 tomllib 验证 TOML 语法
    $pythonCheckScript = @'
import sys
try:
    if sys.version_info >= (3, 11):
        import tomllib
    else:
        import tomli as tomllib
    with open("pyproject.toml", "rb") as f:
        tomllib.load(f)
    print("✓ pyproject.toml syntax is valid")
except Exception as e:
    print(f"✗ pyproject.toml syntax error: {e}")
    sys.exit(1)
'@
    $pythonCheckScript | python
} catch {
    Write-Host "  Python check failed: $($_.Exception.Message)" -ForegroundColor Red
}

# 2. 运行 pytest
Write-Host "`n2. Running pytest..." -ForegroundColor Yellow
pytest -v

if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Pytest ran successfully!" -ForegroundColor Green
} else {
    Write-Host "  ✗ Pytest failed with exit code: $LASTEXITCODE" -ForegroundColor Red
}

# 3. 检查其他工具
Write-Host "`n3. Checking other tools..." -ForegroundColor Yellow
black --check .
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Black check passed" -ForegroundColor Green
} else {
    Write-Host "  ✗ Black check failed" -ForegroundColor Red
}

flake8 . --statistics
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Flake8 check passed" -ForegroundColor Green
} else {
    Write-Host "  ✗ Flake8 check failed" -ForegroundColor Red
}

Write-Host "`nVerification completed!" -ForegroundColor Green