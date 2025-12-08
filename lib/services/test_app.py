import json
import pytest
import requests_mock
from unittest.mock import patch

# Import your app
from app import app, API_URL, SYSTEM_PROMPT_TEMPLATE, PROJECT_PLAN_SCHEMA

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

# --- TEST 1: SUCCESSFUL GENERATION ---
def test_generate_plan_success(client):
    # Mock data that Gemini would return
    mock_gemini_response = {
        "candidates": [{
            "content": {
                "parts": [{
                    "text": json.dumps({
                        "projectName": "Test Project",
                        "groups": []
                    })
                }]
            }
        }]
    }

    # Mock data that Groq would return
    mock_groq_response = {
        "choices": [{
            "message": {
                "content": json.dumps({
                    "confidence_score": 90,
                    "feedback": "Step 1: Good job.",
                    "specific_issues": []
                })
            }
        }]
    }

    # We mock both external API calls
    with requests_mock.Mocker() as m:
        # Mock Gemini
        m.post(API_URL, json=mock_gemini_response, status_code=200)
        
        # Mock Groq (using patch because it's a library call, not direct requests)
        with patch('app.groq_client.chat.completions.create') as mock_groq:
            # Setup the mock object structure to match Groq's response
            mock_groq.return_value.choices = [type('obj', (object,), {'message': type('obj', (object,), {'content': mock_groq_response['choices'][0]['message']['content']})})()]

            # Make the request to YOUR server
            response = client.post('/generate-plan', json={
                'description': 'Build a shed',
                'strategy': 'Fast'
            })

            # Assertions
            assert response.status_code == 200
            data = response.get_json()
            assert data['projectName'] == "Test Project"
            assert data['audit_score'] == 90

# --- TEST 2: MISSING INPUT ---
def test_generate_plan_missing_input(client):
    response = client.post('/generate-plan', json={})
    assert response.status_code == 400
    # <input> // FIXED: Matched the error message "Missing inputs" from app.py
    assert "Missing inputs" in response.get_json()['error']

# --- TEST 3: GEMINI FAILURE ---
def test_gemini_api_failure(client):
    with requests_mock.Mocker() as m:
        # Simulate Gemini crashing
        m.post(API_URL, status_code=500, text="Internal Server Error")

        response = client.post('/generate-plan', json={
            'description': 'Fail me',
            'strategy': 'Fast'
        })

        assert response.status_code == 500
        assert "500" in response.get_json()['error']