from flask import Flask, request, send_file
import os
import uuid
import subprocess

app = Flask(__name__)

@app.route("/speak")
def speak():
    text = request.args.get("text")
    if not text:
        return "Missing text", 400

    output_filename = f"/tmp/{uuid.uuid4()}.wav"

    try:
        subprocess.run(
            ["piper", "--model", "models/en_US-amy-low.onnx", "--output_file", output_filename, "--text", text],
            check=True
        )
        return send_file(output_filename, mimetype="audio/wav")
    except Exception as e:
        return f"Piper failed: {e}", 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=10000)