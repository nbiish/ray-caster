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

model_list=("dolphin-llama3" "codegemma" "codeqwen" "phi" "gemma" "llama2-uncensored" "mistral" "wizard-math" "wizard-vicuna-uncensored" "wizardlm2")  # List of available models

model="$1"
user_content="""$2"""

# Check if arg1 is in the model_list
if [[ " ${model_list[@]} " =~ " $model " ]]; then
    model=$model
else
    echo "Invalid model. Using default model."
    model="llama3"
    echo "MODEL: $model"
fi

ollama run $model """$user_content"""
