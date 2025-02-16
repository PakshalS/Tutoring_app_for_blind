import os
from flask import Flask, jsonify
from services.rag_service import embed_json_data
from api.chatbot import chatbot_bp
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
app.register_blueprint(chatbot_bp)

embed_json_data()  # Ensure embeddings are loaded

@app.route("/", methods=["GET"])
def home():
    return jsonify({"message": "Welcome to the Flask RAG Chatbot API"})

if __name__ == "__main__":
    PORT = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=PORT)
