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

# Copy the entire src folder content to /app
COPY . .

# Expose port 8501 (jo logs mein show ho raha tha)
EXPOSE 8501

# Force Streamlit to run on port 8501 and bind to all interfaces
CMD ["streamlit", "run", "streamlit_app.py", "--server.port=8501", "--server.address=0.0.0.0"]
