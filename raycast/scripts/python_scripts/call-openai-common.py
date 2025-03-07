#!/usr/bin/env python3

from openai import OpenAI
import os
from dotenv import load_dotenv
import sys

# Load the .env file
load_dotenv()

# Get model from environment variable or use default
model = os.getenv("GPT_MODEL", "gpt-3.5-turbo-0125")

# Set up pricing per million tokens (as of Nov 2024)
# Reference: https://openai.com/api/pricing
pricing = {
    "gpt-4o-2024-11-20": {"input": 5.00, "output": 15.00},
    "gpt-4o-mini-2024-07-18": {"input": 0.15, "output": 0.60},
    "gpt-4-turbo-2024-04-09": {"input": 10.00, "output": 30.00},
    "gpt-3.5-turbo-0125": {"input": 0.50, "output": 1.50},
    "default": {"input": 5.00, "output": 15.00}  # Default to gpt-4o pricing
}

# Get pricing for the model
model_pricing = pricing.get(model, pricing["default"])

client = OpenAI(
    # Get the API key from the .env file
    api_key=os.getenv("OPENAI_API_KEY"),
)

# Get the prompt from the command line arguments
prompt = sys.argv[1]

# Get system prompt from environment or use default
system_prompt = os.getenv("GPT_SYSTEM_PROMPT", 
    "You are a helpful assistant that provides accurate and concise responses. "
    "Think step-by-step and be logical in your reasoning."
)

# Set max tokens based on model or use default
max_tokens = 1000
if "gpt-4" in model.lower():
    max_tokens = 1500
if "mini" in model.lower():
    max_tokens = 800

# Make the API call
response = client.chat.completions.create(
    model=model,
    messages=[
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": prompt}
    ],
    max_tokens=max_tokens,
    temperature=0.0
)

# Calculate the costs
input_tokens = response.usage.prompt_tokens
output_tokens = response.usage.completion_tokens
total_tokens = input_tokens + output_tokens
input_cost = input_tokens * model_pricing["input"] / 1000000
output_cost = output_tokens * model_pricing["output"] / 1000000
total_cost = input_cost + output_cost

# Get emoji based on model
emoji = "🤖"  # Default
if "gpt-4o" in model.lower():
    emoji = "🔍"
if "mini" in model.lower():
    emoji = "🔎"

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
print(response.choices[0].message.content)
print('-' * 81)
print(f'{emoji}' * 36)
print('\n' * 3)
print('👍🧿👄🧿💻:')
print('Stats for nerds:')
print('-' * 81)
print(f'TOKENS IN     : {input_tokens}')
print(f'TOKENS OUT    : {output_tokens}')
print(f'TOTAL TOKENS  : {total_tokens}')
print()
print(f"{model} costs as of 11-2024:")
print(f'Token-in Cost : ${input_cost:<9.9f} USD')
print(f'Token-out Cost: ${output_cost:<9.9f} USD')
print()
print(f'Total Cost    : ${total_cost:<9.9f} USD') 