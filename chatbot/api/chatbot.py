from fastapi import APIRouter
from pydantic import BaseModel
from services.chatbot_service import generate_response

router = APIRouter(prefix="/chatbot", tags=["Chatbot"])

class QueryModel(BaseModel):
    question: str

@router.post("/")
def chatbot(query: QueryModel):
    response = generate_response(query.question)
    return {"response": response}
