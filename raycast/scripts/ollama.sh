#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Ollama
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🦙
# @raycast.packageName Ollama Tools

# Documentation:
# @raycast.description All-in-one Ollama tool for chat, posts, vision, embeddings and model management
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish
# @raycast.argument1 { "type": "dropdown", "placeholder": "operation", "data": [{"title": "chat", "value": "chat"}, {"title": "post", "value": "post"}, {"title": "question", "value": "question"}, {"title": "vision", "value": "vision"}, {"title": "embedding", "value": "embedding"}, {"title": "list", "value": "list"}, {"title": "update", "value": "update"}] }
# @raycast.argument2 { "type": "dropdown", "placeholder": "model", "data": [{"title": "llama3 (default)", "value": "llama3"}, {"title": "deepseek", "value": "deepseek"}, {"title": "deepseek-r1", "value": "deepseek-r1"}, {"title": "granite", "value": "granite"}, {"title": "granite-dense", "value": "granite-dense"}, {"title": "granite-embedding", "value": "granite-embedding"}, {"title": "granite-moe", "value": "granite-moe"}, {"title": "granite-vision", "value": "granite-vision"}, {"title": "granite3.1-dense", "value": "granite3.1-dense"}, {"title": "granite3.1-moe", "value": "granite3.1-moe"}, {"title": "granite3.2", "value": "granite3.2"}, {"title": "granite3.2-vision", "value": "granite3.2-vision"}, {"title": "mxbai-embed-large", "value": "mxbai-embed-large"}, {"title": "phi4", "value": "phi4"}, {"title": "phi4-mini", "value": "phi4-mini"}] }
# @raycast.argument3 { "type": "text", "placeholder": "prompt/path", "optional": true }

operation="$1"
model="$2"
prompt_or_path="$3"

# Print model information for user feedback
print_model_info() {
  echo ""
  echo "MODEL: $model"
  echo ""
}

# Standard output format
format_output() {
  local output="$1"
  echo "$output" | sed 's/^/> /'
}

# Run a basic chat with the model
run_chat() {
  print_model_info
  if [ -z "$prompt_or_path" ]; then
    echo "No prompt provided. Please include a prompt."
    exit 1
  fi
  
  result=$(ollama run "$model" "$prompt_or_path")
  format_output "$result"
}

# Create a social media post
create_post() {
  print_model_info
  if [ -z "$prompt_or_path" ]; then
    echo "No topic provided. Please include a topic for the post."
    exit 1
  fi
  
  echo "Creating social media post about: $prompt_or_path"
  echo ""
  
  system_prompt="DO NOT BE VERBOSE. MAKE A SHORT SOCIAL MEDIA POST OR COMMENT. USE EMOJIS AND MAKE SIGNIFICANT VERBIAGE HASHTAGS:"
  full_prompt="$system_prompt\n\n$prompt_or_path"
  
  result=$(ollama run "$model" "$full_prompt")
  format_output "$result"
}

# Answer a question concisely
answer_question() {
  print_model_info
  if [ -z "$prompt_or_path" ]; then
    echo "No question provided. Please include a question."
    exit 1
  fi
  
  system_prompt="YOU ARE A WORLD-RENOWNED LOGIC AND PROBLEM SOLVING EXPERT. BE CONCISE AND RESPOND IN PLAIN ENGLISH OR JUST CODE IF CODE IS PROVIDED IN THE FOLLOWING:"
  full_prompt="$system_prompt\n\n$prompt_or_path"
  
  result=$(ollama run "$model" "$full_prompt")
  format_output "$result"
}

# Process an image using vision models
process_vision() {
  if [[ ! "$model" =~ .*vision.* ]]; then
    echo "Error: You must select a vision-capable model (e.g., granite-vision, granite3.2-vision)"
    echo "Current model: $model"
    exit 1
  fi
  
  if [ -z "$prompt_or_path" ]; then
    echo "Error: Image path is required."
    echo "Usage: (drag & drop an image file or paste the path)"
    exit 1
  fi
  
  # Check if image path exists
  if [ ! -f "$prompt_or_path" ]; then
    echo "Error: Image file not found at path: $prompt_or_path"
    exit 1
  fi
  
  # Default prompt for image analysis if not provided
  vision_prompt="${4:-Describe this image in detail.}"
  
  echo ""
  echo "MODEL: $model"
  echo "IMAGE: $prompt_or_path"
  echo "PROMPT: $vision_prompt"
  echo ""
  
  echo "Analyzing image..."
  echo ""
  
  # Run the vision model with the provided image
  result=$(ollama run "$model" --image "$prompt_or_path" "$vision_prompt")
  
  echo "RESULT:"
  echo "-------"
  format_output "$result"
}

# Generate text embeddings
generate_embedding() {
  if [[ ! "$model" =~ .*embed.* && "$model" != "granite-embedding" ]]; then
    echo "Error: You must select an embedding-capable model (e.g., granite-embedding, mxbai-embed-large)"
    echo "Current model: $model"
    exit 1
  fi
  
  if [ -z "$prompt_or_path" ]; then
    echo "Error: Text to embed is required."
    exit 1
  fi
  
  # Default format is preview
  format="${4:-preview}"
  
  echo ""
  echo "MODEL: $model"
  echo "TEXT: $prompt_or_path"
  echo ""
  
  echo "Generating embedding..."
  echo ""
  
  # Use curl to access the Ollama API directly
  result=$(curl -s "http://localhost:11434/api/embed" \
    -H "Content-Type: application/json" \
    -d "{\"model\": \"$model\", \"input\": \"$prompt_or_path\"}")
  
  # Check if result is empty
  if [ -z "$result" ]; then
    echo "Error: Failed to generate embeddings. Check if Ollama is running."
    exit 1
  fi
  
  # Check if jq is installed
  if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed. Please install it with 'brew install jq'."
    echo "Raw embedding result:"
    echo "$result"
    exit 1
  fi
  
  # Check if the result contains embedding data
  if ! echo "$result" | jq -e '.embedding' &>/dev/null; then
    echo "Error: The response does not contain embedding data."
    echo "Raw response:"
    echo "$result"
    exit 1
  fi
  
  # Get embedding dimension
  embedding_dimension=$(echo "$result" | jq '.embedding | length')
  
  # Depending on the format option, display different views of the embedding
  case "$format" in
    "full")
      echo "FULL EMBEDDING ($embedding_dimension dimensions):"
      echo "$result" | jq '.embedding'
      ;;
    "length")
      echo "EMBEDDING LENGTH:"
      echo "$embedding_dimension dimensions"
      ;;
    "preview")
      echo "PREVIEW (First 5 values of $embedding_dimension dimensions):"
      echo "$result" | jq '.embedding | .[0:5]'
      ;;
    *)
      echo "Invalid format option. Using preview."
      echo "PREVIEW (First 5 values of $embedding_dimension dimensions):"
      echo "$result" | jq '.embedding | .[0:5]'
      ;;
  esac
  
  echo ""
  echo "Embedding dimension: $embedding_dimension"
}

# List all available models
list_models() {
  echo "AVAILABLE OLLAMA MODELS:"
  echo "-----------------------"
  ollama list | column -t
}

# Update all installed models
update_models() {
  echo "UPDATING ALL OLLAMA MODELS:"
  echo "--------------------------"
  
  # Get all model names without version/tag info
  models=$(ollama list | tail -n +2 | awk '{print $1}' | sed 's/:.*$//')
  
  # Remove duplicates
  unique_models=$(echo "$models" | sort | uniq)
  
  # Pull each model to update
  for model in $unique_models; do
    echo "Updating $model..."
    ollama pull "$model"
    echo ""
  done
  
  echo "All models updated successfully!"
}

# Main execution logic based on operation
case "$operation" in
  "chat")
    run_chat
    ;;
  "post")
    create_post
    ;;
  "question")
    answer_question
    ;;
  "vision")
    process_vision
    ;;
  "embedding")
    generate_embedding
    ;;
  "list")
    list_models
    ;;
  "update")
    update_models
    ;;
  *)
    echo "Invalid operation. Please choose from: chat, post, question, vision, embedding, list, update"
    exit 1
    ;;
esac 