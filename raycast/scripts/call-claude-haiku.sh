#!/bin/bash
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title call-claude-haiku
# @raycast.mode fullOutput
# Optional parameters:
# @raycast.icon 🌸
# @raycast.description Generate a haiku response using the ANTHROPIC API
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish
# @raycast.argument1 { "type": "text", "placeholder": "question or input" }

# Check if Python is installed
if ! command -v python3 &>/dev/null; then
    echo "Python 3 is not installed"
    exit 1
fi

# Check if venv exists, if not create it
if [ ! -d "./venv-claude" ] ; then
    python3 -m venv venv-claude > /dev/null 2>&1
fi

# Activate the venv
source venv-claude/bin/activate

# Install requirements
if [ -f "reqs/claude-requirements.txt" ]; then
    pip install -r reqs/claude-requirements.txt > /dev/null 2>&1
else
    echo "reqs/claude-requirements.txt not found"
    exit 1
fi

# Run the Python script
python3 python_scripts/call-claude-haiku.py "$1"

# Deactivate the venv
deactivate