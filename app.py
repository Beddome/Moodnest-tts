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
    model_path = "/opt/piper/models/en_US-lessac-medium.onnx"
    config_path = "/opt/piper/models/en_US-lessac-medium.onnx.json"

    try:
        cmd = [
            "/opt/piper/build/piper",
            "--model", model_path,
            "--config", config_path,
            "--output_file", output_file,
            "--text", text
        ]

        result = subprocess.run(cmd, capture_output=True, text=True)

        if result.returncode != 0:
            return f"Piper failed:\n{result.stderr}", 500

        return send_file(output_file, mimetype='audio/wav', as_attachment=True)

    except Exception as e:
        return f"Error occurred: {str(e)}", 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)