# complete_pytest_fix.ps1 - 完整的 pytest 修复

Write-Host "Complete Pytest Fix..." -ForegroundColor Green

# 1. 修复依赖
Write-Host "`n1. Fixing dependencies..." -ForegroundColor Yellow
.\fix_dependencies.ps1

# 2. 修复 pytest 配置
Write-Host "`n2. Fixing pytest configuration..." -ForegroundColor Yellow
.\fix_pytest_config.ps1

# 3. 运行诊断
Write-Host "`n3. Running diagnosis..." -ForegroundColor Yellow
.\diagnose_pytest_issue.ps1

# 4. 验证修复
Write-Host "`n4. Verifying fix..." -ForegroundColor Yellow
pytest -v --tb=short

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Pytest is now working correctly!" -ForegroundColor Green
} else {
    Write-Host "❌ Pytest still has issues" -ForegroundColor Red
}

Write-Host "`nComplete pytest fix completed!" -ForegroundColor Green