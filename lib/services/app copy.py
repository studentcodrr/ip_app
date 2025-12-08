import requests
import json
import time
import os
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

API_KEY = os.environ.get("GEMINI_API_KEY", "")
API_URL = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={API_KEY}"

# --- UPDATED: INTELLIGENT SCHEDULING PROMPT ---
SYSTEM_PROMPT_TEMPLATE = """You are an expert Project Manager. Create a realistic execution plan based on the user's description and strategy.

SCHEDULING LOGIC (Dynamic):
1. **Analyze Dependencies:** - If Task B requires Task A to finish (e.g., "Build Roof" after "Build Walls"), Task B must start *after* Task A.
   - If Task B is independent of Task A (e.g., "Order Windows" vs "Hire Plumber"), they should run **IN PARALLEL** (start at the same time).

2. **Apply Strategy:**
   - If Strategy is **"Fast"**, **"Aggressive"**, or **"Short-term"**: Use maximum parallelism and overlapping (intercalated) tasks.
   - If Strategy is **"Safe"**, **"Step-by-step"**, or **"Quality"**: Prefer sequential tasks to minimize risk.

3. **Calculate Offsets:**
   - 'phaseStartDay': When the Group begins relative to Project Day 0.
   - 'startDayOffset': When the Task begins relative to the Group start.
     - Parallel Task: Offset 0 (or close to it).
     - Sequential Task: Offset = Sum of previous tasks' duration.
     - Intercalated Task: Offset = Previous Task Start + (Previous Task Duration / 2).

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
                    "phaseStartDay": {
                        "type": "INTEGER",
                        "description": "Day number when this Phase begins relative to Project Day 0."
                    },
                    "tasks": {
                        "type": "ARRAY",
                        "items": {
                            "type": "OBJECT",
                            "properties": {
                                "taskName": {"type": "STRING"},
                                "description": {"type": "STRING"},
                                "priority": {"type": "STRING", "enum": ["High", "Medium", "Low"]},
                                "durationDays": {"type": "INTEGER"},
                                "startDayOffset": {
                                    "type": "INTEGER", 
                                    "description": "Days after the PHASE start that this task begins. 0 means starts immediately."
                                }
                            },
                            "required": ["taskName", "description", "priority", "durationDays", "startDayOffset"]
                        }
                    }
                },
                "required": ["groupName", "phaseStartDay", "tasks"]
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
                print(f"API Error: {response.text}")
                raise requests.HTTPError(f"API Error: {response.status_code}")
        except Exception as e:
            attempt += 1
            if attempt >= max_retries:
                raise
            time.sleep(1)

@app.route('/', methods=['GET'])
def home():
    return "Python Server is UP with Intelligent Scheduling!", 200

@app.route('/generate-plan', methods=['POST'])
def generate_plan_endpoint():
    if not request.json:
        return jsonify({"error": "Missing JSON body"}), 400
        
    user_query = request.json.get('description')
    user_strategy = request.json.get('strategy')

    if not user_query or not user_strategy:
        return jsonify({"error": "Missing description or strategy"}), 400

    try:
        system_prompt = SYSTEM_PROMPT_TEMPLATE.format(user_strategy=user_strategy)
        generated_plan_str = call_gemini_api(user_query, system_prompt, PROJECT_PLAN_SCHEMA)
        parsed_plan = json.loads(generated_plan_str)
        return jsonify(parsed_plan), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=5000)