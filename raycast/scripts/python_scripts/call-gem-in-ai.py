#!/usr/bin/env python3



import sys
import os   
from dotenv import load_dotenv
from langchain_google_genai import GoogleGenerativeAI, HarmBlockThreshold, HarmCategory

load_dotenv()
api_key = os.getenv("GOOGLE_AI_STUDIO_KEY")

# #FOR MAKING A SYSTEM MESSAGE
# from langchain_core.messages import HumanMessage, SystemMessage

# model = ChatGoogleGenerativeAI(model="gemini-pro", convert_system_message_to_human=True)
# model(
#     [
#         SystemMessage(content="Answer only yes or no."),
#         HumanMessage(content="Is apple a fruit?"),
#     ]
# )

user_prompt = sys.argv[1]

llm = GoogleGenerativeAI(
    model="gemini-pro",
    google_api_key=api_key,
    safety_settings={
        HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT: HarmBlockThreshold.BLOCK_NONE,
    },
)

print(
    llm.invoke(
        user_prompt,
    )
)


llm = GoogleGenerativeAI(
    model="gemini-pro",
    google_api_key=api_key,
    safety_settings={
        HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT: HarmBlockThreshold.BLOCK_NONE,
    },
)

response = llm.invoke(user_prompt)

# Print the formatted output
print('\n' * 3)
print('-' * 81)
print('INPUT:')
print(user_prompt)
print('-' * 81)
print('MODEL:')
print("gemini-pro")
print('-' * 81)
print('Response:')
print('🍓' * 36)
print('-' * 81)
print(response)
print('-' * 81)
print('🫐' * 36)