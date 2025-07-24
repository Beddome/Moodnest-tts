# Dockerfile for Render (Fixed - using piper-tts from PyPI)
FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    espeak-ng \
    libespeak-ng-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Flask and Piper from PyPI
RUN pip install --no-cache-dir flask piper-tts

# Copy app server
COPY app.py /app/app.py
WORKDIR /app

CMD ["python3", "/app/app.py"]
