import os
from fastapi import FastAPI
from services.rag_service import embed_json_data
from api.chatbot import router as chatbot_router
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="RAG Chatbot API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins (Change for security)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include chatbot routes
app.include_router(chatbot_router)

# Ensure FAISS is ready
embed_json_data()

@app.get("/")
def read_root():
    return {"message": "Welcome to the RAG Chatbot API"}

if __name__ == "__main__":
    import uvicorn
    PORT = os.getenv("PORT")
    if PORT is None:
        print("ERROR: PORT environment variable is NOT SET!", flush=True)
        raise ValueError("PORT environment variable is not set")
    
    print(f"Starting server on PORT: {PORT}", flush=True)  # Log for debugging
    uvicorn.run(app, host="0.0.0.0", port=int(PORT))
