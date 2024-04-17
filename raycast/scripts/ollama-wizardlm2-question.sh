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

model="wizardlm2"
echo $model
echo ""
ollama run $model """$1"""

