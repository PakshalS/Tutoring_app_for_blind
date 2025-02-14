from fastapi import FastAPI
from api.chatbot import router as chatbot_router
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="RAG Chatbot API")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins (Change this to specific domains in production)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
# Include chatbot routes
app.include_router(chatbot_router)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000)
    
@app.get("/")
def read_root():
    return {"message": "Welcome to the RAG Chatbot API"}

# Run server with: `uvicorn main:app --reload`
