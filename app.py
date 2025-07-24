from flask import Flask, request, send_file
import subprocess
import uuid
import os

app = Flask(__name__)

@app.route('/speak')
def speak():
    text = request.args.get('text', '')
    if not text:
        return "Please provide text to speak using '?text='", 400

    filename = f'/tmp/{uuid.uuid4()}.wav'
    try:
        subprocess.run(['piper', '--model', '/models/en_US-amy-low.onnx', '--output_file', filename],
                       input=text.encode(), check=True)
        return send_file(filename, mimetype='audio/wav')
    except Exception as e:
        return f"Piper failed: {e}", 500
    finally:
        if os.path.exists(filename):
            os.remove(filename)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
