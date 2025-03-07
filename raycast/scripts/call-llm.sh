#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title call-llm
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🧠
# @raycast.packageName LLM Tools
# @raycast.description Unified tool for all LLMs (OpenAI, Claude, Gemini, Groq) with provider & model selection
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish

# @raycast.argument1 { "type": "dropdown", "placeholder": "provider", "data": [{"title": "Claude (Anthropic)", "value": "claude"}, {"title": "GPT (OpenAI)", "value": "openai"}, {"title": "Gemini (Google)", "value": "gemini"}, {"title": "Groq", "value": "groq"}, {"title": "OpenRouter", "value": "openrouter"}] }

# @raycast.argument2 { "type": "dropdown", "placeholder": "model", "data": [{"title": "Claude 3.7 Sonnet", "value": "claude-3-7-sonnet-20240620", "parentValue": "claude"}, {"title": "Claude 3.5 Sonnet", "value": "claude-3-5-sonnet-20240620", "parentValue": "claude"}, {"title": "Claude 3 Haiku", "value": "claude-3-haiku-20240307", "parentValue": "claude"}, {"title": "GPT-4o (Omni)", "value": "gpt-4o-2024-11-20", "parentValue": "openai"}, {"title": "GPT-4o Mini", "value": "gpt-4o-mini-2024-07-18", "parentValue": "openai"}, {"title": "Gemini 2.0 Pro", "value": "gemini-2.0-pro", "parentValue": "gemini"}, {"title": "Gemini 2.0 Flash", "value": "gemini-2.0-flash", "parentValue": "gemini"}, {"title": "Gemini 2.0 Thinking", "value": "gemini-2.0-thinking", "parentValue": "gemini"}, {"title": "Groq QWQ 32B", "value": "qwen-qwq-32b", "parentValue": "groq"}, {"title": "Groq Qwen 2.5 Coder", "value": "qwen-2.5-coder-32b", "parentValue": "groq"}, {"title": "Groq DeepSeek R1 Llama", "value": "deepseek-r1-distill-llama-70b", "parentValue": "groq"}, {"title": "Groq Llama 3.3 70B SpecdDec", "value": "llama-3.3-70b-specdec", "parentValue": "groq"}, {"title": "Openrouter - Auto", "value": "openrouter/auto", "parentValue": "openrouter"}, {"title": "Openrouter - Gemini Pro", "value": "google/gemini-2.0-pro-exp-02-05:free", "parentValue": "openrouter"}, {"title": "Openrouter - Gemini Flash", "value": "google/gemini-2.0-flash-thinking-exp:free", "parentValue": "openrouter"}, {"title": "Openrouter - DeepSeek R1", "value": "deepseek/deepseek-r1:free", "parentValue": "openrouter"}] }

# @raycast.argument3 { "type": "text", "placeholder": "prompt/input" }

provider="$1"
model="$2"
prompt="$3"

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REQS_DIR="$SCRIPT_DIR/reqs"
PYTHON_SCRIPTS_DIR="$SCRIPT_DIR/python_scripts"

# Ensure Python 3 is installed
if ! command -v python3 &>/dev/null; then
    echo "Python 3 is not installed"
    exit 1
fi

# Function to setup virtual environment
setup_venv() {
    local venv_name="$1"
    local req_file="$2"
    
    # Create venv if it doesn't exist
    if [ ! -d "$SCRIPT_DIR/venv-$venv_name" ]; then
        echo "Creating $venv_name virtual environment..."
        python3 -m venv "$SCRIPT_DIR/venv-$venv_name" > /dev/null 2>&1
    fi
    
    # Activate the venv
    source "$SCRIPT_DIR/venv-$venv_name/bin/activate"
    
    # Install requirements
    if [ -f "$REQS_DIR/$req_file" ]; then
        pip install -r "$REQS_DIR/$req_file" > /dev/null 2>&1
    else
        echo "reqs/$req_file not found"
        deactivate
        exit 1
    fi
}

# Function to print model information
print_model_info() {
    local provider_icon="$1"
    echo ""
    echo "$provider_icon PROVIDER: $provider"
    echo "$provider_icon MODEL: $model"
    echo ""
}

# Function to run Claude models
run_claude() {
    setup_venv "claude" "claude-requirements.txt"
    
    icon="🪷"
    print_model_info "$icon"
    
    # Export model as environment variable and run the common Python script
    export CLAUDE_MODEL="$model"
    python3 "$PYTHON_SCRIPTS_DIR/call-claude-common.py" "$prompt"
    
    # Deactivate venv
    deactivate
}

# Function to run OpenAI models
run_openai() {
    setup_venv "openai" "openai-requirements.txt"
    
    icon="🤖"
    print_model_info "$icon"
    
    # Export model as environment variable and run the common Python script
    export GPT_MODEL="$model"
    python3 "$PYTHON_SCRIPTS_DIR/call-openai-common.py" "$prompt"
    
    # Deactivate venv
    deactivate
}

# Function to run Google Gemini models
run_gemini() {
    setup_venv "gem" "gem-requirements.txt"
    
    icon="💎"
    print_model_info "$icon"
    
    # Export model as environment variable and run the common Python script
    export GEMINI_MODEL="$model"
    python3 "$PYTHON_SCRIPTS_DIR/call-gemini-common.py" "$prompt"
    
    # Deactivate venv
    deactivate
}

# Function to run Groq models
run_groq() {
    setup_venv "groq" "groq-requirements.txt"
    
    icon="⚡"
    print_model_info "$icon"
    
    # Export model as environment variable and run the common Python script
    export GROQ_MODEL="$model"
    python3 "$PYTHON_SCRIPTS_DIR/call-groq-common.py" "$prompt"
    
    # Deactivate venv
    deactivate
}

# Function to run OpenRouter models
run_openrouter() {
    # Create OpenRouter requirements file if it doesn't exist
    if [ ! -f "$REQS_DIR/openrouter-requirements.txt" ]; then
        echo "Creating OpenRouter requirements file..."
        mkdir -p "$REQS_DIR"
        echo "openai>=1.12.0" > "$REQS_DIR/openrouter-requirements.txt"
        echo "python-dotenv>=1.0.0" >> "$REQS_DIR/openrouter-requirements.txt"
    fi
    
    setup_venv "openrouter" "openrouter-requirements.txt"
    
    icon="🔄"
    print_model_info "$icon"
    
    # Export model as environment variable
    export OPENROUTER_MODEL="$model"
    
    # Create or update the OpenRouter script
    mkdir -p "$PYTHON_SCRIPTS_DIR"
    cat > "$PYTHON_SCRIPTS_DIR/call-openrouter-common.py" << 'EOF'
#!/usr/bin/env python3

from openai import OpenAI
import os
import json
from dotenv import load_dotenv
import sys

# Load the .env file
load_dotenv()

# Get model from environment variable or use default
model = os.getenv("OPENROUTER_MODEL", "openrouter/auto")

# Get OpenRouter API key
api_key = os.getenv("OPENROUTER_API_KEY")
if not api_key:
    print("Error: OPENROUTER_API_KEY not found in .env file")
    sys.exit(1)

# Set up client with OpenRouter base URL
client = OpenAI(
    base_url="https://openrouter.ai/api/v1",
    api_key=api_key,
    default_headers={
        "HTTP-Referer": "https://raycast.com/nbiish",  # Required for OpenRouter API
        "X-Title": "Raycast LLM Tool"  # Optional
    }
)

# Get the prompt from the command line arguments
prompt = sys.argv[1]

try:
    # Make the API call
    response = client.chat.completions.create(
        model=model,
        messages=[
            {"role": "system", "content": "You are a helpful assistant that provides accurate and concise responses."},
            {"role": "user", "content": prompt}
        ],
        max_tokens=1024,
        temperature=0.7,  # Slightly increase temperature for more creative responses
    )

    # Print the formatted output
    print('\n' * 2)
    print('-' * 81)
    print('INPUT:')
    print(prompt)
    print('-' * 81)
    print('MODEL:')
    print(model)
    
    # Check if we got a meaningful response
    content = response.choices[0].message.content.strip() if response.choices and response.choices[0].message.content else ""
    
    if content:
        print('-' * 81)
        print('Response:')
        print('⚡️' * 36)
        print('-' * 81)
        print(content)
        print('-' * 81)
        print('⚡️' * 36)
    else:
        print('-' * 81)
        print('WARNING: Received empty response')
        print('-' * 81)
        print('Debug information:')
        print(f'Response object keys: {dir(response)}')
        print(f'Response model: {response.model}')
        print(f'Response id: {response.id}')
        print(f'Response choices: {len(response.choices)}')
        if response.choices:
            print(f'First choice keys: {dir(response.choices[0])}')
            print(f'First choice finish reason: {response.choices[0].finish_reason}')
            
        # Try different models - suggest alternatives
        print('-' * 81)
        print('You might want to try one of these alternative models:')
        try:
            top_models = ['openrouter/auto', 'google/gemini-2.0-pro-exp-02-05:free', 'deepseek/deepseek-r1:free']
            for alt_model in top_models:
                if alt_model != model:
                    print(f"- {alt_model}")
        except Exception as e:
            print(f"Could not suggest alternatives: {str(e)}")
    
    # Print usage information if available
    print('\n')
    print('Stats:')
    print('-' * 81)
    if hasattr(response, 'usage') and response.usage:
        print(f'Prompt tokens: {response.usage.prompt_tokens}')
        print(f'Completion tokens: {response.usage.completion_tokens}')
        print(f'Total tokens: {response.usage.total_tokens}')
    
except Exception as e:
    print(f"Error: {str(e)}")
    print("\nAvailable models on OpenRouter:")
    try:
        models_response = client.models.list()
        print('-' * 40)
        print("Free models you can try:")
        free_models = []
        for model_info in models_response.data:
            if ":free" in model_info.id:
                free_models.append(model_info.id)
                print(f"- {model_info.id}")
        
        if not free_models:
            print("No free models found. Here are some available models:")
            for i, model_info in enumerate(models_response.data):
                if i < 10:  # Limit to 10 models to avoid overwhelming output
                    print(f"- {model_info.id}")
    except Exception as list_error:
        print(f"Could not list models: {str(list_error)}")
EOF
    chmod +x "$PYTHON_SCRIPTS_DIR/call-openrouter-common.py"
    
    # Run the OpenRouter script
    python3 "$PYTHON_SCRIPTS_DIR/call-openrouter-common.py" "$prompt"
    
    # Deactivate venv
    deactivate
}

# Main execution based on provider selection
case "$provider" in
    "claude")
        run_claude
        ;;
    "openai")
        run_openai
        ;;
    "gemini")
        run_gemini
        ;;
    "groq")
        run_groq
        ;;
    "openrouter")
        run_openrouter
        ;;
    *)
        echo "Invalid provider. Please choose from: claude, openai, gemini, groq, openrouter"
        exit 1
        ;;
esac 