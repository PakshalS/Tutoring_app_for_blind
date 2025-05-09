import json
import os
from langchain_community.embeddings import HuggingFaceEmbeddings
from langchain_community.vectorstores import FAISS
from langchain_huggingface import HuggingFaceEmbeddings 
from langchain.text_splitter import CharacterTextSplitter
from langchain.schema import Document
from dotenv import load_dotenv

# ✅ Define FAISS index storage path
FAISS_INDEX_PATH = "embeddings/faiss_index"

load_dotenv()

def load_json_data(json_path="data/knowledge_base.json"):
    """Extracts structured text from JSON for embedding."""
    if not os.path.exists(json_path):
        raise FileNotFoundError(f"JSON file not found: {json_path}")

    with open(json_path, "r", encoding="utf-8") as file:
        data = json.load(file)

    documents = []
    
    # ✅ Iterate over chapters, sections, and exercises
    for chapter in data.get("subjects/quantitativeAptitude/chapters", []):
        chapter_name = chapter["data"]["name"]

        for section_key, section_value in chapter["data"].get("sections", {}).items():
            section_name = section_value.get("name", "Unknown Section")
            section_content = "\n".join(section_value.get("content", []))

            if section_content:
                documents.append(Document(
                    page_content=section_content,
                    metadata={"chapter": chapter_name, "section": section_name, "type": "theory"}
                ))

            for sub_key, sub_value in section_value.get("subsections", {}).items():
                sub_name = sub_value.get("name", "Unknown Subsection")
                sub_content = "\n".join(sub_value.get("content", []))

                if sub_content:
                    documents.append(Document(
                        page_content=sub_content,
                        metadata={"chapter": chapter_name, "section": section_name, "subsection": sub_name, "type": "theory"}
                    ))

        # ✅ Extracting only correct answers from exercises
        for question_data in chapter["data"].get("exercise", {}).get("questions", []):
            correct_answer = question_data.get("answer", "Unknown Answer")
            
            documents.append(Document(
                page_content=f"{correct_answer}",
                metadata={"chapter": chapter_name, "section": section_name, "type": "exercise"}
            ))

    return documents

def retrieve_best_match(query, retriever):
    """Retrieves only the best matching document."""
    retrieved_docs = retriever.get_relevant_documents(query)
    
    if retrieved_docs:
        best_match = retrieved_docs[0].page_content  # ✅ Fetch the most relevant match
        metadata = retrieved_docs[0].metadata
        chapter = metadata.get("chapter", "Unknown Chapter")
        section = metadata.get("section", "Unknown Section")
        return f"{best_match}\n\n(Chapter: {chapter}, Section: {section})"
    else:
        return "Sorry, I couldn't find relevant information."

def format_response(response_text):
    """Cleans up response text before returning."""
    return response_text.replace(
        "Use the following pieces of context to answer the question at the end.", ""
    ).strip()

def embed_json_data():
    """Embeds JSON text into FAISS index if not already created."""
    if os.path.exists(FAISS_INDEX_PATH):
        print("✅ FAISS index already exists. Skipping embedding process.")
        return "FAISS index already exists."

    print("🔹 Creating FAISS index...")
    documents = load_json_data()

    text_splitter = CharacterTextSplitter(chunk_size=500, chunk_overlap=50)
    chunks = text_splitter.split_documents(documents)

    embeddings = HuggingFaceEmbeddings(model_name="BAAI/bge-small-en-v1.5")
    vector_store = FAISS.from_documents(chunks, embeddings)

    vector_store.save_local(FAISS_INDEX_PATH)
    print("✅ FAISS Indexing completed.")
    return "FAISS index created successfully."

def get_vector_store():
    """Loads FAISS vector store using a lightweight embedding model."""
    if not os.path.exists(FAISS_INDEX_PATH):
        print("⚠️ FAISS index missing! Creating it now...")
        embed_json_data()
    
    embeddings = HuggingFaceEmbeddings(model_name="BAAI/bge-small-en-v1.5")
    return FAISS.load_local(FAISS_INDEX_PATH, embeddings, allow_dangerous_deserialization=True)