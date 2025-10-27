# diagnose_black_issue_fixed.ps1 - 修正版的黑格式化诊断脚本

Write-Host "Diagnosing Black Error Causes..." -ForegroundColor Green

# 检查Python版本
Write-Host "`nChecking Python Version:" -ForegroundColor Yellow
try {
    python --version
} catch {
    Write-Host "Python not found or not in PATH" -ForegroundColor Red
}

# 检查Black版本
Write-Host "`nChecking Black Version:" -ForegroundColor Yellow
try {
    black --version
} catch {
    Write-Host "Black not found or not in PATH" -ForegroundColor Red
}

# 检查所有Python文件的语法
Write-Host "`nChecking Python File Syntax..." -ForegroundColor Yellow
$pythonFiles = Get-ChildItem -Recurse -Filter "*.py"
foreach ($file in $pythonFiles) {
    Write-Host "Checking: $($file.FullName)" -ForegroundColor Gray
    $output = python -m py_compile $file.FullName 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  Syntax OK" -ForegroundColor Green
    } else {
        Write-Host "  Syntax Error!" -ForegroundColor Red
        Write-Host "  Error: $output" -ForegroundColor Red
    }
}

# 尝试运行Black并显示详细错误
Write-Host "`nRunning Black with Verbose Output..." -ForegroundColor Yellow
black . --verbose

# 如果失败，尝试逐个文件处理
Write-Host "`nChecking Files Individually..." -ForegroundColor Yellow
foreach ($file in $pythonFiles) {
    Write-Host "Processing: $($file.Name)" -ForegroundColor Gray
    black $file.FullName --check --verbose
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  Formatting issues found in $($file.Name)" -ForegroundColor Red
    }
}

Write-Host "`nDiagnosis Complete" -ForegroundColor Green