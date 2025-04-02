from flask import Flask, request, jsonify
from openai import OpenAI
import os
import json
from dotenv import load_dotenv
import PyPDF2
import docx
from PIL import Image
import pytesseract
import io
import tempfile
import requests

load_dotenv()

app = Flask(__name__)

# Initialize OpenAI client
client = OpenAI(api_key='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')

# Configure Tesseract path if needed (for OCR)
# pytesseract.pytesseract.tesseract_cmd = r'<full_path_to_tesseract_executable>'

@app.route('/generate_questions', methods=['POST'])
def generate_questions():
    try:
        data = request.json
        paper_type = data.get('type', 'MCQ')
        subject = data.get('subject', 'General')
        difficulty = data.get('difficulty', 'Medium')
        num_questions = data.get('num_questions', 10)
        context = data.get('context', '')
        
        # Generate detailed prompt
        prompt = f"""
        You are an expert exam paper creator. Generate {num_questions} {difficulty}-level {paper_type} questions about {subject}.
        
        Context provided:
        {context}
        
        For each question:
        - Include a clear, well-formulated question
        - For MCQs: provide 4 plausible options with one clearly correct answer
        - For essays: provide a model answer with key points
        - Include a detailed explanation of the correct answer
        - Reference specific parts of the context when applicable
        
        Format the output as JSON with this structure:
        {{
            "questions": [
                {{
                    "question": "question text",
                    "type": "{paper_type}",
                    "options": ["option1", "option2", ...] (only for MCQ),
                    "correct_answer": "correct option or essay answer",
                    "explanation": "detailed explanation",
                    "source_reference": "relevant part of context"
                }},
                ...
            ]
        }}
        """
        
        response = client.chat.completions.create(
            model="gpt-4-turbo",
            messages=[
                {"role": "system", "content": "You are an expert educational content creator."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.7,
            response_format={"type": "json_object"}
        )
        
        content = response.choices[0].message.content
        questions = json.loads(content)
        
        return jsonify({
            "success": True,
            "questions": questions['questions'],
            "model": "gpt-4-turbo",
            "usage": {
                "prompt_tokens": response.usage.prompt_tokens,
                "completion_tokens": response.usage.completion_tokens,
                "total_tokens": response.usage.total_tokens
            }
        })
        
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

@app.route('/process_file', methods=['POST'])
def process_file():
    try:
        file_url = request.json.get('file_url')
        file_type = request.json.get('file_type')  # pdf, docx, etc.
        
        # Download the file
        response = requests.get(file_url)
        file_content = io.BytesIO(response.content)
        
        # Process based on file type
        if file_type == 'pdf':
            text = extract_text_from_pdf(file_content)
        elif file_type == 'docx':
            text = extract_text_from_docx(file_content)
        elif file_type in ['jpg', 'png', 'jpeg']:
            text = extract_text_from_image(file_content)
        else:
            text = "Unsupported file type"
            
        return jsonify({
            "success": True,
            "text": text,
            "file_type": file_type
        })
        
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500