from flask import Flask, request, send_file
import subprocess
import uuid
import os

app = Flask(__name__)

@app.route("/speak")
def speak():
    text = request.args.get("text", "Hello from Piper")
    uid = str(uuid.uuid4())
    output_path = f"/tmp/{uid}.wav"
    try:
        subprocess.run(["piper", "--model", "en_US-amy-low.onnx", "--output_file", output_path, "--text", text], check=True)
        return send_file(output_path, mimetype="audio/wav")
    except Exception as e:
        return f"Piper failed: {e}", 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)