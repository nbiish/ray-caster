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
