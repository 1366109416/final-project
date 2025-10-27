# final_check.ps1 - 最终检查所有工具

Write-Host "Final Check - All Tools" -ForegroundColor Green

# 1. 检查 Black
Write-Host "`n1. Checking Black..." -ForegroundColor Yellow
black --check .
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Black formatting check passed" -ForegroundColor Green
} else {
    Write-Host "  ✗ Black formatting check failed" -ForegroundColor Red
    Write-Host "  Error details:" -ForegroundColor Red
    black --check . --verbose
}

# 2. 检查 Flake8
Write-Host "`n2. Checking Flake8..." -ForegroundColor Yellow
flake8 . --statistics
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Flake8 check passed" -ForegroundColor Green
} else {
    Write-Host "  ✗ Flake8 check failed" -ForegroundColor Red
    Write-Host "  Error details:" -ForegroundColor Red
    flake8 . --show-source
}

# 3. 运行 pytest
Write-Host "`n3. Running pytest..." -ForegroundColor Yellow
pytest -v
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Pytest passed" -ForegroundColor Green
} else {
    Write-Host "  ✗ Pytest failed" -ForegroundColor Red
}

Write-Host "`nFinal check completed!" -ForegroundColor Green