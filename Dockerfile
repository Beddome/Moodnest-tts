FROM python:3.10-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libsndfile1-dev \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Clone Piper
RUN git clone https://github.com/rhasspy/piper.git /opt/piper

# Set working directory
WORKDIR /opt/piper

# Install Piper
RUN pip install .

# Copy API server
COPY app.py .

# Expose HTTP port
EXPOSE 5000

# Start server
CMD ["python3", "app.py"]