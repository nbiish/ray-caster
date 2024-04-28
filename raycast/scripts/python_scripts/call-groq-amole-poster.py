#!/usr/bin/env python3

#

### SETUP AND VARIABLES #############################
from groq import Groq
from dotenv import load_dotenv
import sys
import os

load_dotenv()
api_key=os.getenv("GROQ_API_KEY")


prompt = sys.argv[1]
groq_model = "llama3-70b-8192"
system_prompt = """YOU ARE A WORLD RENOUN LOGIC AND PROBLEM SOLVING EXPERT.
BE CONCISE AND RESPOND IN PLAIN ENGLISH OR JUST CODE IF CODE IS PROVIDED."""
## END OF SETUP AND VARIABLES ########################

#

### REQUEST ########################################
client = Groq()
completion = client.chat.completions.create(
    model=f"{groq_model}",
    messages=[
        {
            "role": "system",
            "content": f"{system_prompt}"
        },
        {
            "role": "user",
            "content": f"{prompt}"
        }
    ],
    temperature=0.3,
    max_tokens=1024,
    top_p=1,
    stream=False,
    stop=None,
)
## END OF REQUEST ####################################

#

### RESPONSE ########################################
response = completion.choices[0].message.content
## END OF RESPONSE ####################################

#

### TOKEN VARIABLS ##################################

# TESTING
# for i in completion:
#     print(f"{i}\n")

# IN AND OUT TOKENS
in_tokens = completion.usage.prompt_tokens
out_tokens = completion.usage.completion_tokens
total_tokens = completion.usage.total_tokens
# TIME STATS
completion_time = completion.usage.completion_time
prompt_time = completion.usage.prompt_time
total_time = completion.usage.total_time

## END OF TOKEN VARIABLES ############################

#

### OUTPUT AND PRINT ###############################
print('\n' * 3)
print('-' * 81)
print('INPUT:')
print(sys.argv[1])
print('-' * 81)
print('MODEL:')
print(groq_model)
print('-' * 81)
print('Response:')
print('🍓' * 36)
print('-' * 81)
print(response)
print('-' * 81)
print('🫐' * 36)
print('\n' * 3)
## END OF OUTPUT AND PRINT ###########################

#

### TOKENS AND COST #################################
print('👍🧿👄🧿💻')
print('Stats for nerds:')
print('-' * 81 + '\n')
print(f'MODEL:\n{groq_model}\n')
print('TOKEN STATS:')
print(f'TOKENS IN     : {in_tokens}')
print(f'TOKENS OUT    : {out_tokens}')
print(f'TOTAL TOKENS  : {total_tokens}')
print()
# TIME SECTION
print('TIME STATS:')
print(f'Prompt Time      : {prompt_time}')
print(f'Completion Time  : {completion_time}')
print(f'Total Time       : {total_time:.5f}')
print('⚡️😱😳')
## END OF TOKENS AND COST #############################