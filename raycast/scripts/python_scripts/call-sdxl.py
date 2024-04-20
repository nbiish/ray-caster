#!/usr/bin/env python3

import os
from dotenv import load_dotenv
import sys
import requests
import datetime
import base64

# Load the .env file
load_dotenv()

api_key = os.getenv("STABILITY_API_KEY")

ratio_dict = {
    "1:1": (1024, 1024),
    "16:9": (1152, 896),
    "9:16": (896, 1152),
    "11:8": (1216, 832),
    "16:9": (1344, 768),
    "9:16": (768, 1344),
    "24:10": (1536, 640),
    "10:24": (640, 1536)
}

user_aspect_ratio = ratio_dict.get(sys.argv[1], (1024, 1024))
height, width = user_aspect_ratio
user_prompt = sys.argv[2]


engine_id = "stable-diffusion-xl-1024-v1-0"
api_host = os.getenv('API_HOST', 'https://api.stability.ai')
api_key = os.getenv("STABILITY_API_KEY")

if api_key is None:
    raise Exception("Missing Stability API key.")

response = requests.post(
    f"{api_host}/v1/generation/{engine_id}/text-to-image",
    headers={
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": f"Bearer {api_key}"
    },
    json={
        "text_prompts": [
            {
                "text": f"{user_prompt}"
            }
        ],
        "cfg_scale": 7,
        "height": height,
        "width": width,
        "samples": 1,
        "steps": 30,
    },
)

if response.status_code != 200:
    raise Exception("Non-200 response: " + str(response.text))

data = response.json()

for i, image in enumerate(data["artifacts"]):
    output_file = f"photo-bin/sdxl/v1_txt2img_{i}.png"
    if response.status_code == 200:
        if os.path.exists(output_file):
            # Generate a unique filename using the current date and time
            timestamp = datetime.datetime.now().strftime("year:%Y_month:%m_day:%d_hr:%H_min:%M_sec:%S")
            filename = f"sdxl-generation_{timestamp}.jpeg"
            output_file = os.path.join("photo-bin/sdxl", filename)
    with open(output_file, "wb") as f:
        f.write(base64.b64decode(image["base64"]))
    # After saving the image file
    os.system(f"osascript -e 'set the clipboard to (read (POSIX file \"{os.path.abspath(output_file)}\") as JPEG picture)'")
