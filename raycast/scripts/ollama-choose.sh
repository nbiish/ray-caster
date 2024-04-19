#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ollama-choose
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🧐

# Documentation:
# @raycast.description pick a model you know you have and input text
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish
# @raycast.argument1 { "type": "text", "placeholder": "model" }
# @raycast.argument2 { "type": "text", "placeholder": "content.." }

model="$1"
user_content="$2"
echo ''
printf "MODEL:\n$model\n"
echo ''
ollama run $model """$user_content"""
