# diagnose_black_detailed.ps1 - 详细的 Black 诊断脚本

Write-Host "Detailed Black Formatting Diagnosis..." -ForegroundColor Green

# 检查 Black 版本和配置
Write-Host "`n1. Checking Black Configuration..." -ForegroundColor Yellow
black --version

if (Test-Path "pyproject.toml") {
    Write-Host "Black configuration in pyproject.toml:" -ForegroundColor Gray
    Get-Content "pyproject.toml" | Select-String "black"
}

# 检查哪些文件需要格式化
Write-Host "`n2. Checking Files That Need Formatting..." -ForegroundColor Yellow
black --check . --diff

# 逐个文件检查
Write-Host "`n3. Checking Each File Individually..." -ForegroundColor Yellow
$pythonFiles = Get-ChildItem -Recurse -Filter "*.py"
foreach ($file in $pythonFiles) {
    Write-Host "Checking: $($file.Name)" -ForegroundColor Gray
    black $file.FullName --check --diff
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  ✗ $($file.Name) needs formatting" -ForegroundColor Red
    } else {
        Write-Host "  ✓ $($file.Name) is properly formatted" -ForegroundColor Green
    }
}

Write-Host "`nDiagnosis Complete" -ForegroundColor Green