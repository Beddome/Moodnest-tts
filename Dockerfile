FROM python:3.10-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    git build-essential cmake libsndfile1-dev ffmpeg curl unzip \
    && rm -rf /var/lib/apt/lists/*

# Clone Piper
RUN git clone https://github.com/rhasspy/piper.git /opt/piper

# Build Piper
WORKDIR /opt/piper
RUN mkdir build && cd build && cmake .. && make

# Install Flask
RUN pip install flask

# Download and extract espeak-ng-data to correct path
WORKDIR /usr/share
RUN curl -L https://github.com/espeak-ng/espeak-ng/archive/refs/heads/master.zip -o espeak-ng.zip && \
    unzip espeak-ng.zip && \
    mkdir -p /usr/share/espeak-ng-data && \
    cp -r espeak-ng-master/espeak-ng-data/* /usr/share/espeak-ng-data/ && \
    rm -rf espeak-ng.zip espeak-ng-master

# Copy API code
WORKDIR /app
COPY app.py .

# Create and populate models directory
RUN mkdir -p /opt/piper/models
RUN curl -L -o /opt/piper/models/en_US-lessac-medium.onnx \
     https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/lessac/medium/en_US-lessac-medium.onnx \
 && curl -L -o /opt/piper/models/en_US-lessac-medium.onnx.json \
     https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/lessac/medium/en_US-lessac-medium.onnx.json

EXPOSE 5000
CMD ["python3", "/app/app.py"]