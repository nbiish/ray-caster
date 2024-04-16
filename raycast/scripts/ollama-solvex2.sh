#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ollama-solve-x2
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🧠

# Documentation:
# @raycast.description answers from clipboard with codegemma and wizardlm2
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish

model1="wizardlm2"
model2="codegemma"
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
ollama run $model2 "YOU ARE AND EXPERT IN LOGIC AND PROBLEM SOLVING. IF THERE IS CODE IN THE <document>{{TEXT}}</document> RETURN CONCISE CODE WITH COMMENTS AND DO NOT BE VERBOSE. THINKING STEP-BY-STEP SOLVE THE FOLLOWING: <document>$(pbpaste)</document>"
printf '%.0s-' {1..81}
echo ''
echo "$model1 OUTPUT:"
printf '%.0s-' {1..81}
echo ''
ollama run $model1 "YOU ARE AND EXPERT IN LOGIC AND PROBLEM SOLVING. IF THERE IS CODE IN THE <document>{{TEXT}}</document> RETURN CONCISE CODE WITH COMMENTS AND DO NOT BE VERBOSE. THINKING STEP-BY-STEP SOLVE THE FOLLOWING: <document>$(pbpaste)</document>"
printf '%.0s-' {1..81}
echo ''




