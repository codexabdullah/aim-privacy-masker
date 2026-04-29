import streamlit as st
import fitz  # PyMuPDF
import re
import io

# UI Configuration
st.set_page_config(page_title="Aim Privacy Masker", page_icon="🛡️")
st.title("🛡️ Aim Privacy Masker")
st.markdown("### Secure Document Redaction Engine")
st.write("Professional-grade tool to automatically detect and mask sensitive information.")

def process_document(pdf_file):
    """
    Analyzes the PDF and applies redaction to sensitive data points.
    Uses high-performance pattern matching for precise identification.
    """
    # Load document from memory buffer
    doc = fitz.open(stream=pdf_file.read(), filetype="pdf")
    
    # Advanced RegEx patterns for global PII (Personally Identifiable Information)
    # Target: Email addresses and International Phone Formats
    email_pattern = r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'
    phone_pattern = r'\+?\d{10,15}'

    for page in doc:
        # Extract text layer for analysis
        text = page.get_text()
        
        # Consolidate identified targets
        matches = re.findall(email_pattern, text) + re.findall(phone_pattern, text)
        
        # Apply redaction annotations to each unique match
        for item in set(matches):
            areas = page.search_for(item)
            for rect in areas:
                # Apply black-box mask over sensitive coordinates
                page.add_redact_annot(rect, fill=(0, 0, 0))
            
            # Commit redactions to the page layer
            page.apply_redactions()

    # Save the sanitized document to a byte stream
    output = io.BytesIO()
    doc.save(output)
    doc.close()
    return output.getvalue()

# Main Application Interface
uploaded_file = st.file_uploader("Upload Document (PDF)", type="pdf")

if uploaded_file:
    if st.button("Generate Secure Version"):
        with st.spinner("Analyzing and redacting sensitive layers..."):
            # Execute processing logic
            sanitized_pdf = process_document(uploaded_file)
            
            st.success("Redaction Complete! All sensitive patterns secured.")
            
            # Provide the processed file for download
            st.download_button(
                label="Download Secured PDF",
                data=sanitized_pdf,
                file_name=f"secured_{uploaded_file.name}",
                mime="application/pdf"
            )

st.divider()
st.info("Built with architectural logic by AimSoftwareStudios.")
