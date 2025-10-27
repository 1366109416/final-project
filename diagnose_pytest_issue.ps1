# diagnose_pytest_issue.ps1 - 诊断 pytest 问题

Write-Host "Diagnosing Pytest Issue (Exit Code 4)..." -ForegroundColor Green

# 1. 检查项目结构
Write-Host "`n1. Project Structure:" -ForegroundColor Yellow
Get-ChildItem -Recurse -Name | Where-Object { $_ -match "\.py$|tests?|app" }

# 2. 检查测试文件
Write-Host "`n2. Test Files:" -ForegroundColor Yellow
if (Test-Path "tests") {
    Get-ChildItem "tests" -Recurse -Name
} else {
    Write-Host "  ❌ tests directory not found" -ForegroundColor Red
}

# 3. 检查 pytest 配置
Write-Host "`n3. Pytest Configuration:" -ForegroundColor Yellow
if (Test-Path "pyproject.toml") {
    Write-Host "  pyproject.toml exists" -ForegroundColor Green
    Get-Content "pyproject.toml" | Select-String "pytest"
} else {
    Write-Host "  ❌ pyproject.toml not found" -ForegroundColor Red
}

# 4. 尝试运行 pytest 并显示详细输出
Write-Host "`n4. Running Pytest with Detailed Output:" -ForegroundColor Yellow
pytest -v --tb=short

Write-Host "`n5. Running Pytest with Collection Only:" -ForegroundColor Yellow
pytest --collect-only

Write-Host "`n6. Running Pytest on Specific Directory:" -ForegroundColor Yellow
pytest tests/ -v

Write-Host "`nDiagnosis Complete" -ForegroundColor Green