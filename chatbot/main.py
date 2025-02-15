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

if __name__ == "_main_":
    app.run(port=5000,debug=True)