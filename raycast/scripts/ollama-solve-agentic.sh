#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ollama-solve-agentic
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🕵🏼‍♂️

# Documentation:
# @raycast.description answers from clipboard with codegemma
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish
# @raycast.argument1 { "type": "text", "placeholder": "question" }


model1="codegemma"
model2="wizardlm2"
math_model="wizard-math"

query="$1"

echo ''
printf "%.0s-" {1..81}
echo ''
echo "INPUT:"
echo "$query"
printf '%.0s-' {1..81}
echo ''
# WIZARD-MATH SECTION ################
echo "$math_model OUTPUT:"
printf '%.0s-' {1..81}
echo ''
math_model_response=$(ollama run $math_model "RETURN CONCISE PLAIN ENGLISH OR CODE AND DO NOT BE VERBOSE. THINKING STEP-BY-STEP AS THE FAMOUS MATHMETICIAN AND PROBLEM SOLVER YOU ARE, COMPLETE THE FOLLOWING: <user_input>$1</user_input>")
echo "$math_model_response"
echo ''
### END - WIZARD-MATH SECTION ################

# CODEGEMMA SECTION ################
printf '%.0s-' {1..81}
echo ''
echo "$model1 OUTPUT:"
printf '%.0s-' {1..81}
echo ''
model_one_response=$(ollama run $model1 "YOU ARE A WORLD FAMOUS EXPERT IN LOGIC AND PROBLEM SOLVING. IN THE XML TAGS <user_input></user_input> THAT FOLLOW THERE WILL BE AN EXPERT MATHMETICIAN AND LOGICIAN RESPONSE. RESPOND WITH CONCISE PLAIN ENGLISH OR CODE. THINK STEP-BY-STEP, REFLECT DEEPLY, AND LOGICALLY RESPOND TO THE FOLLOWING: <user_input>$math_model_response</user_input>")
echo "$model_one_response"
printf '%.0s-' {1..81}
echo ''
### END - CODEGEMMA SECTION ################


# WIZARDLM2 SECTION ####################
# printf '%.0s-' {1..81}
# echo ''
# echo "$model2 OUTPUT:"
# printf '%.0s-' {1..81}
# echo ''
# model_two_response=$(ollama run $model2 "YOU ARE A WORLD FAMOUS EXPERT IN LOGIC AND PROBLEM SOLVING. THE XML TAGS <user_input></user_input> THAT FOLLOW ARE FROM AN EXPERT MATHMETICIAN LLM. RETURN CONCISE PLAIN ENGLISH OR CODE AND DO NOT BE VERBOSE. THINKING STEP-BY-STEP AS THE FAMOUS LOGICIAN AND PROBLEM SOLVER YOU ARE RESPOND TO THE FOLLOWING. DO NOT USE XML TAGS: <user_input>$math_model_response</user_input>")
# echo "$model_two_response"
# printf '%.0s-' {1..81}
# echo ''
### END - WIZARDLM2 SECTION ####################



