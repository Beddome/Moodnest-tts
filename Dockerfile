FROM python:3.10-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    espeak-ng \
    libespeak-ng-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Flask and Piper from PyPI
RUN pip install --no-cache-dir flask piper-tts

# Download the Piper voice model
RUN mkdir -p /models && \
    curl -L -o /models/en_US-amy-low.onnx https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US-amy-low/en_US-amy-low.onnx

# Copy the app server
COPY app.py /app/app.py
WORKDIR /app

CMD ["python3", "app.py"]
