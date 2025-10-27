# fix_pytest_cov_issue.ps1 - 修复 pytest-cov 问题

Write-Host "Fixing pytest-cov Issue..." -ForegroundColor Green

# 1. 更新 requirements.txt
Write-Host "`n1. Updating requirements.txt..." -ForegroundColor Yellow
$requirementsContent = @'
python-dotenv==1.0.0
pytest==7.4.3
pytest-cov==4.1.0
black==23.12.1
flake8==7.0.0
'@
$requirementsContent | Out-File -FilePath "requirements.txt" -Encoding utf8

# 2. 更新 feature-branch.yml 工作流
Write-Host "`n2. Updating feature-branch.yml..." -ForegroundColor Yellow
$featureWorkflow = @'
name: Feature Branch Validation

on:
  push:
    branches:
      - 'feature/**'
      - 'feat/**'
      - 'peat1'
      - 'peat2'

env:
  PYTHON_VERSION: '3.10'

jobs:
  validate-feature:
    name: Validate Feature Branch
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      with:
        fetch-depth: 0

    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: ${{ env.PYTHON_VERSION }}

    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt

    - name: Check code formatting with Black
      run: black --check .

    - name: Run linting with Flake8
      run: flake8 .

    - name: Run tests with detailed output
      run: |
        pytest -v --tb=short

    - name: Check for merge conflicts with dev
      run: |
        git fetch origin dev
        git checkout dev
        git checkout - || true
        if git merge origin/${{ github.ref_name }} --no-commit --no-ff; then
          echo "✅ No merge conflicts with dev branch"
          git merge --abort 2>/dev/null || true
        else
          echo "❌ Merge conflicts detected with dev branch"
          git merge --abort 2>/dev/null || true
          exit 1
        fi

    - name: Notify on success
      if: success()
      run: |
        echo "✅ Feature branch validation passed! Ready for PR to dev."
'@
$featureWorkflow | Out-File -FilePath ".github/workflows/feature-branch.yml" -Encoding utf8

# 3. 更新其他工作流文件（移除 --cov 参数）
Write-Host "`n3. Updating other workflow files..." -ForegroundColor Yellow

# 更新 pull-dev.yml
if (Test-Path ".github/workflows/pull-dev.yml") {
    $pullDevContent = Get-Content ".github/workflows/pull-dev.yml" -Raw
    $pullDevContent = $pullDevContent -replace 'pytest -v --cov=app --cov-report=xml', 'pytest -v'
    $pullDevContent | Out-File -FilePath ".github/workflows/pull-dev.yml" -Encoding utf8
}

# 更新 push-dev.yml
if (Test-Path ".github/workflows/push-dev.yml") {
    $pushDevContent = Get-Content ".github/workflows/push-dev.yml" -Raw
    $pushDevContent = $pushDevContent -replace 'pytest -v --cov=app --cov-report=xml', 'pytest -v'
    $pushDevContent = $pushDevContent -replace 'pytest -v --cov=app', 'pytest -v'
    $pushDevContent | Out-File -FilePath ".github/workflows/push-dev.yml" -Encoding utf8
}

# 4. 在本地安装 pytest-cov 进行测试
Write-Host "`n4. Installing pytest-cov locally..." -ForegroundColor Yellow
pip install pytest-cov==4.1.0

# 5. 测试 pytest 命令
Write-Host "`n5. Testing pytest commands..." -ForegroundColor Yellow
Write-Host "Testing without coverage:" -ForegroundColor Gray
pytest -v --tb=short

Write-Host "`nTesting with coverage (if needed later):" -ForegroundColor Gray
pytest -v --cov=app --tb=short

Write-Host "`nPytest-cov fix completed!" -ForegroundColor Green