# verify_fix.ps1 - 验证所有修复

Write-Host "Verifying All Fixes..." -ForegroundColor Green

# 1. 检查 Black 格式化
Write-Host "`n1. Checking Black formatting..." -ForegroundColor Yellow
black --check .
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Black formatting check passed" -ForegroundColor Green
} else {
    Write-Host "  ✗ Black formatting check failed" -ForegroundColor Red
    Write-Host "  Running black to see differences:" -ForegroundColor Yellow
    black --check . --diff
    exit 1
}

# 2. 检查 Flake8
Write-Host "`n2. Checking Flake8..." -ForegroundColor Yellow
flake8 . --statistics
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Flake8 check passed" -ForegroundColor Green
} else {
    Write-Host "  ✗ Flake8 check failed" -ForegroundColor Red
    exit 1
}

# 3. 运行测试
Write-Host "`n3. Running tests..." -ForegroundColor Yellow
pytest -v
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ All tests passed" -ForegroundColor Green
} else {
    Write-Host "  ✗ Some tests failed" -ForegroundColor Red
    exit 1
}

# 4. 显示 Git 状态
Write-Host "`n4. Git status:" -ForegroundColor Cyan
git status

Write-Host "`n🎉 All checks passed! Ready to commit and push." -ForegroundColor Green