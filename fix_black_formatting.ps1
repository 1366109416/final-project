# fix_black_formatting.ps1 - 自动修复 Black 格式化问题

Write-Host "Fixing Black Formatting Issues..." -ForegroundColor Green

# 备份当前文件
Write-Host "`n1. Backing up files..." -ForegroundColor Yellow
$backupDir = "black_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Path $backupDir | Out-Null
Copy-Item -Recurse -Force "app" "$backupDir\"
Copy-Item -Recurse -Force "tests" "$backupDir\"
Write-Host "  Backed up to: $backupDir" -ForegroundColor Gray

# 运行 Black 格式化所有文件
Write-Host "`n2. Running Black formatter..." -ForegroundColor Yellow
black .

# 验证格式化结果
Write-Host "`n3. Verifying formatting..." -ForegroundColor Yellow
black --check .

if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ All files are now properly formatted!" -ForegroundColor Green
} else {
    Write-Host "  ✗ Some files still need formatting" -ForegroundColor Red
    Write-Host "  Running detailed check..." -ForegroundColor Yellow
    black --check . --diff
}

# 显示被修改的文件
Write-Host "`n4. Modified files:" -ForegroundColor Cyan
git status --porcelain | ForEach-Object {
    if ($_ -match "\.py$") {
        Write-Host "  - $($_.Substring(3))" -ForegroundColor White
    }
}

Write-Host "`nBlack formatting fix completed!" -ForegroundColor Green