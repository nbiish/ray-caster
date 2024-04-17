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


model1="codegemma"
# model2="wizardlm2"
# models=($model1 $model2)
query="""IMAGINE YOU'RE A COMMAND LINE TERMINAL TAKING IN <content>{{TEXT}}</content> AS INPUT. 
STRICTLY OUTPUT NOTHING ELSE. DO NOT BE VERBOSE. 
THINKING STEP-BY-STEP IMAGINE GOING THROUGH EACH LINE OF CODE 
AS A NORMAL COMPUTER PROGRAM WOULD FOR THE FOLLOWING INPUT:<content>$(pbpaste)</content>"""

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
ollama run $model1 <<< "$query"
printf '%.0s-' {1..81}
echo ''

# DECIDED AGAINST RUNNING ONE THAN ONE MODEL
# IT'S ABOUT FAST INFORMATIVE OUTPUT
# for model_name in "${models[@]}"; do
#     echo "$model_name OUTPUT:"
#     printf '%.0s-' {1..81}
#     echo ''
#     result=$(ollama run $model_name <<< "$query")
#     echo "$result"
#     printf '%.0s-' {1..81}
#     echo ''
# done