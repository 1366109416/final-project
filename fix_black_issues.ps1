# 修复 Black 代码格式化问题的 PowerShell 脚本

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   修复 Black 代码格式化问题" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# 步骤1: 运行 Black 格式化检查
Write-Host "步骤1: 检查代码格式..." -ForegroundColor Yellow
$checkResult = python -m black --check . 
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ 代码格式正确，无需修复" -ForegroundColor Green
} else {
    Write-Host "⚠️  发现格式问题，正在自动修复..." -ForegroundColor Yellow
    
    # 步骤2: 运行 Black 格式化
    Write-Host "步骤2: 自动格式化代码..." -ForegroundColor Yellow
    python -m black .
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ 代码格式化完成" -ForegroundColor Green
    } else {
        Write-Host "❌ 代码格式化失败" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "步骤3: 最终格式检查..." -ForegroundColor Yellow
python -m black --check .
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ 所有代码格式正确" -ForegroundColor Green
} else {
    Write-Host "❌ 仍有格式问题需要手动修复" -ForegroundColor Red
}

Write-Host ""
Write-Host "下一步操作建议:" -ForegroundColor Cyan
Write-Host "   git add ." -ForegroundColor White
Write-Host "   git commit -m 'style: format code with Black' " -ForegroundColor White
Write-Host "   git push origin [branch-name]" -ForegroundColor White

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   修复完成" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan