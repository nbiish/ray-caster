#!/usr/bin/env python3

import anthropic
import os
from dotenv import load_dotenv
import sys

# Load the .env file
load_dotenv()

client = anthropic.Anthropic(
    # Get the API key from the .env file
    api_key=os.getenv("ANTHROPIC_API_KEY"),
)

prompt = sys.argv[1]

message = client.messages.create(
    model="claude-3-sonnet-20240229",
    max_tokens=1000,
    temperature=0.0,
    system="YOU ARE A WORLD RENOUN EXPERT IN LOGIC AND PROBLEM SOLVING. THERE WILL BE XML TAGS AS <user_input></user_input> THAT FOLLOW THIS SYSTEM PROMPT. RESPOND IN A CONCISE MANNER AND DO NOT BE VERBOSE. THINKING STEP-BY-STEP AS THE FAMOUS LOGICIAN AND PROBLEM SOLVER YOU ARE RESPOND TO THE FOLLOWING CONTENT WITHIN THE DESCRIBED XML TAGS. DO NOT RESPOND WITH XML TAGS:",
    messages=[
        {"role": "user", "content": f"<user_input>{prompt}</user_input>"}
    ]
)

# Calculate the costs
input_cost = message.usage.input_tokens * 3.00 / 1000000
output_cost = message.usage.output_tokens * 15.00 / 1000000
total_cost = input_cost + output_cost

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
print('🍓' * 36)
print('-' * 81)
for item in message.content:
    print(item.text)
print('-' * 81)
print('🫐' * 36)
print('\n' * 3)
print('👍🧿👄🧿💻:')
print('Stats for nerds:')
print('-' * 81)
print(f'Token {message.usage}')
print()
print("claude-3-sonnet costs as of 4-12-24:")
print(f'Token-in Cost : ${input_cost:<9.9f} USD')
print(f'Token-out Cost: ${output_cost:<9.9f} USD')
print()
print(f'Total Cost    : ${total_cost:<9.9f} USD')
