#!/bin/bash
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title test-gem
# @raycast.mode fullOutput
# Optional parameters:
# @raycast.icon 💎
# @raycast.description Generate a response using the Vertex AI Generative Models
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish
# @raycast.argument1 { "type": "text", "placeholder": "question or input" }



gcloud auth login

cat << EOF > request.json
{
    "contents": [
        {
            "role": "user",
            "parts": [
                {
                    "text": "$1"
                }
            ]
        }
    ],
    "generationConfig": {
        "maxOutputTokens": 8192,
        "temperature": 0.3,
        "topP": 0.95,
    },
    "safetySettings": [
        {
            "category": "HARM_CATEGORY_HATE_SPEECH",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
            "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
            "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
            "category": "HARM_CATEGORY_HARASSMENT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        }
    ],
}
EOF

API_ENDPOINT="us-central1-aiplatform.googleapis.com"
PROJECT_ID="in-digi-nous"
LOCATION_ID="us-central1"
MODEL_ID="gemini-1.5-pro-preview-0409"

curl \
-X POST \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
-H "Content-Type: application/json" \
"https://${API_ENDPOINT}/v1/projects/${PROJECT_ID}/locations/${LOCATION_ID}/publishers/google/models/${MODEL_ID}:streamGenerateContent" -d '@request.json'
