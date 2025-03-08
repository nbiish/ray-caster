#!/bin/bash
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Code Editor
# @raycast.mode fullOutput
# Optional parameters:
# @raycast.icon 🖥
# @raycast.argument1 { "type": "dropdown", "placeholder": "Editor Choice", "data": [{"title": "Both", "value": "both"}, {"title": "VS Code Insiders", "value": "vscode"}, {"title": "Cursor", "value": "cursor"}] }
# @raycast.argument2 { "type": "text", "placeholder": "Path to open (optional)", "optional": true }
# @raycast.description Opens VS Code, Cursor, or both with an optional path
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish

# Get editor choice from argument
EDITOR_CHOICE=$1
# Get path from argument (optional)
PATH_ARG=$2

# Function to check if command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to open editor using CLI command
open_editor() {
  local cmd=$1
  local editor_name=$2
  
  if ! command_exists "$cmd"; then
    echo "Error: $editor_name CLI command '$cmd' not found. Make sure it's installed and in your PATH."
    return 1
  fi
  
  echo "Opening $editor_name..."
  
  if [ -z "$PATH_ARG" ]; then
    # No path provided, open new window
    $cmd --new-window
  else
    # Path provided, open with the path
    $cmd --new-window "$PATH_ARG"
  fi
  
  if [ $? -eq 0 ]; then
    echo "Successfully opened $editor_name"
    return 0
  else
    echo "Failed to open $editor_name"
    return 1
  fi
}

# Open selected editor(s)
if [ "$EDITOR_CHOICE" = "both" ]; then
  echo "Opening both editors..."
  
  vscode_success=0
  cursor_success=0
  
  open_editor "code" "VS Code" || vscode_success=1
  open_editor "cursor" "Cursor" || cursor_success=1
  
  if [ $vscode_success -eq 0 ] && [ $cursor_success -eq 0 ]; then
    echo "Successfully opened both editors"
  elif [ $vscode_success -eq 0 ]; then
    echo "Only opened VS Code successfully"
  elif [ $cursor_success -eq 0 ]; then
    echo "Only opened Cursor successfully"
  else
    echo "Failed to open both editors"
  fi

elif [ "$EDITOR_CHOICE" = "vscode" ]; then
  open_editor "code" "VS Code"
  
elif [ "$EDITOR_CHOICE" = "cursor" ]; then
  open_editor "cursor" "Cursor"
fi