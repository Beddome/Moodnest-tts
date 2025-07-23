from flask import Flask, request, send_file
import subprocess
import uuid
import os

app = Flask(__name__)

@app.route('/speak')
def speak():
    text = request.args.get('text', '')
    if not text:
        return 'No text provided', 400

    output_file = f"/tmp/{uuid.uuid4()}.wav"

    cmd = [
        "/opt/piper/build/piper",
        "--model", "/opt/piper/models/en_US-lessac-medium.onnx",
        "--config", "/opt/piper/models/en_US-lessac-medium.onnx.json",
        "--output_file", output_file,
        "--text", text
    ]

    subprocess.run(cmd, check=True)

    return send_file(output_file, mimetype='audio/wav', as_attachment=True)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)