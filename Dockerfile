FROM python:3.10-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    cmake \
    libsndfile1-dev \
    ffmpeg \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Clone Piper
RUN git clone https://github.com/rhasspy/piper.git /opt/piper

# Build Piper
WORKDIR /opt/piper
RUN mkdir build && cd build && cmake .. && make

# Copy API script
COPY app.py .

# Create models directory
RUN mkdir /opt/piper/models

# Expose port
EXPOSE 5000

# Run the API server
CMD ["python3", "app.py"]