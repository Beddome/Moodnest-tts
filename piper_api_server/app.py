from flask import Flask, request, send_file
from piper import PiperVoice
import soundfile as sf
import uuid
import os

app = Flask(__name__)
voice = PiperVoice.load(
    model_path="models/en_US-lessac-medium.onnx", 
    config_path="models/en_US-lessac-medium.onnx.json"
)

@app.route("/speak", methods=["GET"])
def speak():
    text = request.args.get("text", "")
    if not text:
        return "Missing 'text' parameter", 400

    temp_id = str(uuid.uuid4())
    wav_path = f"/tmp/{temp_id}.wav"

    audio = voice.synthesize(text)
    sf.write(wav_path, audio.samples, audio.sample_rate)

    return send_file(wav_path, mimetype="audio/wav")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)