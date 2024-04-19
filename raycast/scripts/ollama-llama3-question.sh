#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ollama-llama3-question
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🦙

# Documentation:
# @raycast.description get a simple question answered by llama3
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish

# @raycast.argument1 { "type": "text", "placeholder": "question" }

query="""YOU ARE A WORLD RENOUN LOGIC AND PROBLEM SOLVING EXPERT.
BE CONCISE AND RESPOND IN PLAIN ENGLISH OR JUST CODE IF CODE IS PROVIDED IN THE FOLLOWING:
$1"""

model="llama3"
echo $model
echo ""
ollama run $model $query

