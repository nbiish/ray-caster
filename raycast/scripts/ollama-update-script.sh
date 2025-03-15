#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Ollama Update Script
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🔄
# @raycast.packageName Ollama Tools

# Documentation:
# @raycast.description Update the run-ollama.sh script with current models
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish

script_dir="$(dirname "$0")"
ollama_script="${script_dir}/run-ollama.sh"
temp_file="${script_dir}/run-ollama.sh.tmp"

# Check if the ollama script exists
if [ ! -f "$ollama_script" ]; then
  echo "Error: run-ollama.sh not found in ${script_dir}"
  exit 1
fi

echo "Updating run-ollama.sh with current models..."

# Get list of installed models
echo "Fetching installed Ollama models..."
models=$(ollama list | tail -n +2 | awk '{print $1}' | sed 's/:.*$//' | sort | uniq)

if [ -z "$models" ]; then
  echo "No Ollama models found. Make sure Ollama is running."
  exit 1
fi

echo "Found models: $models"
echo ""

# Generate the model dropdown data for raycast
model_data="[{\"title\": \"llama3 (default)\", \"value\": \"llama3\"}"

for model in $models; do
  # Skip if model is empty
  if [ -z "$model" ]; then
    continue
  fi
  
  # Add model to dropdown data
  model_data+=", {\"title\": \"${model}\", \"value\": \"${model}\"}"
done

model_data+="]"

# Update the script
echo "Updating script with new model list..."

# Read the script and update the model dropdown data
cat "$ollama_script" | sed "/# @raycast.argument2/s|{.*}|{ \"type\": \"dropdown\", \"placeholder\": \"model\", \"data\": ${model_data} }|" > "$temp_file"

# Check if the update was successful
if [ -s "$temp_file" ]; then
  # Backup the original script
  cp "$ollama_script" "${ollama_script}.bak"
  echo "Original script backed up to: ${ollama_script}.bak"
  
  # Replace with the updated script
  mv "$temp_file" "$ollama_script"
  chmod +x "$ollama_script"
  
  echo "Script updated successfully!"
else
  echo "Error: Failed to update the script."
  rm -f "$temp_file"
  exit 1
fi

echo ""
echo "Done! The run-ollama.sh script now contains the latest models." 