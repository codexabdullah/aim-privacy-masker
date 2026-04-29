FROM python:3.9-slim

WORKDIR /app

# Required for PyMuPDF (fitz)
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy all files (covers both root and src/ structures)
COPY . .

# Hugging Face standard port
EXPOSE 7860

# Smart execution for port 7860
CMD ["sh", "-c", "if [ -f src/streamlit_app.py ]; then \
    streamlit run src/streamlit_app.py --server.port=7860 --server.address=0.0.0.0; \
    else \
    streamlit run streamlit_app.py --server.port=7860 --server.address=0.0.0.0; \
    fi"]
