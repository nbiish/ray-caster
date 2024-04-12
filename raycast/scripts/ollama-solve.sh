#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ollama-solve
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤓

# Documentation:
# @raycast.description answers from clipboard with codegemma
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish

model="codegemma"
echo ''
echo 'codegemma:'
echo ''
ollama run $model "SOLVE THIS: $(pbpaste)"

