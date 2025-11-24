import requests
import json
import time
import os
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

API_KEY = os.environ.get("GEMINI_API_KEY", "")
API_URL = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-09-2025:generateContent?key={API_KEY}"

SYSTEM_PROMPT_TEMPLATE = """You are an expert project manager. A user will provide a large project goal and a strategy.
Your task is to break down this goal into distinct PHASES (Groups).
Each Phase must have a descriptive title.
Inside each Phase, list the specific tasks required.

USER'S STRATEGY: "{user_strategy}"

Respond ONLY with the JSON object defined in the schema."""

PROJECT_PLAN_SCHEMA = {
    "type": "OBJECT",
    "properties": {
        "projectName": {"type": "STRING"},
        "groups": {
            "type": "ARRAY",
            "items": {
                "type": "OBJECT",
                "properties": {
                    "groupName": {"type": "STRING"},
                    "tasks": {
                        "type": "ARRAY",
                        "items": {
                            "type": "OBJECT",
                            "properties": {
                                "taskName": {"type": "STRING"},
                                "description": {"type": "STRING"},
                                "priority": {"type": "STRING", "enum": ["High", "Medium", "Low"]},
                                "durationDays": {"type": "INTEGER"}
                            },
                            "required": ["taskName", "description", "priority", "durationDays"]
                        }
                    }
                },
                "required": ["groupName", "tasks"]
            }
        }
    },
    "required": ["projectName", "groups"]
}

def call_gemini_api(user_query, system_prompt, schema, max_retries=3):
    headers = {'Content-Type': 'application/json'}
    payload = {
        "contents": [{"parts": [{"text": user_query}]}],
        "systemInstruction": {"parts": [{"text": system_prompt}]},
        "generationConfig": {
            "responseMimeType": "application/json",
            "responseSchema": schema
        }
    }

    attempt = 0
    while attempt < max_retries:
        try:
            response = requests.post(API_URL, headers=headers, data=json.dumps(payload))
            if response.status_code == 200:
                result = response.json()
                candidate = result.get('candidates', [{}])[0]
                content = candidate.get('content', {}).get('parts', [{}])[0]
                if 'text' in content:
                    return content['text']
                else:
                    raise ValueError("Invalid response structure: " + json.dumps(result))
            else:
                raise requests.HTTPError(f"API Error: {response.status_code} {response.reason} - {response.text}")
        except Exception as e:
            attempt += 1
            if attempt >= max_retries:
                raise
            time.sleep(1)

@app.route('/', methods=['GET'])
def home():
    return "Python Server is UP with New Schema!", 200

@app.route('/generate-plan', methods=['POST'])
def generate_plan_endpoint():
    if not request.json:
        return jsonify({"error": "Missing JSON body"}), 400
        
    user_query = request.json.get('description')
    user_strategy = request.json.get('strategy')

    try:
        system_prompt = SYSTEM_PROMPT_TEMPLATE.format(user_strategy=user_strategy)
        generated_plan_str = call_gemini_api(user_query, system_prompt, PROJECT_PLAN_SCHEMA)
        parsed_plan = json.loads(generated_plan_str)
        return jsonify(parsed_plan), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=5000)
