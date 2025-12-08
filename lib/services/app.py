import requests
import json
import time
import os
import re
from flask import Flask, request, jsonify
from flask_cors import CORS
from groq import Groq
from dotenv import load_dotenv 

load_dotenv()

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

#---<CONFIGURATION>---
API_KEY = os.environ.get("GEMINI_API_KEY", "")
GROQ_API_KEY = os.environ.get("GROQ_API_KEY", "")

if not API_KEY or not GROQ_API_KEY:
    print("WARNING: API Keys are missing.")

API_URL = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={API_KEY}"
groq_client = Groq(api_key=GROQ_API_KEY)

SYSTEM_PROMPT_TEMPLATE = """You are an expert Project Manager. Create a realistic execution plan.

SCHEDULING LOGIC:
1. **Analyze Dependencies:** Sequential tasks must obey start/end constraints. Independent tasks should run PARALLEL.
2. **Apply Strategy:** - "Fast"/"Aggressive": Maximize overlapping (intercalated) tasks.
   - "Safe"/"Sequential": Minimize overlap.
3. **Calculate Offsets:**
   - 'phaseStartDay': Day number when the Phase begins relative to Project Day 0.
   - 'startDayOffset': Day number when the Task begins relative to the Phase Start.

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
                    "phaseStartDay": {"type": "INTEGER"},
                    "tasks": {
                        "type": "ARRAY",
                        "items": {
                            "type": "OBJECT",
                            "properties": {
                                "taskName": {"type": "STRING"},
                                "description": {"type": "STRING"},
                                "priority": {"type": "STRING", "enum": ["High", "Medium", "Low"]},
                                "durationDays": {"type": "INTEGER"},
                                "startDayOffset": {"type": "INTEGER"}
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

#---<HELPERS>---
def extract_json_from_text(text):
    """
    Aggressively finds the JSON object within a text block.
    """
    try:
        start = text.find('{')
        end = text.rfind('}') + 1
        if start != -1 and end != -1:
            return text[start:end]
        return text 
    except Exception:
        return text

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
                content = result.get('candidates', [{}])[0].get('content', {}).get('parts', [{}])[0]
                if 'text' in content:
                    return content['text']
            raise requests.HTTPError(f"Status: {response.status_code}")
        except Exception as e:
            attempt += 1
            if attempt >= max_retries: raise
            time.sleep(1)

def validate_plan_with_groq(generated_plan, user_strategy):
    audit_prompt = f"""
    You are a helpful Project Management Coach. Review this plan against the strategy: "{user_strategy}".
    
    PLAN: {json.dumps(generated_plan)}

    SCORING RULES:
    - 100: Perfect plan.
    - 80-99: Good plan.
    - < 50: Broken logic.

    FEEDBACK FORMATTING (CRITICAL):
    - Return 'feedback' as a SINGLE string.
    - Use "Step 1:", "Step 2:", "Step 3:" as separators.
    - Example: "Step 1: Timeline is good. Step 2: Strategy matches. Step 3: Check durations."

    Respond with JSON ONLY:
    {{
        "confidence_score": integer (0-100),
        "feedback": "Step 1: ... Step 2: ...",
        "specific_issues": []
    }}
    """

    try:
        response = groq_client.chat.completions.create(
            model="llama-3.3-70b-versatile", 
            messages=[
                {"role": "system", "content": "You are a JSON-only QA System."},
                {"role": "user", "content": audit_prompt}
            ],
            response_format={"type": "json_object"},
            temperature=0.1
        )
        
        raw_content = response.choices[0].message.content
        #Clean the response before parsing
        cleaned_content = extract_json_from_text(raw_content)
        return json.loads(cleaned_content)
        
    except Exception as e:
        print(f"Groq Audit Failed: {e}")
        return {
            "confidence_score": 80, #Fallback to prevent UI hiding
            "feedback": "Step 1: Auditor unavailable. Step 2: Please review manually.",
            "specific_issues": []
        }

@app.route('/', methods=['GET'])
def home():
    return "TaskFlow Server Running", 200

@app.route('/generate-plan', methods=['POST'])
def generate_plan_endpoint():
    if not request.json or 'description' not in request.json:
        return jsonify({"error": "Missing inputs"}), 400

    user_query = request.json.get('description')
    user_strategy = request.json.get('strategy', 'Standard')

    try:
        print(f"--- 1. Generating: {user_query} ---")
        system_prompt = SYSTEM_PROMPT_TEMPLATE.format(user_strategy=user_strategy)
        
        plan_str = call_gemini_api(user_query, system_prompt, PROJECT_PLAN_SCHEMA)
        plan_json = json.loads(plan_str)
        
        final_score = 0
        final_report = {}

        #Optimizing loop
        for attempt in range(2):
            audit = validate_plan_with_groq(plan_json, user_strategy)
            
            final_score = audit.get('confidence_score', 0)
            final_report = audit

            if final_score >= 80:
                break
            
            if attempt == 0:
                issues = audit.get('specific_issues', [])
                fix_prompt = f"""
                Quality Score: {final_score}/100.
                CRITIC FEEDBACK: {json.dumps(issues)}
                TASK: Regenerate JSON to fix these issues. Goal: "{user_query}"
                """
                plan_str = call_gemini_api(fix_prompt, system_prompt, PROJECT_PLAN_SCHEMA)
                plan_json = json.loads(plan_str)

        response_data = {
            **plan_json, 
            "audit_score": final_score,
            "audit_feedback": final_report.get('feedback', "No feedback available."),
            "audit_issues": final_report.get('specific_issues', [])
        }

        return jsonify(response_data), 200

    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=5000)