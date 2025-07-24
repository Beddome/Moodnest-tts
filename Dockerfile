# Dockerfile for Piper TTS Render Deployment
FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    curl \
    espeak-ng \
    libespeak-ng-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone Piper
WORKDIR /opt
RUN git clone https://github.com/rhasspy/piper.git && \
    cd piper && \
    pip install .

# Install Flask explicitly
RUN pip install --no-cache-dir flask piper-tts

# Copy espeak-ng-data (may require mount or build context)
RUN mkdir -p /usr/share/espeak-ng-data || true

# Copy API server
COPY app.py /app/app.py
WORKDIR /app

CMD ["python3", "/app/app.py"]
