from flask import Flask, request, jsonify
from flask_cors import CORS
from PyPDF2 import PdfReader
from openai import OpenAI
import json
import traceback

# ✅ Use your OpenAI API key here
client = OpenAI(api_key='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')

app = Flask(__name__)
CORS(app)  # Allow Flutter frontend access

# ✅ Extract text from PDF
def extract_text_from_pdf(pdf_file):
    reader = PdfReader(pdf_file)
    text = ""
    for page in reader.pages:
        page_text = page.extract_text()
        if page_text:
            text += page_text
    return text

# ✅ Endpoint to handle file upload + OpenAI call
@app.route('/generate-questions', methods=['POST'])
def generate_questions():
    if 'files' not in request.files:
        return jsonify({"error": "No files uploaded"}), 400

    files = request.files.getlist('files')
    all_text = ""

    for file in files:
        all_text += extract_text_from_pdf(file)

    try:
        # Request to OpenAI
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

        # ✅ Remove markdown wrapping
        if content.startswith("```json"):
            content = content.strip("```json").strip("```").strip()

        # ✅ Extract just the JSON part (start at first [ and end at last ])
        start = content.find('[')
        end = content.rfind(']')
        if start != -1 and end != -1:
            content = content[start:end+1]

        print("✅ Cleaned content:")
        print(content)

        # ✅ Attempt to parse the JSON safely
        try:
            questions = json.loads(content)
        except json.JSONDecodeError as e:
            print("❌ JSON parse error:", e)
            return jsonify({"error": "OpenAI returned invalid JSON", "details": str(e)}), 500

        # ✅ Return only the first 30 questions (safety)
        return jsonify({"questions": questions[:30]})

    except Exception as e:
        traceback.print_exc()
        return jsonify({"error": "Failed to generate questions", "details": str(e)}), 500

# ✅ Run server
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)
