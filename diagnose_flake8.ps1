# diagnose_flake8.ps1 - Flake8 错误诊断脚本

Write-Host "Diagnosing Flake8 Issues..." -ForegroundColor Green

# 检查 Flake8 版本和配置
Write-Host "`n1. Checking Flake8 Configuration..." -ForegroundColor Yellow
flake8 --version

if (Test-Path "pyproject.toml") {
    Write-Host "pyproject.toml found, checking Flake8 settings..." -ForegroundColor Gray
    Get-Content "pyproject.toml" | Select-String "flake8"
}

# 运行 Flake8 并显示详细错误
Write-Host "`n2. Running Flake8 with Detailed Output..." -ForegroundColor Yellow
flake8 . --statistics --show-source

# 如果失败，逐个文件检查
Write-Host "`n3. Checking Files Individually..." -ForegroundColor Yellow
$pythonFiles = Get-ChildItem -Recurse -Filter "*.py"
foreach ($file in $pythonFiles) {
    Write-Host "Checking: $($file.Name)" -ForegroundColor Gray
    flake8 $file.FullName --show-source
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  Issues found in $($file.Name)" -ForegroundColor Red
    }
}

Write-Host "`nDiagnosis Complete" -ForegroundColor Green