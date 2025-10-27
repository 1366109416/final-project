# setup-branch-protection.ps1 - 设置分支保护规则说明

Write-Host "Branch Protection Rules Setup Instructions" -ForegroundColor Green

Write-Host "`n📋 Manual Steps Required in GitHub Repository Settings:" -ForegroundColor Yellow

Write-Host "`n1. For 'dev' branch:" -ForegroundColor Cyan
Write-Host "   - Go to Settings > Branches > Branch protection rules" -ForegroundColor White
Write-Host "   - Add rule for 'dev'" -ForegroundColor White
Write-Host "   - ✅ Require pull request reviews before merging" -ForegroundColor White
Write-Host "   - ✅ Require status checks to pass before merging" -ForegroundColor White
Write-Host "   - ✅ Require branches to be up to date before merging" -ForegroundColor White
Write-Host "   - Status checks: 'validate-pr', 'integration-test'" -ForegroundColor White

Write-Host "`n2. For 'staging' branch:" -ForegroundColor Cyan
Write-Host "   - Add rule for 'staging'" -ForegroundColor White
Write-Host "   - ✅ Require pull request reviews before merging" -ForegroundColor White
Write-Host "   - ✅ Require status checks to pass before merging" -ForegroundColor White
Write-Host "   - Status checks: 'validate-dev', 'build-docker'" -ForegroundColor White

Write-Host "`n3. For 'main' branch:" -ForegroundColor Cyan
Write-Host "   - Add rule for 'main'" -ForegroundColor White
Write-Host "   - ✅ Require pull request reviews before merging" -ForegroundColor White
Write-Host "   - ✅ Require status checks to pass before merging" -ForegroundColor White
Write-Host "   - ✅ Include administrators" -ForegroundColor White

Write-Host "`n🔗 GitHub Repository Settings URL:" -ForegroundColor Yellow
Write-Host "   https://github.com/your-username/your-repo/settings/branches" -ForegroundColor White

Write-Host "`n📝 Note: Replace 'your-username' and 'your-repo' with your actual values" -ForegroundColor Gray