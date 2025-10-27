# setup-workflows.ps1 - 设置新的 GitHub Actions 工作流

Write-Host "Setting up GitHub Actions Workflows..." -ForegroundColor Green

# 确保 .github/workflows 目录存在
Write-Host "`n1. Creating workflows directory..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path ".github/workflows"

# 创建 Feature Branch 工作流
Write-Host "`n2. Creating Feature Branch workflow..." -ForegroundColor Yellow
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

    - name: Run tests
      run: pytest -v --cov=app

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
'@
$featureWorkflow | Out-File -FilePath ".github/workflows/feature-branch.yml" -Encoding utf8

# 创建 Pull Dev 工作流
Write-Host "3. Creating Pull Dev workflow..." -ForegroundColor Yellow
$pullDevWorkflow = @'
name: Pull Request to Dev

on:
  pull_request:
    branches: [ dev ]

env:
  PYTHON_VERSION: '3.10'

jobs:
  validate-pr:
    name: Validate Pull Request to Dev
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      with:
        ref: ${{ github.event.pull_request.head.ref }}
        repository: ${{ github.event.pull_request.head.repo.full_name }}

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

    - name: Run tests
      run: pytest -v --cov=app

    - name: Check branch naming convention
      run: |
        BRANCH_NAME="${{ github.head_ref }}"
        if [[ ! $BRANCH_NAME =~ ^(feature/|feat/|peat[0-9]+|fix/|bugfix/|hotfix/|release/).* ]]; then
          echo "❌ Branch name does not follow naming convention"
          exit 1
        else
          echo "✅ Branch name follows naming convention"
        fi
'@
$pullDevWorkflow | Out-File -FilePath ".github/workflows/pull-dev.yml" -Encoding utf8

# 创建 Push Dev 工作流
Write-Host "4. Creating Push Dev workflow..." -ForegroundColor Yellow
$pushDevWorkflow = @'
name: Push to Dev Branch

on:
  push:
    branches: [ dev ]

env:
  PYTHON_VERSION: '3.10'

jobs:
  validate-dev:
    name: Validate Dev Branch
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4

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

    - name: Run all tests
      run: pytest -v --cov=app

  build-docker:
    name: Build Docker Image
    runs-on: ubuntu-latest
    needs: validate-dev
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v3

    - name: Build Docker image
      run: |
        docker build -t my_project:dev-${{ github.sha }} .
        docker build -t my_project:dev-latest .

    - name: Test Docker image
      run: |
        docker run --rm -e USER_NAME=TestUser -e API_TOKEN=test123 my_project:dev-latest
'@
$pushDevWorkflow | Out-File -FilePath ".github/workflows/push-dev.yml" -Encoding utf8

Write-Host "`n5. Verifying workflow files..." -ForegroundColor Yellow
Get-ChildItem ".github/workflows" | ForEach-Object {
    Write-Host "  - $($_.Name)" -ForegroundColor White
}

Write-Host "`n✅ GitHub Actions workflows setup completed!" -ForegroundColor Green
Write-Host "📋 Created workflows:" -ForegroundColor Cyan
Write-Host "   - feature-branch.yml (Feature Branch Validation)" -ForegroundColor White
Write-Host "   - pull-dev.yml (Pull Request to Dev)" -ForegroundColor White
Write-Host "   - push-dev.yml (Push to Dev Branch)" -ForegroundColor White
Write-Host "`n🚀 Next steps:" -ForegroundColor Yellow
Write-Host "   1. Commit and push these workflow files" -ForegroundColor White
Write-Host "   2. Test by creating a feature branch and pushing changes" -ForegroundColor White
Write-Host "   3. Create a PR to dev branch to test the PR workflow" -ForegroundColor White