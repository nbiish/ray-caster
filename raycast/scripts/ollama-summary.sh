#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ollama-summary
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 📰

# Documentation:
# @raycast.description sums clipboard with codegemma
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish

model="codegemma"
echo ''
echo 'codegemma:'
echo ''
ollama run $model """SUMMARIZE THE FOLLOWING REGARDLESS OF THE FORMATTING THAT FOLLOWS:
$(pbpaste)
"""
