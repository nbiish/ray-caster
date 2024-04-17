#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ollama-wizardlm2-question
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description get a simple question answered by wizardlm2
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish

# @raycast.argument1 { "type": "text", "placeholder": "question" }

query="""YOU ARE A WORLD RENOUN EXPERT IN LOGIC AND PROBLEM SOLVING. IF THERE IS CODE IN THE XML TAGS <user_input></user_input> THAT FOLLOW RETURN CONCISE CODE WITH COMMENTS AND DO NOT BE VERBOSE. THINKING STEP-BY-STEP AS THE FAMOUS LOGICIAN AND PROBLEM SOLVER YOU ARE RESPOND TO THE FOLLOWING WITH CONCISE PLAIN ENGLISH: <user_input>$1</user_input>"""

model="wizardlm2"
echo $model
echo ""
ollama run $model $query

