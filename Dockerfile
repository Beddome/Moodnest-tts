FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    build-essential cmake git python3 python3-pip curl unzip \
    libsndfile1-dev ffmpeg automake autoconf libtool pkg-config

# Clone and build espeak-ng
WORKDIR /opt
RUN git clone https://github.com/espeak-ng/espeak-ng.git && \
    cd espeak-ng && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install

# Clone and build Piper
RUN git clone https://github.com/rhasspy/piper.git /opt/piper
WORKDIR /opt/piper
RUN mkdir build && cd build && cmake .. && make

# Install Flask for API
RUN pip3 install flask

# Copy app server
WORKDIR /app
COPY app.py .

# Download Piper model + config
RUN mkdir -p /opt/piper/models
RUN curl -L -o /opt/piper/models/en_US-lessac-medium.onnx \
     https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/lessac/medium/en_US-lessac-medium.onnx \
 && curl -L -o /opt/piper/models/en_US-lessac-medium.onnx.json \
     https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/lessac/medium/en_US-lessac-medium.onnx.json

EXPOSE 5000
CMD ["python3", "/app/app.py"]