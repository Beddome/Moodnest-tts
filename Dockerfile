FROM python:3.10-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    git build-essential cmake libsndfile1-dev ffmpeg curl unzip \
    autoconf automake libtool pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Clone and build espeak-ng (includes phontab)
WORKDIR /opt
RUN git clone https://github.com/espeak-ng/espeak-ng.git && \
    cd espeak-ng && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install

# Clone Piper
RUN git clone https://github.com/rhasspy/piper.git /opt/piper

# Build Piper
WORKDIR /opt/piper
RUN mkdir build && cd build && cmake .. && make

# Install Flask
RUN pip install flask

# Copy API server
WORKDIR /app
COPY app.py .

# Download voice model + config
RUN mkdir -p /opt/piper/models
RUN curl -L -o /opt/piper/models/en_US-lessac-medium.onnx \
     https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/lessac/medium/en_US-lessac-medium.onnx \
 && curl -L -o /opt/piper/models/en_US-lessac-medium.onnx.json \
     https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/lessac/medium/en_US-lessac-medium.onnx.json

EXPOSE 5000
CMD ["python3", "/app/app.py"]