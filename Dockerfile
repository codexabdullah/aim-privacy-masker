# Use python image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# System dependencies for PDF processing
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy everything (GitHub ki root aur HF ka src folder dono cover ho jayenge)
COPY . .

# Expose port 8501
EXPOSE 8501

# Run the app (Dono cases ke liye handle kiya hai)
CMD ["sh", "-c", "if [ -f src/streamlit_app.py ]; then streamlit run src/streamlit_app.py --server.port=8501 --server.address=0.0.0.0; else streamlit run streamlit_app.py --server.port=8501 --server.address=0.0.0.0; fi"]
