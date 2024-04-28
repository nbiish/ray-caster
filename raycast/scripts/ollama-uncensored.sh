#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ollama-uncensored

# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🦙

# Documentation:
# @raycast.description get a simple question answered by llama2-uncensored
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish

# @raycast.argument1 { "type": "text", "placeholder": "1=llama, 2=wizard" }
# @raycast.argument2 { "type": "text", "placeholder": "input" }

if [[ $1 == '1' ]]; then
    model="dolphin-llama3"
elif [[ $1 == '2' ]]; then
    model="wizard-vicuna-uncensored"
else
    model="dolphin-llama3"
fi

concise_query="""YOU ARE A WORLD RENOUN LOGIC AND PROBLEM SOLVING EXPERT.
BE CONCISE AND RESPOND IN PLAIN ENGLISH OR JUST CODE IF CODE IS PROVIDED IN THE FOLLOWING:
$2"""

query="""$2"""

echo $model
echo ""
ollama run $model $query

