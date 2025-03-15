#!/bin/bash
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Code Editors
# @raycast.mode fullOutput
# Optional parameters:
# @raycast.icon 🖥
# @raycast.packageName Code Editors
# @raycast.argument1 { "type": "text", "placeholder": "Path to open", "optional": true }
# @raycast.argument2 { "type": "dropdown", "placeholder": "Editor", "data": [{"title": "VS Code Insiders", "value": "vscode"}, {"title": "Cursor", "value": "cursor"}, {"title": "Both", "value": "both"}] }
# @raycast.description Opens selected code editor(s)
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish

# Get parameters
input_path="$1"
editor_choice="$2"

# Normalize path if provided
if [ -n "$input_path" ]; then
  # Convert to absolute path if possible
  normalized_path=$(realpath "$input_path" 2>/dev/null || echo "$input_path")
  echo "Path: $normalized_path"
else
  normalized_path=""
  echo "No path provided"
fi

# Check if editor choice is provided
if [ -z "$editor_choice" ]; then
  echo "Please select an editor from the dropdown menu:"
  echo "- VS Code Insiders"
  echo "- Cursor"
  echo "- Both"
  exit 1
fi

# Function to check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Function to open VS Code Insiders 
open_vscode() {
  local target_path="$1"
  echo "Attempting to open VS Code Insiders..."
  
  # Check if code-insiders command exists
  if ! command_exists code-insiders; then
    echo "⚠️ Warning: code-insiders command not found in PATH."
    echo "Using fallback method to open VS Code Insiders..."
    
    # Fallback to direct app opening
    if [ -z "$target_path" ]; then
      open -n "/Applications/Visual Studio Code - Insiders.app"
      echo "✅ Opened VS Code Insiders using fallback method"
    else
      open -n "/Applications/Visual Studio Code - Insiders.app" --args "$target_path"
      echo "✅ Opened VS Code Insiders with path using fallback method"
    fi
    return
  fi
  
  # Use CLI command if it exists
  if [ -z "$target_path" ]; then
    # Open without a path
    code-insiders -n
    echo "✅ Opened VS Code Insiders"
  else
    # Try opening with the path
    code-insiders -n "$target_path"
    
    if [ $? -eq 0 ]; then
      echo "✅ Opened VS Code Insiders with path: $target_path"
    else
      echo "❌ Failed with CLI. Trying alternative method..."
      
      # Try alternative method with --args
      open -n "/Applications/Visual Studio Code - Insiders.app" --args "$target_path"
      echo "✅ Opened VS Code Insiders with path using alternative method"
    fi
  fi
}

# Function to open Cursor using CLI
open_cursor() {
  local target_path="$1"
  echo "Attempting to open Cursor..."
  
  # Check if cursor command exists
  if ! command_exists cursor; then
    echo "⚠️ Warning: cursor command not found in PATH."
    echo "Using fallback method to open Cursor..."
    
    # Fallback to direct app opening
    if [ -z "$target_path" ]; then
      open -n "/Applications/Cursor.app"
      echo "✅ Opened Cursor using fallback method"
    else
      open -n "/Applications/Cursor.app" --args "$target_path"
      echo "✅ Opened Cursor with path using fallback method"
    fi
    return
  fi
  
  # Use CLI command if it exists
  if [ -z "$target_path" ]; then
    # Open without a path
    cursor
    echo "✅ Opened Cursor"
  else
    # Try opening with the path
    cursor "$target_path"
    
    if [ $? -eq 0 ]; then
      echo "✅ Opened Cursor with path: $target_path"
    else
      echo "❌ Failed with CLI. Trying alternative method..."
      
      # Try alternative method with --args
      open -n "/Applications/Cursor.app" --args "$target_path"
      echo "✅ Opened Cursor with path using alternative method"
    fi
  fi
}

# Open selected editor(s)
case "$editor_choice" in
  "vscode")
    open_vscode "$normalized_path"
    ;;
  "cursor")
    open_cursor "$normalized_path"
    ;;
  "both")
    open_vscode "$normalized_path"
    open_cursor "$normalized_path"
    ;;
  *)
    echo "Invalid selection: '$editor_choice'. Please select one of: vscode, cursor, both"
    exit 1
    ;;
esac