#!/usr/bin/env python3

from groq import Groq
import os
from dotenv import load_dotenv
import sys
import time

# Load the .env file
load_dotenv()

# Get model from environment variable or use default
model = os.getenv("GROQ_MODEL", "qwen-qwq-32b")

# Set up pricing per million tokens (as of Nov 2024)
# Reference: https://console.groq.com/docs/pricing
pricing = {
    "qwen-qwq-32b": {"input": 0.8, "output": 0.8},
    "qwen-2.5-coder-32b": {"input": 0.79, "output": 0.79},
    "deepseek-r1-distill-llama-70b-specdec": {"input": 0.75, "output": 0.99},
    "default": {"input": 0.7, "output": 1.0}
}

# Get pricing for the model
model_pricing = pricing.get(model, pricing["default"])

# Get API key
api_key = os.getenv("GROQ_API_KEY")
if not api_key:
    print("Error: GROQ_API_KEY not found in .env file")
    sys.exit(1)

# Get the prompt from the command line arguments
prompt = sys.argv[1]

# Set maximum tokens based on model
max_tokens = 1024
if "specdec" in model:
    # For speculative decoding models, we may want to utilize the faster response capabilities
    # Speculative decoding uses a smaller draft model to generate tokens faster
    print(f"Using speculative decoding model: {model}")
    print("This model has ~6x faster generation speed compared to standard models")

# Set default parameters
temperature = 0.6
top_p = 1.0

# Set specific parameters based on model
if "qwen-qwq-32b" in model.lower():
    system_prompt = "You are a helpful assistant that specializes in reasoning tasks."
    temperature = 0.6
    max_tokens = 4096
    top_p = 0.95
elif "deepseek" in model.lower() or "specdec" in model.lower():
    system_prompt = "You are an advanced reasoning assistant that thinks step-by-step before answering."
    temperature = 0.6
    max_tokens = 1024
elif "coder" in model.lower():
    system_prompt = "You are a coding expert that provides clean, efficient, and well-documented code."
    temperature = 0.5
    max_tokens = 2048
else:
    system_prompt = os.getenv("GROQ_SYSTEM_PROMPT", 
        "You are a helpful assistant that provides accurate and concise responses. "
        "Think step-by-step and be logical in your reasoning."
    )

# Always use streaming for better user experience
use_streaming = True

# Print start of output format
print('\n' * 3)
print('-' * 81)
print('INPUT:')
print(prompt)
print('-' * 81)
print('MODEL:')
print(model)
print('-' * 81)
print('Response:')

# Get emoji based on model
emoji = "⚡"  # Default
if "qwq" in model.lower():
    emoji = "🧮"
elif "coder" in model.lower():
    emoji = "💻"
elif "deepseek" in model.lower() or "specdec" in model.lower():
    emoji = "🔍"

print(f'{emoji}' * 36)
print('-' * 81)

try:
    # Initialize Groq client
    client = Groq(
        api_key=api_key
    )
    
    # Make the API call
    completion = client.chat.completions.create(
        model=model,
        messages=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": prompt}
        ],
        temperature=temperature,
        max_tokens=max_tokens,  # Using the correct parameter name
        top_p=top_p,
        stream=True
    )
    
    # Collect the full content for token counting/pricing
    full_content = ""
    
    # Process the streaming response
    for chunk in completion:
        if chunk.choices and chunk.choices[0].delta.content:
            content_chunk = chunk.choices[0].delta.content or ""
            print(content_chunk, end="", flush=True)
            full_content += content_chunk
    
    print()  # Add a newline after streaming is complete
    
    # Since we're streaming, we don't get usage information directly
    # We can use a rough estimate (character count / 4) for tokens
    estimated_output_tokens = len(full_content) // 4
    estimated_input_tokens = len(prompt) // 4
    total_tokens = estimated_input_tokens + estimated_output_tokens
    input_cost = estimated_input_tokens * model_pricing["input"] / 1000000
    output_cost = estimated_output_tokens * model_pricing["output"] / 1000000
    total_cost = input_cost + output_cost
    
    print('-' * 81)
    print(f'{emoji}' * 36)
    print('\n' * 3)
    print('👍🧿👄🧿💻:')
    print('Stats for nerds (ESTIMATED):')
    print('-' * 81)
    print(f'TOKENS IN (est): {estimated_input_tokens}')
    print(f'TOKENS OUT (est): {estimated_output_tokens}')
    print(f'TOTAL TOKENS (est): {total_tokens}')
    print()
    print(f"{model} costs as of 11-2024:")
    print(f'Token-in Cost : ${input_cost:<9.9f} USD')
    print(f'Token-out Cost: ${output_cost:<9.9f} USD')
    print()
    print(f'Total Cost    : ${total_cost:<9.9f} USD')
    
except Exception as e:
    print(f"Error: {str(e)}")
    print('-' * 81)
    print(f'{emoji}' * 36)
    print('\n' * 3)
    print('ERROR OCCURRED:')
    print('-' * 81)
    print(f"Model: {model}")
    print(f"Error message: {str(e)}")
    print()
    print("Available models on Groq:")
    try:
        models = client.models.list()
        model_ids = [m.id for m in models]
        print("\n".join(model_ids))
    except Exception as list_error:
        print(f"Could not list models: {str(list_error)}") 