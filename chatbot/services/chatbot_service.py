# import os
# import requests
# from langchain.chains import RetrievalQA
# from .rag_service import get_vector_store
# from dotenv import load_dotenv

# load_dotenv()

# # ✅ Load API Key for Gemini
# GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
# GEMINI_MODEL_URL = f"https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent?key={GEMINI_API_KEY}"

# # ✅ Load FAISS retriever
# vector_store = get_vector_store()
# retriever = vector_store.as_retriever(search_kwargs={"k": 1})

# def query_gemini_api(prompt: str):
#     headers = {"Content-Type": "application/json"}
#     payload = {
#         "contents": [{"role": "user", "parts": [{"text": prompt}]}],
#         "generationConfig": {
#             "maxOutputTokens": 600,  # Increased token limit for a longer response
#             "temperature": 0.7,
#             "topP": 0.9
#         }
#     }

#     try:
#         response = requests.post(GEMINI_MODEL_URL, headers=headers, json=payload)
#         response.raise_for_status()
#         return response.json()["candidates"][0]["content"]["parts"][0]["text"]
#     except requests.exceptions.RequestException as e:
#         return f"Error: {e}"

# def generate_response(query: str):
#     """Retrieves best match and generates response using Gemini API."""
#     retrieved_docs = retriever.get_relevant_documents(query)
    
#     if retrieved_docs:
#         best_match = retrieved_docs[0].page_content
#         metadata = retrieved_docs[0].metadata
#         chapter = metadata.get("chapter", "Unknown Chapter")
#         section = metadata.get("section", "Unknown Section")

#         # ✅ Keep the context under 500 words (Reduce API processing time)
#         best_match = " ".join(best_match.split()[:500])

#         # ✅ Optimized prompt for Gemini
#         prompt = (f"Answer the question concisely but thoroughly using this information:\n"
#                   f"{best_match}\n\nQuestion: {query}\nAnswer:")
#     else:
#         prompt = f"Provide a detailed answer to:\n\nQuestion: {query}\nAnswer:"

#     response_text = query_gemini_api(prompt)

#     return f"{response_text}\n\n(Chapter: {chapter}, Section: {section})"
import os
from groq import Groq
from langchain.chains import RetrievalQA
from .rag_service import get_vector_store
from dotenv import load_dotenv

load_dotenv()

# ✅ Load API Key for Groq
GROQ_API_KEY = os.getenv("GROQ_API_KEY")

# ✅ Initialize Groq client
groq_client = Groq(api_key=GROQ_API_KEY)

# ✅ Load FAISS retriever
vector_store = get_vector_store()
retriever = vector_store.as_retriever(search_kwargs={"k": 1, "score_threshold": 0.7})  # Added score_threshold for relevance

def query_groq_api(prompt: str):
    """Queries Groq API with the provided prompt."""
    try:
        response = groq_client.chat.completions.create(
            model="llama-3.3-70b-versatile",
            messages=[
                {"role": "system", "content": "You are a helpful assistant that provides concise and accurate answers based on the provided context."},
                {"role": "user", "content": prompt}
            ],
            max_tokens=600,
            temperature=0.7,
            top_p=0.9
        )
        return response.choices[0].message.content
    except Exception as e:
        return f"Error: {e}"

def is_conversational_query(query: str) -> bool:
    """Determines if the query is conversational rather than knowledge-base-related."""
    conversational_phrases = [
        "thank you", "thanks", "you're welcome", "hi", "hello", "bye",
        "solved my doubt", "good", "okay", "ok", "great"
    ]
    return any(phrase in query.lower() for phrase in conversational_phrases)

def generate_response(query: str):
    """Retrieves best match and generates response using Groq API."""
    # Handle conversational queries without retrieval or metadata
    if is_conversational_query(query):
        prompt = f"Provide a concise and natural response to:\n\nQuestion: {query}\nAnswer:"
        return query_groq_api(prompt)

    # Attempt retrieval for knowledge-base queries
    retrieved_docs = retriever.invoke(query)
    
    if retrieved_docs:
        best_match = retrieved_docs[0].page_content
        metadata = retrieved_docs[0].metadata
        chapter = metadata.get("chapter", "Unknown Chapter")
        section = metadata.get("section", "Unknown Section")

        best_match = " ".join(best_match.split()[:500])

        prompt = (f"Answer the question concisely but thoroughly using this information:\n"
                  f"{best_match}\n\nQuestion: {query}\nAnswer:")
        
        response_text = query_groq_api(prompt)
        return f"{response_text}\n\n(Chapter: {chapter}, Section: {section})"
    
    # Fallback for non-retrieved queries without metadata
    prompt = f"Provide a concise and accurate answer to:\n\nQuestion: {query}\nAnswer:"
    return query_groq_api(prompt)