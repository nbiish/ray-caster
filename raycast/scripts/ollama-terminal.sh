#!/bin/bash
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ollama-terminal
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 💻

# Documentation:
# @raycast.description prints terminal output of clipboard with codegemma
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish

model="codegemma"
echo ''
echo 'codegemma:'
echo ''
models=("codegemma")
query="""IMAGINE YOU'RE OUTPUTTING AS A TERMINAL AND STRICTLY OUTPUT NOTHING ELSE. DO NOT BE VERBOSE. IMAGINE RUNNING UP AND DOWN THE CODE TO THOROUGHLY CONSIDER ALL OF THE FOLLOWING:\n\n$(pbpaste)"""

for model_name in "${models[@]}"; do
    result=$(ollama run $model_name <<< "$query")
    echo ""
    echo "    Output from $model_name:"
    echo "$result"
    echo ""
done
