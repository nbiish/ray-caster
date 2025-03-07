#!/usr/bin/env python3

import google.generativeai as genai
import os
from dotenv import load_dotenv
import sys

# Load the .env file
load_dotenv()

# Get model from environment variable or use default
model = os.getenv("GEMINI_MODEL", "gemini-1.5-pro-latest")

# Configure the API
genai.configure(api_key=os.getenv("GOOGLE_AI_STUDIO_KEY"))

# Set up pricing per million tokens (as of Nov 2024)
# Reference: https://ai.google.dev/pricing
pricing = {
    "gemini-1.5-flash-latest": {"input": 0.35, "output": 1.05},
    "gemini-1.5-pro-latest": {"input": 3.50, "output": 10.50},
    "default": {"input": 3.50, "output": 10.50}
}

# Get pricing for the model
model_pricing = pricing.get(model, pricing["default"])

# Get the prompt from the command line arguments
prompt = sys.argv[1]

# Set up the model
generation_config = {
    "temperature": 0.0,
    "top_p": 1,
    "top_k": 32,
    "max_output_tokens": 1024,
}

safety_settings = [
    {
        "category": "HARM_CATEGORY_HARASSMENT",
        "threshold": "BLOCK_NONE",
    },
    {
        "category": "HARM_CATEGORY_HATE_SPEECH",
        "threshold": "BLOCK_NONE",
    },
    {
        "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
        "threshold": "BLOCK_NONE",
    },
    {
        "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
        "threshold": "BLOCK_NONE",
    },
]

# Initialize the model
gemini_model = genai.GenerativeModel(model_name=model,
                              generation_config=generation_config,
                              safety_settings=safety_settings)

# Make the API call
response = gemini_model.generate_content(prompt)

# Calculate estimated tokens (Gemini doesn't provide token counts directly)
# Rough estimate: 1 token ≈ 4 chars for English text
estimated_input_tokens = len(prompt) // 4
estimated_output_tokens = len(response.text) // 4
total_estimated_tokens = estimated_input_tokens + estimated_output_tokens

# Calculate estimated costs
input_cost = estimated_input_tokens * model_pricing["input"] / 1000000
output_cost = estimated_output_tokens * model_pricing["output"] / 1000000
total_cost = input_cost + output_cost

# Get emoji based on model
emoji = "💎"  # Default
if "flash" in model.lower():
    emoji = "⚡"

# Print the formatted output
print('\n' * 3)
print('-' * 81)
print('INPUT:')
print(prompt)
print('-' * 81)
print('MODEL:')
print(model)
print('-' * 81)
print('Response:')
print(f'{emoji}' * 36)
print('-' * 81)
print(response.text)
print('-' * 81)
print(f'{emoji}' * 36)
print('\n' * 3)
print('👍🧿👄🧿💻:')
print('Stats for nerds:')
print('-' * 81)
print(f'ESTIMATED TOKENS IN : {estimated_input_tokens}')
print(f'ESTIMATED TOKENS OUT: {estimated_output_tokens}')
print(f'ESTIMATED TOTAL     : {total_estimated_tokens}')
print()
print(f"{model} estimated costs as of 11-2024:")
print(f'Token-in Cost : ${input_cost:<9.9f} USD')
print(f'Token-out Cost: ${output_cost:<9.9f} USD')
print()
print(f'Total Cost    : ${total_cost:<9.9f} USD') 