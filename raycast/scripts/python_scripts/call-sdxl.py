#!/usr/bin/env python3

import os
from dotenv import load_dotenv
import sys
import requests
import datetime
import base64
import subprocess
import re  # Import regex module for sanitization

# Load the .env file
load_dotenv()

api_key = os.getenv("STABILITY_API_KEY")

ratio_dict = {
    "1:1": (1024, 1024),
    "16:9": (1152, 896),
    "9:16": (896, 1152),
    "11:8": (1216, 832),
    "16:9-large": (1344, 768),
    "9:16-large": (768, 1344),
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

# Create a safe base path for storing images
base_path = os.path.abspath("photo-bin/sdxl")
# Ensure the directory exists
os.makedirs(base_path, exist_ok=True)

# Function to sanitize filenames
def sanitize_filename(filename):
    # Remove any potentially dangerous characters
    # Keep only alphanumeric, dash, underscore, and period
    sanitized = re.sub(r'[^\w\-\.]', '_', filename)
    # Ensure no directory traversal is possible
    sanitized = os.path.basename(sanitized)
    return sanitized

for i, image in enumerate(data["artifacts"]):
    # Safely construct the filename with numeric index and sanitize it
    safe_filename = sanitize_filename(f"v1_txt2img_{i}.png")
    if response.status_code == 200:
        if os.path.exists(os.path.join(base_path, safe_filename)):
            # Generate a unique filename using the current date and time
            timestamp = datetime.datetime.now().strftime("year%Y_month%m_day%d_hr%H_min%M_sec%S")
            safe_filename = sanitize_filename(f"sdxl-generation_{timestamp}.jpeg")
    
    # Safely join paths
    output_file = os.path.join(base_path, safe_filename)
    
    # Validate the final path is within the expected directory
    if not os.path.abspath(output_file).startswith(base_path):
        raise ValueError(f"Invalid path detected: {output_file}")
        
    with open(output_file, "wb") as f:
        f.write(base64.b64decode(image["base64"]))
    # After saving the image file
    subprocess.run([
        "osascript", 
        "-e", 
        f'set the clipboard to (read (POSIX file "{os.path.abspath(output_file)}") as JPEG picture)'
    ], check=True)
