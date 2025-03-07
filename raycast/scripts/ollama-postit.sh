#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ollama-postit
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 👍

# Documentation:
# @raycast.description quick concise post about ....
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish
# @raycast.argument1 { "type": "text", "placeholder": "model" }
# @raycast.argument2 { "type": "text", "placeholder": "post about.." }

model_list=("phi4-mini" "granite-dense" "granite-moe" "granite3.1-dense" "granite3.1-moe" "granite-embedding" "mxbai-embed-large" "phi4" "granite-vision" "granite3.2-vision" "granite" "granite3.2" "deepseek" "deepseek-r1:8b")  # List of available models

model="$1"
post_about="""$2"""

# Check if arg1 is in the model_list
if [[ " ${model_list[@]} " =~ " $model " ]]; then
    model=$model
else
    echo "Invalid model. Using default model."
    model="llama3"
fi


echo ''
printf "MODEL:\n$model\n"
echo ''
system_prompt="""DO NOT BE VERBOSE.
MAKE A SHORT SOCIAL MEDIA POST OR COMMENT.
USE EMOJIS AND MAKE SIGNIFICANT VERBIAGE HASHTAGS:\n\n"""

full_prompt="$system_prompt$post_about"

ollama run $model $full_prompt