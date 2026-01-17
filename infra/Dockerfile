# GreenBee Beyond Space Unified Dockerfile
FROM python:3.9-slim

WORKDIR /app

# System dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev gcc \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies from api/requirements.txt
# Note: In the new structure, requirements.txt is at api/requirements.txt
COPY api/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire api directory
COPY api ./api

# Set PYTHONPATH to include /app so 'api' module can be found
ENV PYTHONPATH=/app:/app/api:/app/api/service

# Environment variables
ENV PORT=8080
ENV APP_MODE=SERVER_ONLY
ENV PYTHONUNBUFFERED=1

# Command to run the application
# Note: The entry point is now api.service.main because we copied 'api' folder to /app/api
CMD sh -c "uvicorn api.service.main:app --host 0.0.0.0 --port ${PORT}"
