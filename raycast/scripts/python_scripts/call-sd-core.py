#!/usr/bin/env python3

import os
from dotenv import load_dotenv
import sys
import requests
import datetime

# Load the .env file
load_dotenv()

api_key = os.getenv("STABILITY_API_KEY")

ratio_list = ['16:9', '1:1', '21:9', '2:3', '3:2', '4:5', '5:4', '9:16', '9:21']

user_aspect_ratio = sys.argv[1] if sys.argv[1] in ratio_list else '1:1'
user_prompt = sys.argv[2]
user_negative_prompt = sys.argv[3]


response = requests.post(
    f"https://api.stability.ai/v2beta/stable-image/generate/core",
     headers={
        "authorization": f"{api_key}",
        "accept": "image/*"
    },
    files={"none": ''},
    data={
        "prompt": f"{user_prompt}",
        "negative_prompt": f"{user_negative_prompt}",
        "aspect_ratio": f"{user_aspect_ratio}",
        "output_format": "jpeg",
    },
)

output_file = "photo-bin/sd3/sd3-generation.jpeg"

if response.status_code == 200:
    if os.path.exists(output_file):
        # Generate a unique filename using the current date and time
        timestamp = datetime.datetime.now().strftime("year:%Y_month:%m_day:%d_hr:%H_min:%M_sec:%S")
        filename = f"sd-core-generation_{timestamp}.jpeg"
        output_file = os.path.join("photo-bin/sd-core", filename)
    
    with open(output_file, 'wb') as file:
        file.write(response.content)

    # After saving the image file
    os.system(f"osascript -e 'set the clipboard to (read (POSIX file \"{output_file}\") as JPEG picture)'")
else:
    raise Exception(str(response.json()))

