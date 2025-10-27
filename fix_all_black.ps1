# fix_all_black.ps1 - 修复所有Black格式问题

Write-Host "Starting Black Formatting Fix..." -ForegroundColor Green

# 检查当前状态
Write-Host "`nChecking current formatting..." -ForegroundColor Yellow
black --check .

# 格式化所有文件
Write-Host "`nFormatting all Python files..." -ForegroundColor Yellow
black .

# 验证修复
Write-Host "`nVerifying formatting is now correct..." -ForegroundColor Yellow
black --check .

if ($LASTEXITCODE -eq 0) {
    Write-Host "SUCCESS: All files are now properly formatted!" -ForegroundColor Green
    
    # 显示哪些文件被修改了
    Write-Host "`nModified files:" -ForegroundColor Cyan
    git status --porcelain | ForEach-Object {
        if ($_ -match "\.py$") {
            Write-Host "  - $($_.Substring(3))" -ForegroundColor White
        }
    }
} else {
    Write-Host "FAILED: Some files still need formatting" -ForegroundColor Red
}

Write-Host "`nFormatting process completed!" -ForegroundColor Green