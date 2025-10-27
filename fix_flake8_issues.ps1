# fix_flake8_issues.ps1 - 自动修复常见的 Flake8 问题

Write-Host "Fixing Common Flake8 Issues..." -ForegroundColor Green

# 安装必要的工具
Write-Host "`n1. Installing Tools..." -ForegroundColor Yellow
pip install autopep8

# 使用 autopep8 自动修复一些常见问题
Write-Host "`n2. Running autopep8..." -ForegroundColor Yellow
autopep8 . --recursive --in-place --aggressive --aggressive

# 重新运行 Black 确保格式一致
Write-Host "`n3. Running Black to ensure consistent formatting..." -ForegroundColor Yellow
black .

# 检查修复结果
Write-Host "`n4. Checking Flake8 Results..." -ForegroundColor Yellow
flake8 . --statistics

if ($LASTEXITCODE -eq 0) {
    Write-Host "SUCCESS: All Flake8 issues resolved!" -ForegroundColor Green
} else {
    Write-Host "Some issues remain, checking details..." -ForegroundColor Yellow
    flake8 . --show-source
}

Write-Host "`nFix process completed!" -ForegroundColor Green