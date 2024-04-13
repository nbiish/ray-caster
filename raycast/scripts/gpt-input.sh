#!/bin/bash
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title gpt-input
# @raycast.mode fullOutput
# Optional parameters:
# @raycast.icon 🤖
# @raycast.description Generate a response using the OPENAI API
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish
# @raycast.argument1 { "type": "text", "placeholder": "question or input" }


source .env

JSON=$(jq -n \
    --arg content "$1" \
    '{
        "model": "gpt-3.5-turbo",
        "messages": [
            {
                "role": "user",
                "content": $content
            }
        ],
        "temperature": 0.5,
        "max_tokens": 256,
        "top_p": 1,
        "frequency_penalty": 0,
        "presence_penalty": 0
    }'
)

curl https://api.openai.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d "$JSON"