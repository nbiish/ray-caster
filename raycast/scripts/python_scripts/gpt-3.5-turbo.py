#!/usr/bin/env python3

from openai import OpenAI
import os
from dotenv import load_dotenv
import sys

# Load the .env file
load_dotenv()

client = OpenAI()

# Get the API key from the .env file
api_key=os.getenv("OPENAI_API_KEY")

# Set the prompt variable
prompt = sys.argv[1]

response = client.chat.completions.create(
  model="gpt-3.5-turbo",
  messages=[
    {
      "role": "system",
      "content": "YOU ARE A WORLD RENOUN LOGIC AND PROBLEM SOLVING EXPERT. BE CONCISE AND RESPOND IN PLAIN ENGLISH OR JUST CODE IF CODE IS PROVIDED."
    },
    {
      "role": "user",
      "content": f"{prompt}"
    }
  ],
  temperature=0.3,
  max_tokens=1000,
  top_p=1,
  frequency_penalty=0,
  presence_penalty=0
)

#Calculate the costs
input_cost = response.usage.prompt_tokens * 0.50 / 1000000
output_cost = response.usage.completion_tokens * 1.50 / 1000000
in_tokens = response.usage.prompt_tokens
out_tokens = response.usage.completion_tokens
total_tokens = response.usage.total_tokens
total_cost = input_cost + output_cost

# Print the formatted output
print('\n' * 3)
print('-' * 81)
print('INPUT:')
print(sys.argv[1])
print('-' * 81)
print('MODEL:')
print(response.model)
print('-' * 81)
print('Response:')
print('🍓' * 36)
print('-' * 81)
print(response.choices[0].message.content)
print('-' * 81)
print('🫐' * 36)
print('\n' * 3)
print('👍🧿👄🧿💻:')
print('Stats for nerds:')
print('-' * 81)
print(f'TOKENS IN     : {in_tokens}')
print(f'TOKENS OUT    : {out_tokens}')
print(f'TOTAL TOKENS  : {total_tokens}')
print()
print("gpt-3.5-turbo costs as of 4-19-24:")
print(f'Token-in Cost : ${input_cost:<9.9f} USD')
print(f'Token-out Cost: ${output_cost:<9.9f} USD')
print(f'Total Tokens  : {total_tokens}')
print()
print(f'Total Cost    : ${total_cost:<9.9f} USD')
