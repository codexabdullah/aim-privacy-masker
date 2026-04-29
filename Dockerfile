# Use a slim Python image for efficiency
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies needed for PDF processing (PyMuPDF/fitz)
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first to leverage Docker cache
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy everything from the current directory (including src/ if it exists)
COPY . .

# Expose the port Streamlit uses
EXPOSE 8501

# The "Smart Launcher": Checks if the file is in 'src/' or root and runs it on port 8501
CMD ["sh", "-c", "if [ -f src/streamlit_app.py ]; then \
    streamlit run src/streamlit_app.py --server.port=8501 --server.address=0.0.0.0; \
    else \
    streamlit run streamlit_app.py --server.port=8501 --server.address=0.0.0.0; \
    fi"]
