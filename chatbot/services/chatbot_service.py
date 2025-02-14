from langchain.chains import RetrievalQA
from langchain_community.llms import HuggingFacePipeline
from transformers import AutoModelForCausalLM, AutoTokenizer, pipeline
from .rag_service import get_vector_store
import os

# Load model once to avoid repeated initialization
MODEL_NAME = "TinyLlama/TinyLlama-1.1B-Chat-v1.0"
MODEL_DIR = "models/tinyllama"


# Load model from cache if available
if not os.path.exists(MODEL_DIR):
    print("Downloading model for the first time...")
    os.makedirs(MODEL_DIR, exist_ok=True)
    tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME, cache_dir=MODEL_DIR)
    model = AutoModelForCausalLM.from_pretrained(MODEL_NAME, cache_dir=MODEL_DIR)
else:
    print("Loading cached model...")
    tokenizer = AutoTokenizer.from_pretrained(MODEL_DIR)
    model = AutoModelForCausalLM.from_pretrained(MODEL_DIR)
hf_pipeline = pipeline("text-generation", model=model, tokenizer=tokenizer, max_new_tokens=150)

llm = HuggingFacePipeline(pipeline=hf_pipeline)

# Load FAISS once
vector_store = get_vector_store()
retriever = vector_store.as_retriever(search_kwargs={"k": 1})  # Fetch only the most relevant document

# Initialize QA Chain
qa = RetrievalQA.from_chain_type(
    llm=llm,
    retriever=retriever,
    return_source_documents=True
)

def format_response(response_text):
    """Cleans up response text before returning."""
    response_text = response_text.replace(
        "Use the following pieces of context to answer the question at the end.", ""
    ).strip()

    # Remove any text starting with "Q:" or "Helpful Answer:"
    response_text = response_text.split("\nQ:")[0]  # Remove unnecessary Q&A parts
    response_text = response_text.split("\nHelpful Answer:")[0]  # Remove duplicates

    return response_text.strip()

def generate_response(query: str):
    """Generates a response using the RAG pipeline."""
    
    retrieved_docs = retriever.get_relevant_documents(query)

    if not retrieved_docs:
        return "Sorry, I couldn't find relevant information."

    best_match = retrieved_docs[0].page_content  # Take only the most relevant result

    # Extract metadata
    metadata = retrieved_docs[0].metadata
    chapter = metadata.get("chapter", "Unknown Chapter")
    section = metadata.get("section", "Unknown Section")

    # Post-processing to clean response
    cleaned_response = format_response(best_match)

    return f"{cleaned_response}\n\n(Chapter: {chapter}, Section: {section})"