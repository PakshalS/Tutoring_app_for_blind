from fastapi import FastAPI
from api.chatbot import router as chatbot_router
from fastapi.middleware.cors import CORSMiddleware
from services.rag_service import embed_json_data

app = FastAPI(title="RAG Chatbot API")

# Enable CORS for Flutter frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Ensure FAISS is ready
embed_json_data()

# Include chatbot routes
app.include_router(chatbot_router)

@app.get("/")
def read_root():
    return {"message": "Welcome to the RAG Chatbot API"}
