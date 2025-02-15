from flask import Blueprint, request, jsonify
from services.chatbot_service import generate_response

chatbot_bp = Blueprint("chatbot", __name__)

@chatbot_bp.route("/chatbot", methods=["POST"])
def chatbot():
    data = request.json
    if "question" not in data:
        return jsonify({"error": "Missing 'question' field"}), 400

    response = generate_response(data["question"])
    return jsonify({"response": response})
