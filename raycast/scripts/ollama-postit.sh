#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ollama-postit
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 👍

# Documentation:
# @raycast.description quick concise post about ....
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish
# @raycast.argument1 { "type": "text", "placeholder": "model" }
# @raycast.argument2 { "type": "text", "placeholder": "post about.." }

model="$1"
post_about="$2"
echo ''
printf "MODEL:\n$model\n"
echo ''
ollama run $model """DO NOT BE VERBOSE AND MAKE A SHORT SOCIAL MEDIA POST OR COMMENT ABOUT:\n\n$post_about"""
