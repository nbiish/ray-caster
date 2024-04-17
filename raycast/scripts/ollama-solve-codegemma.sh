#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ollama-solve-codegemma
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🔧

# Documentation:
# @raycast.description answers from clipboard with codegemma
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish

model1="codegemma"
echo ''
printf "%.0s-" {1..81}
echo ''
echo "INPUT:"
echo $(pbpaste)
printf '%.0s-' {1..81}
echo ''
echo "$model1 OUTPUT:"
printf '%.0s-' {1..81}
echo ''
ollama run $model1 "YOU ARE A WORLD RENOUN EXPERT IN LOGIC AND PROBLEM SOLVING. IF THERE IS CODE IN THE XML TAGS <user_input></user_input> THAT FOLLOW RETURN CONCISE CODE WITH COMMENTS AND DO NOT BE VERBOSE. THINKING STEP-BY-STEP AS THE FAMOUS LOGICIAN AND PROBLEM SOLVER YOU ARE RESPOND TO THE FOLLOWING: <user_input>$(pbpaste)</user_input>"
printf '%.0s-' {1..81}
echo ''




