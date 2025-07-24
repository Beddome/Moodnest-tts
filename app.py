from flask import Flask, request, send_file
import subprocess
import uuid
import os

app = Flask(__name__)

VOICE = "/opt/piper/models/en_US-lessac-medium.onnx"
CONFIG = "/opt/piper/models/en_US-lessac-medium.onnx.json"
ESPEAK_DATA_PATH = "/opt/piper/data"

@app.route("/speak", methods=["GET"])
def speak():
    text = request.args.get("text", "")
    if not text:
        return "Missing text", 400

    uid = str(uuid.uuid4())
    output_wav = f"/tmp/{uid}.wav"

    command = [
        "/opt/piper/build/piper",
        "--model", VOICE,
        "--config", CONFIG,
        "--output_file", output_wav,
        "--espeak-data", ESPEAK_DATA_PATH,
        "--text", text
    ]

    try:
        subprocess.run(command, check=True)
        return send_file(output_wav, mimetype="audio/wav")
    except subprocess.CalledProcessError as e:
        return f"Piper failed: {e}", 500