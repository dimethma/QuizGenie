from flask import Flask, request, jsonify
from flask_cors import CORS
from PyPDF2 import PdfReader
from openai import OpenAI
import json
import traceback


client = OpenAI(api_key='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')

app = Flask(__name__)

CORS(app) 


def extract_text_from_pdf(pdf_file):
    reader = PdfReader(pdf_file)
    text = ""
    for page in reader.pages:
        page_text = page.extract_text()
        if page_text:
            text += page_text
    return text


@app.route('/generate-questions', methods=['POST'])
def generate_questions():
    if 'files' not in request.files:
        return jsonify({"error": "No files uploaded"}), 400

    files = request.files.getlist('files')
    all_text = ""

    for file in files:
        all_text += extract_text_from_pdf(file)

    try:
        
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {
                    "role": "system",
                    "content": "You are a helpful assistant that generates exam-style multiple-choice questions in JSON format only."
                },
                {
                    "role": "user",
                    "content": f"Based on this content:\n\n{all_text}\n\nGenerate exactly 30 multiple-choice questions in this JSON format (no markdown, no explanation):\n[\n  {{\n    \"questionText\": \"...\",\n    \"options\": [\"A\", \"B\", \"C\", \"D\"],\n    \"correctAnswerIndex\": 2\n  }},\n  ...\n]"
                }
            ],
            temperature=0.7,
            max_tokens=2500,
        )

        content = response.choices[0].message.content
        print("🔍 GPT Response:")
        print(content)

        
        if content.startswith("json"):
            content = content.strip("json").strip("").strip()

        
        start = content.find('[')
        end = content.rfind(']')
        if start != -1 and end != -1:
            content = content[start:end+1]

        print("✅ Cleaned content:")
        print(content)

        
        try:
            questions = json.loads(content)
        except json.JSONDecodeError as e:
            print("❌ JSON parse error:", e)
            return jsonify({"error": "OpenAI returned invalid JSON", "details": str(e)}), 500

        
        return jsonify({"questions": questions[:30]})

    except Exception as e:
        traceback.print_exc()
        return jsonify({"error": "Failed to generate questions", "details": str(e)}), 500


@app.route('/analyze-topics', methods=['POST'])
def analyze_topics():
    print("📥 Request received")

    if 'files' not in request.files:
        print("❌ No files part in request")
        return jsonify({"error": "No files uploaded"}), 400

    files = request.files.getlist('files')
    print(f"📄 Files received: {len(files)}")

    all_text = ""

    for file in files:
        text = extract_text_from_pdf(file)
        print(f"📄 Extracted {len(text)} characters from file.")
        all_text += text

    try:
        print("🤖 Sending to OpenAI...")
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {
                    "role": "system",
                    "content": "You are a helpful assistant that analyzes academic exam papers and summarizes the main topics covered along with their key features in JSON format."
                },
                {
                    "role": "user",
                    "content": f"Analyze the following exam content and return a list of topics discussed along with their key features. Use this JSON format:\n\n[\n  {{ \"topic\": \"Topic Name\", \"features\": [\"feature 1\", \"feature 2\"] }},\n  ...\n]\n\nHere is the content:\n\n{all_text}"
                }
            ],
            temperature=0.6,
            max_tokens=1500,
        )

        content = response.choices[0].message.content
        print("✅ OpenAI response received")
        print("🧠 Raw response:\n", content)

        
        if content.startswith("json"):
            content = content.strip("json").strip("").strip()

       
        start = content.find('[')
        end = content.rfind(']')
        if start != -1 and end != -1:
            content = content[start:end + 1]

        print("🧪 Extracted JSON block:")
        print(content)

        
        try:
            topics = json.loads(content)
        except json.JSONDecodeError as e:
            print("❌ JSON parsing error:", e)
            return jsonify({"error": "OpenAI returned invalid JSON", "details": str(e)}), 500

        print("📚 Topics extracted successfully.")
        return jsonify({"topics": topics})

    except Exception as e:
        print("❌ Exception occurred:")
        traceback.print_exc()
        return jsonify({"error": "Failed to analyze topics", "details": str(e)}), 500





if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)
