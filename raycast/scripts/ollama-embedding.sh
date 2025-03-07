#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Ollama Embedding
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🧠
# @raycast.packageName Ollama Tools

# Documentation:
# @raycast.description Generate vector embeddings from text using Ollama
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish
# @raycast.argument1 { "type": "dropdown", "placeholder": "embedding model", "data": [{"title": "granite-embedding", "value": "granite-embedding"}, {"title": "mxbai-embed-large", "value": "mxbai-embed-large"}] }
# @raycast.argument2 { "type": "text", "placeholder": "text to embed" }
# @raycast.argument3 { "type": "dropdown", "placeholder": "output format", "data": [{"title": "Full", "value": "full"}, {"title": "Length Only", "value": "length"}, {"title": "First 5 Values", "value": "preview"}], "optional": true }

model="$1"
text="$2"
format="${3:-preview}"

# Print model information for user feedback
echo ""
echo "MODEL: $model"
echo "TEXT: $text"
echo ""

# Generate the embedding
echo "Generating embedding..."
echo ""

# Use Ollama to generate the embedding
# The 'jq' command is used to process the JSON output
result=$(echo "$text" | ollama embeddings -m "$model" 2>/dev/null)

# Depending on the format option, display different views of the embedding
case "$format" in
  "full")
    echo "FULL EMBEDDING:"
    echo "$result" | jq '.embedding'
    ;;
  "length")
    echo "EMBEDDING LENGTH:"
    echo "$result" | jq '.embedding | length'
    ;;
  "preview")
    echo "PREVIEW (First 5 values):"
    echo "$result" | jq '.embedding | .[0:5]'
    ;;
  *)
    echo "Invalid format option. Using preview."
    echo "PREVIEW (First 5 values):"
    echo "$result" | jq '.embedding | .[0:5]'
    ;;
esac

echo ""
echo "Embedding dimension: $(echo "$result" | jq '.embedding | length')" 