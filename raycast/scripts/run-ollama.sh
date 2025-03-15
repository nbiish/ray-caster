#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Run Ollama
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🦙
# @raycast.packageName Ollama Tools

# Documentation:
# @raycast.description All-in-one Ollama tool for prompting, solving problems, analyzing images, and model management
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish
# @raycast.argument1 { "type": "dropdown", "placeholder": "operation", "data": [{"title": "prompt", "value": "prompt"}, {"title": "question", "value": "question"}, {"title": "solve", "value": "solve"}, {"title": "solvex2", "value": "solvex2"}, {"title": "postit", "value": "postit"}, {"title": "terminal", "value": "terminal"}, {"title": "summary", "value": "summary"}, {"title": "image", "value": "image"}, {"title": "embedding", "value": "embedding"}, {"title": "list", "value": "list"}, {"title": "update", "value": "update"}] }
# @raycast.argument2 { "type": "dropdown", "placeholder": "model", "data": [{"title": "llama3 (default)", "value": "llama3"}, {"title": "deepseek-r1", "value": "deepseek-r1"}, {"title": "dolphin3", "value": "dolphin3"}, {"title": "gemma3", "value": "gemma3"}, {"title": "granite-embedding", "value": "granite-embedding"}, {"title": "granite3.1-dense", "value": "granite3.1-dense"}, {"title": "granite3.1-moe", "value": "granite3.1-moe"}, {"title": "granite3.2", "value": "granite3.2"}, {"title": "granite3.2-vision", "value": "granite3.2-vision"}, {"title": "mxbai-embed-large", "value": "mxbai-embed-large"}, {"title": "phi4", "value": "phi4"}, {"title": "phi4-mini", "value": "phi4-mini"}] }
# @raycast.argument3 { "type": "text", "placeholder": "prompt/path (not needed for solve/summary/terminal)", "optional": true }

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

# Run a basic prompt with the model
run_prompt() {
  print_model_info
  if [ -z "$prompt_or_path" ]; then
    echo "No prompt provided. Please include a prompt."
    exit 1
  fi
  
  # Set system prompt if needed (optional)
  system_prompt=""
  
  # Check for system prompt flags
  if [[ "$prompt_or_path" == "--post "* ]]; then
    # Extract actual prompt 
    actual_prompt="${prompt_or_path#"--post "}"
    system_prompt="DO NOT BE VERBOSE. MAKE A SHORT SOCIAL MEDIA POST OR COMMENT. USE EMOJIS AND MAKE SIGNIFICANT VERBIAGE HASHTAGS:"
    prompt_or_path="$actual_prompt"
  elif [[ "$prompt_or_path" == "--question "* ]]; then
    # Extract actual prompt
    actual_prompt="${prompt_or_path#"--question "}"
    system_prompt="YOU ARE A WORLD-RENOWNED LOGIC AND PROBLEM SOLVING EXPERT. BE CONCISE AND RESPOND IN PLAIN ENGLISH OR JUST CODE IF CODE IS PROVIDED IN THE FOLLOWING:"
    prompt_or_path="$actual_prompt"
  fi
  
  # Build final prompt
  if [ -n "$system_prompt" ]; then
    full_prompt="$system_prompt\n\n$prompt_or_path"
    result=$(ollama run "$model" "$full_prompt")
  else
    result=$(ollama run "$model" "$prompt_or_path")
  fi
  
  format_output "$result"
}

# Run a question with model-specific prompting
run_question() {
  if [ -z "$prompt_or_path" ]; then
    echo "No question provided. Please include a question."
    exit 1
  fi
  
  # Define prompts for different models
  icon="🤖"
  query="YOU ARE A WORLD RENOUN EXPERT IN LOGIC AND PROBLEM SOLVING. 
BE CONCISE AND RESPOND IN PLAIN ENGLISH OR JUST CODE IF CODE IS PROVIDED IN THE FOLLOWING:
$prompt_or_path"

  echo "$icon $model"
  echo ""
  echo "QUERY:"
  echo "$prompt_or_path"
  echo ""
  echo "RESPONSE:"
  ollama run "$model" "$query"
}

# Process clipboard content with model-specific prompting
run_solve() {
  # Define prompts and icons for different models
  icon="🤖"
  prompt="YOU ARE A WORLD RENOUN EXPERT IN LOGIC AND PROBLEM SOLVING. 
IF THERE IS CODE IN THE XML TAGS <user_input></user_input> THAT FOLLOW RETURN CONCISE CODE WITH COMMENTS AND DO NOT BE VERBOSE. 
THINKING STEP-BY-STEP AS THE FAMOUS LOGICIAN AND PROBLEM SOLVER YOU ARE RESPOND TO THE FOLLOWING: 
<user_input>$(pbpaste)</user_input>"

  echo ""
  printf "%.0s-" {1..81}
  echo ""
  echo "INPUT:"
  echo "$(pbpaste)"
  printf '%.0s-' {1..81}
  echo ""
  echo "$icon $model OUTPUT:"
  printf '%.0s-' {1..81}
  echo ""
  ollama run "$model" "$prompt"
  printf '%.0s-' {1..81}
  echo ""
}

# Run solve with two models (from ollama-solvex2.sh)
run_solvex2() {
  model1="gemma3"
  model2="deepseek"
  
  prompt="YOU ARE A WORLD RENOUN EXPERT IN LOGIC AND PROBLEM SOLVING. 
IF THERE IS CODE IN THE XML TAGS <user_input></user_input> THAT FOLLOW RETURN CONCISE CODE WITH COMMENTS AND DO NOT BE VERBOSE. 
THINKING STEP-BY-STEP AS THE FAMOUS LOGICIAN AND PROBLEM SOLVER YOU ARE RESPOND TO THE FOLLOWING: 
<user_input>$(pbpaste)</user_input>"
  
  echo ""
  printf "%.0s-" {1..81}
  echo ""
  echo "INPUT:"
  echo "$(pbpaste)"
  printf '%.0s-' {1..81}
  echo ""
  echo "$model1 OUTPUT:"
  printf '%.0s-' {1..81}
  echo ""
  ollama run $model1 "$prompt"
  printf '%.0s-' {1..81}
  echo ""
  echo "$model2 OUTPUT:"
  printf '%.0s-' {1..81}
  echo ""
  ollama run $model2 "$prompt"
  printf '%.0s-' {1..81}
  echo ""
}

# Create a social media post (from ollama-postit.sh)
run_postit() {
  if [ -z "$prompt_or_path" ]; then
    echo "No topic provided. Please include a topic for your post."
    exit 1
  fi
  
  echo ""
  echo "MODEL: $model"
  echo ""
  
  system_prompt="DO NOT BE VERBOSE.
MAKE A SHORT SOCIAL MEDIA POST OR COMMENT.
USE EMOJIS AND MAKE SIGNIFICANT VERBIAGE HASHTAGS:

"
  
  full_prompt="$system_prompt$prompt_or_path"
  ollama run "$model" "$full_prompt"
}

# Run terminal simulation (from ollama-terminal.sh)
run_terminal() {
  query="IMAGINE YOU'RE A COMMAND LINE TERMINAL TAKING IN <content>{{TEXT}}</content> AS INPUT. 
STRICTLY OUTPUT NOTHING ELSE. DO NOT BE VERBOSE. 
THINKING STEP-BY-STEP IMAGINE GOING THROUGH EACH LINE OF CODE 
AS A NORMAL COMPUTER PROGRAM WOULD FOR THE FOLLOWING INPUT:<content>$(pbpaste)</content>"

  echo ""
  printf "%.0s-" {1..81}
  echo ""
  echo "INPUT:"
  echo "$(pbpaste)"
  printf '%.0s-' {1..81}
  echo ""
  echo "$model OUTPUT:"
  printf '%.0s-' {1..81}
  echo ""
  ollama run "$model" "$query"
  printf '%.0s-' {1..81}
  echo ""
}

# Summarize text (from ollama-summary.sh)
run_summary() {
  echo ""
  echo "MODEL: $model"
  echo ""
  
  ollama run "$model" "SUMMARIZE THE FOLLOWING <user_input>{{TEXT}}</user_input> REGARDLESS OF THE FORMATTING WITHING THE XML TAGS DESCRIBED: 
<user_input>$(pbpaste)</user_input>
"
}

# Process an image using vision models
process_image() {
  print_model_info
  
  # Check if prompt is provided
  if [ -z "$prompt_or_path" ]; then
    echo "Error: Image path is required."
    echo "Usage: (drag & drop an image file or paste the path)"
    exit 1
  fi
  
  # Check if the input is a file path or a URL
  if [[ "$prompt_or_path" =~ ^(http|https|file)://.*\.(jpg|jpeg|png|gif|webp)$ ]]; then
    # It's a URL to an image
    image_path="$prompt_or_path"
    vision_prompt="${4:-Describe this image in detail.}"
  elif [ -f "$prompt_or_path" ]; then
    # It's a local file that exists
    image_path="$prompt_or_path"
    vision_prompt="${4:-Describe this image in detail.}"
  else
    # It's not a file, so treat it as a regular text prompt
    echo "The input doesn't appear to be an image file. Running as a text prompt instead."
    
    # Just use regular prompt mode if it's not an image
    run_prompt
    return
  fi
  
  echo ""
  echo "MODEL: $model"
  echo "IMAGE: $image_path"
  echo "PROMPT: $vision_prompt"
  echo ""
  
  echo "Analyzing image..."
  echo ""
  
  # Check if model has vision capabilities
  if [[ "$model" =~ .*vision.* ]]; then
    # Run the vision model with the provided image
    result=$(ollama run "$model" --image "$image_path" "$vision_prompt")
  else
    echo "Note: You're using a non-vision model with an image. Results may vary."
    # Try to use the image anyway, as some models might have multimodal capabilities
    result=$(ollama run "$model" --image "$image_path" "$vision_prompt" 2>/dev/null || echo "This model doesn't support image processing.")
  fi
  
  echo "RESULT:"
  echo "-------"
  format_output "$result"
}

# Generate text embeddings
generate_embedding() {
  # Check if jq is installed first
  if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed. Please install it with 'brew install jq'."
    exit 1
  fi
  
  # Prefer embedding models but allow any model for embeddings
  if [[ ! "$model" =~ .*embed.* && "$model" != "granite-embedding" ]]; then
    echo "Note: You're using a model that's not specifically designed for embeddings. For best results, consider using granite-embedding or mxbai-embed-large."
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
  "prompt")
    run_prompt
    ;;
  "question")
    run_question
    ;;
  "solve")
    run_solve
    ;;
  "solvex2")
    run_solvex2
    ;;
  "postit")
    run_postit
    ;;
  "terminal")
    run_terminal
    ;;
  "summary")
    run_summary
    ;;
  "image")
    process_image
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
    echo "Invalid operation. Please choose from: prompt, question, solve, solvex2, postit, terminal, summary, image, embedding, list, update"
    exit 1
    ;;
esac 