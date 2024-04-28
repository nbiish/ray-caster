#!/bin/bash
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title call-sd3
# @raycast.mode fullOutput
# Optional parameters:
# @raycast.icon 🎨
# @raycast.description Generate an image using the STABLE DIFFUSION API
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish
# @raycast.argument1 { "type": "text", "placeholder": "ratio width:length" }
# @raycast.argument2 { "type": "text", "placeholder": "prompt" }
# @raycast.argument3 { "type": "text", "placeholder": "negative prompt" }

# Check if Python is installed
if ! command -v python3 &>/dev/null; then
    echo "Python 3 is not installed"
    exit 1
fi

# Check if venv exists, if not create it
if [ ! -d "./venv-stable-diffusion" ] ; then
    python3 -m venv venv-stable-diffusion > /dev/null 2>&1
fi

# Activate the venv
source venv-stable-diffusion/bin/activate

Install requirements
if [ -f "reqs/stable-diffusion-requirements.txt" ]; then
    pip install -r reqs/stable-diffusion-requirements.txt > /dev/null 2>&1
else
    echo "reqs/stable-diffusion-requirements.txt not found"
    exit 1
fi

# Run the Python script
python3 python_scripts/call-sd3.py """$1""" """$2""" """$3"""

# Deactivate the venv
deactivate