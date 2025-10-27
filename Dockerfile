# Use Python 3.10 slim image as base
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app/ ./app/

# Set environment variables (these should be overridden at runtime)
ENV USER_NAME=DefaultUser
ENV API_TOKEN=default_token

# Run the application
CMD ["python", "-m", "app.main"]
