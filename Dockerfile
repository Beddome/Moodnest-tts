
# Use a Python base image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    curl \
    espeak-ng \
    libespeak-ng1 \
    libespeak-ng-dev \
    && apt-get clean

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Clone Piper and install (minimal setup)
RUN git clone https://github.com/rhasspy/piper.git /opt/piper && \
    cd /opt/piper && \
    pip install .

# Download voice model and config from Google Drive
RUN mkdir -p /models && \
    curl -L -o /models/en_US-amy-low.onnx "https://drive.google.com/uc?export=download&id=1oxgXAjOlhzpH9AndfW_CPxQ5NumPwVbh" && \
    curl -L -o /models/en_US-amy-low.onnx.json "https://drive.google.com/uc?export=download&id=1opthKrvq1MwEKHw0JH6gcTP266fqh_Yp"

# Copy your app files
COPY . /app

# Expose port
EXPOSE 8000

# Start the app
CMD ["python", "app.py"]
