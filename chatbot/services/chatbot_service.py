import os
import requests
from langchain.chains import RetrievalQA
from .rag_service import get_vector_store
from dotenv import load_dotenv

load_dotenv()

# ✅ Load API Key for Gemini
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
GEMINI_MODEL_URL = f"https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent?key={GEMINI_API_KEY}"

# ✅ Load FAISS retriever
vector_store = get_vector_store()
retriever = vector_store.as_retriever(search_kwargs={"k": 1})

def query_gemini_api(prompt: str):
    headers = {"Content-Type": "application/json"}
    payload = {
        "contents": [{"role": "user", "parts": [{"text": prompt}]}],
        "generationConfig": {
            "maxOutputTokens": 600,  # Increased token limit for a longer response
            "temperature": 0.7,
            "topP": 0.9
        }
    }

    try:
        response = requests.post(GEMINI_MODEL_URL, headers=headers, json=payload)
        response.raise_for_status()
        return response.json()["candidates"][0]["content"]["parts"][0]["text"]
    except requests.exceptions.RequestException as e:
        return f"Error: {e}"

def generate_response(query: str):
    """Retrieves best match and generates response using Gemini API."""
    retrieved_docs = retriever.get_relevant_documents(query)
    
    if retrieved_docs:
        best_match = retrieved_docs[0].page_content
        metadata = retrieved_docs[0].metadata
        chapter = metadata.get("chapter", "Unknown Chapter")
        section = metadata.get("section", "Unknown Section")

        # ✅ Keep the context under 500 words (Reduce API processing time)
        best_match = " ".join(best_match.split()[:500])

        # ✅ Optimized prompt for Gemini
        prompt = (f"Answer the question concisely but thoroughly using this information:\n"
                  f"{best_match}\n\nQuestion: {query}\nAnswer:")
    else:
        prompt = f"Provide a detailed answer to:\n\nQuestion: {query}\nAnswer:"

    response_text = query_gemini_api(prompt)

    return f"{response_text}\n\n(Chapter: {chapter}, Section: {section})"
