import os
from flask import Flask, jsonify, request
from services.rag_service import embed_json_data
from api.chatbot import chatbot_bp
from werkzeug.middleware.proxy_fix import ProxyFix
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app)  # Fix for running behind a proxy (needed for Vercel)
app.register_blueprint(chatbot_bp)

embed_json_data()  # Ensure FAISS embeddings are loaded

@app.route("/", methods=["GET"])
def home():
    return jsonify({"message": "Welcome to the Flask RAG Chatbot API"})

# ✅ This is required for Vercel to recognize Flask as a serverless function
def handler(event, context):
    return app(event, context)

