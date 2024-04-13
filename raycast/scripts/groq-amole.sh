#!/bin/bash
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title GROQ-amole!
# @raycast.mode fullOutput
# Optional parameters:
# @raycast.icon 🦑
# @raycast.description Generate a response using the GROQ API
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish
# @raycast.argument1 { "type": "text", "placeholder": "question or input" }



source .env

API_KEY="$GROQ_API_KEY"


response=$(curl "https://api.groq.com/openai/v1/chat/completions" \
  -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d "{
         \"messages\": [
           {
             \"role\": \"user\",
             \"content\": \"$1\"
           }
         ],
         \"model\": \"mixtral-8x7b-32768\",
         \"temperature\": 1,
         \"max_tokens\": 1024,
         \"top_p\": 1,
         \"stream\": false,
         \"stop\": null
       }")
model=$(echo "$response" | jq -r '.model')
usage=$(echo "$response" | jq -r '.usage')
content=$(echo "$response" | jq -r '.choices[0].message.content')
completion_time=$(echo "$response" | jq -r '.usage.completion_time')

echo ''
echo ''
echo ''
printf '%.0s-' {1..81}
echo ''
echo "INPUT:"
echo "$1"
printf '%.0s-' {1..81}
echo ''
echo "MODEL:"
echo "$model"
printf '%.0s-' {1..81}
echo ''
echo "Response:"
printf '%.0s-' {1..81}
echo ''
echo "$content"
printf '%.0s-' {1..81}
echo ''
echo ''
echo ''
echo '👍🧿👄🧿💻:'
echo 'Stats for nerds:'
printf '%.0s-' {1..81}
echo ''
echo "Usage: $usage"
