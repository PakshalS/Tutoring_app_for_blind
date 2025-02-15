import os
from flask import Flask, jsonify
from services.rag_service import embed_json_data
from api.chatbot import chatbot_bp  # Import Flask blueprint

app = Flask(__name__)

# ✅ Ensure chatbot routes are included
app.register_blueprint(chatbot_bp)

# ✅ Ensure embeddings are loaded
embed_json_data()

@app.route("/", methods=["GET"])
def home():
    return jsonify({"message": "Welcome to the Flask RAG Chatbot API"})

if __name__ == "__main__":
    from waitress import serve
    import os
    PORT = int(os.environ.get("PORT", 8080))  # Default to 8080 if PORT is not set
    serve(app, host="0.0.0.0", port=PORT)
