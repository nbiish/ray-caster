#!/usr/bin/env python3

import anthropic
import os
from dotenv import load_dotenv
import sys

# Load the .env file
load_dotenv()

# Get model from environment variable or use default
model = os.getenv("CLAUDE_MODEL", "claude-3-sonnet-20240229")

# Get model tier for pricing (determines the cost calculation)
model_tier = "sonnet"  # Default
if "opus" in model.lower():
    model_tier = "opus"
elif "haiku" in model.lower():
    model_tier = "haiku"
elif "sonnet" in model.lower():
    model_tier = "sonnet"

# Set up pricing per million tokens (as of Nov 2024)
# Reference: https://www.anthropic.com/api
pricing = {
    "opus": {"input": 15.00, "output": 75.00},
    "sonnet": {"input": 3.00, "output": 15.00},
    "haiku": {"input": 0.25, "output": 1.25},
}

client = anthropic.Anthropic(
    # Get the API key from the .env file
    api_key=os.getenv("ANTHROPIC_API_KEY"),
)

# Get the prompt from the command line arguments
prompt = sys.argv[1]

# Get system prompt from environment or use default
system_prompt = os.getenv("CLAUDE_SYSTEM_PROMPT", 
    "YOU ARE A WORLD RENOUN EXPERT IN LOGIC AND PROBLEM SOLVING. "
    "THERE WILL BE XML TAGS <user_input></user_input> THAT FOLLOW THIS SYSTEM PROMPT. "
    "RESPOND IN A CONCISE MANNER AND DO NOT BE VERBOSE. "
    "THINKING STEP-BY-STEP AS THE FAMOUS LOGICIAN AND PROBLEM SOLVER YOU ARE, "
    "RESPOND TO THE FOLLOWING. DO NOT USE XML TAGS IN YOUR RESPONSE:"
)

# Set max tokens based on model or use default
max_tokens = 1000
if "haiku" in model.lower():
    max_tokens = 800
elif "opus" in model.lower():
    max_tokens = 1500

# Make the API call
message = client.messages.create(
    model=model,
    max_tokens=max_tokens,
    temperature=0.0,
    system=system_prompt,
    messages=[
        {"role": "user", "content": f"<user_input>{prompt}</user_input>"}
    ]
)

# Calculate the costs
input_cost = message.usage.input_tokens * pricing[model_tier]["input"] / 1000000
output_cost = message.usage.output_tokens * pricing[model_tier]["output"] / 1000000
in_tokens = message.usage.input_tokens
out_tokens = message.usage.output_tokens
total_tokens = message.usage.input_tokens + message.usage.output_tokens
total_cost = input_cost + output_cost

# Get emoji based on model
emoji = "🎭"  # Default sonnet
if "opus" in model.lower():
    emoji = "🔮"
elif "haiku" in model.lower():
    emoji = "🌸"
elif "3.5" in model:
    emoji = "🌟"
elif "3.7" in model:
    emoji = "✨"

# Print the formatted output
print('\n' * 3)
print('-' * 81)
print('INPUT:')
print(sys.argv[1])
print('-' * 81)
print('MODEL:')
print(message.model)
print('-' * 81)
print('Response:')
print(f'{emoji}' * 36)
print('-' * 81)
for item in message.content:
    print(item.text)
print('-' * 81)
print(f'{emoji}' * 36)
print('\n' * 3)
print('👍🧿👄🧿💻:')
print('Stats for nerds:')
print('-' * 81)
print(f'TOKENS IN     : {in_tokens}')
print(f'TOKENS OUT    : {out_tokens}')
print(f'TOTAL TOKENS  : {total_tokens}')
print()
print(f"{model} costs as of 11-2024:")
print(f'Token-in Cost : ${input_cost:<9.9f} USD')
print(f'Token-out Cost: ${output_cost:<9.9f} USD')
print()
print(f'Total Cost    : ${total_cost:<9.9f} USD') 