# My Project

A simple Python application demonstrating best practices including environment variables, linting, testing, and containerization.

## Features

- ✅ Environment variable management with `.env` file
- ✅ Code formatting with Black
- ✅ Linting with Flake8
- ✅ Unit tests with pytest
- ✅ Docker containerization
- ✅ GitHub Actions CI/CD pipeline

## Project Structure

```
my_project/
├── app/
│   ├── __init__.py
│   ├── main.py          # Main application
│   └── utils.py         # Utility functions
├── tests/
│   ├── __init__.py
│   └── test_main.py     # Test cases
├── .github/
│   └── workflows/
│       └── ci.yml       # CI/CD pipeline
├── .env                 # Environment variables (not in git)
├── .gitignore
├── .dockerignore
├── .flake8              # Linting configuration
├── Dockerfile
├── pyproject.toml       # Project configuration
├── requirements.txt
└── README.md
```

## Setup

1. Clone the repository
2. Create a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Create a `.env` file in the root directory:
   ```
   USER_NAME=YourName
   API_TOKEN=your_secret_token_here
   ```

## Running the Application

```bash
python -m app.main
```

## Testing

Run all tests:
```bash
pytest
```

Run tests with coverage:
```bash
pytest --cov=app tests/
```

## Code Quality

Format code with Black:
```bash
black .
```

Check formatting:
```bash
black --check .
```

Run linting:
```bash
flake8 .
```

## Docker

Build the Docker image:
```bash
docker build -t my_project .
```

Run the container:
```bash
docker run --rm -e USER_NAME=YourName -e API_TOKEN=your_token my_project
```

## CI/CD

The GitHub Actions workflow automatically:
- Checks code formatting with Black
- Runs linting with Flake8
- Executes all tests
- Builds the Docker image

The pipeline runs on every push and pull request to the `main` and `develop` branches.

## License

MIT License
