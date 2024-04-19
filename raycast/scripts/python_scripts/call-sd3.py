#!/usr/bin/env python3

import os
from dotenv import load_dotenv
import sys
import requests
import datetime

# Load the .env file
load_dotenv()

api_key = os.getenv("STABILITY_API_KEY")
user_prompt = sys.argv[1]

response = requests.post(
    f"https://api.stability.ai/v2beta/stable-image/generate/sd3",
    headers={
        "authorization": f"{api_key}",
        "accept": "image/*"
    },
    files={"none": ''},
    data={
        "prompt": f"{user_prompt}",
        "output_format": "jpeg",
    },
)

output_file = "photo-bin/sd3/sd3-generation.jpeg"

if response.status_code == 200:
    if os.path.exists(output_file):
        # Generate a unique filename using the current date and time
        timestamp = datetime.datetime.now().strftime("year:%Y_month:%m_day:%d_hr:%H_min:%M_sec:%S")
        filename = f"sd3-generation_{timestamp}.jpeg"
        output_file = os.path.join("photo-bin/sd3", filename)
    
    with open(output_file, 'wb') as file:
        file.write(response.content)

    # After saving the image file
    os.system(f"osascript -e 'set the clipboard to (read (POSIX file \"{output_file}\") as JPEG picture)'")
else:
    raise Exception(str(response.json()))

print(output_file)
