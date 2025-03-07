#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Ollama Vision
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 👁️
# @raycast.packageName Ollama Tools

# Documentation:
# @raycast.description Use Ollama vision models to analyze images
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish
# @raycast.argument1 { "type": "dropdown", "placeholder": "vision model", "data": [{"title": "granite-vision", "value": "granite-vision"}, {"title": "granite3.2-vision", "value": "granite3.2-vision"}] }
# @raycast.argument2 { "type": "text", "placeholder": "image path (drag & drop image or paste path)" }
# @raycast.argument3 { "type": "text", "placeholder": "prompt (e.g., 'Describe this image')", "optional": true }

model="$1"
image_path="$2"
prompt="${3:-Describe this image in detail.}"

# Check if image path exists
if [ ! -f "$image_path" ]; then
  echo "Error: Image file not found at path: $image_path"
  exit 1
fi

# Print model information for user feedback
echo ""
echo "MODEL: $model"
echo "IMAGE: $image_path"
echo "PROMPT: $prompt"
echo ""

# Process the image with Ollama's vision model
echo "Analyzing image..."
echo ""

# Run the vision model with the provided image
result=$(ollama run "$model" --image "$image_path" "$prompt")

# Format and display the result
echo "RESULT:"
echo "-------"
echo "$result" | sed 's/^/> /' 