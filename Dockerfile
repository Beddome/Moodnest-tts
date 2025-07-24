FROM python:3.10-slim

# Install build dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libespeak-ng1 \
    libespeak-ng-dev \
    sox \
    && rm -rf /var/lib/apt/lists/*

# Install Piper TTS from PyPI
RUN pip install piper-tts

# Create working directory
WORKDIR /app

# Copy app code (placeholder - assume main.py exists)
COPY main.py .

# Expose port
EXPOSE 5000

# Run the Flask app (if main.py uses Flask)
CMD ["python", "main.py"]