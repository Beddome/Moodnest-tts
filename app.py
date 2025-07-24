
from flask import Flask, request, send_file
import subprocess
import uuid
import os

app = Flask(__name__)

MODEL_PATH = "/models/en_US-amy-low.onnx"

@app.route("/speak", methods=["GET"])
def speak():
    text = request.args.get("text", "")
    if not text:
        return "Text query parameter required", 400

    output_path = f"/tmp/{uuid.uuid4()}.wav"
    try:
        subprocess.run(["piper", "--model", MODEL_PATH, "--output_file", output_path, "--text", text], check=True)
        return send_file(output_path, mimetype="audio/wav")
    except subprocess.CalledProcessError as e:
        return f"Piper failed: {str(e)}", 500
    finally:
        if os.path.exists(output_path):
            os.remove(output_path)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
