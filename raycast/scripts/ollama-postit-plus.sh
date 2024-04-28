#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ollama-postit-plus
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 👍

# Documentation:
# @raycast.description quick concise post about ....
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish
# @raycast.argument1 { "type": "text", "placeholder": "model (default llama3)" }
# @raycast.argument2 { "type": "text", "placeholder": "post about.." }

model_list=("dolphin-llama3" "codegemma" "codeqwen" "phi" "gemma" "llama2-uncensored" "mistral" "wizard-math" "wizard-vicuna-uncensored" "wizardlm2")  # List of available models

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



response1=$(ollama run $model $post_about)
printf "\n\n BEFORE EMOJIS$response1\n\n"




system_prompt1="""ADD EMOJIS TO THE FOLLOWING:"""
with_system_prompt1="$system_prompt1$response1"

second_response=$(ollama run $model """$with_system_prompt1""")
printf "\n\nBEFORE HASHTAGS$second_response\n\n"




system_prompt2="""ADD HASHTAGS THROUGHOUT THE FOLLOWING:"""
with_system_prompt2="$system_prompt2$second_response"

third_response=$(ollama run $model """$with_system_prompt2""")
printf "\n\nFINAL RESULT$third_response\n\n"