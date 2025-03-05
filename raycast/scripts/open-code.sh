#!/bin/bash
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title VsCode Cursor
# @raycast.mode fullOutput
# Optional parameters:
# @raycast.icon 🖥
# @raycast.argument1 { "type": "text", "placeholder": "Path to open (optional)", "optional": true }
# @raycast.description Opens VS Code Insiders and Cursor in split screen mode
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish

# Check if path was provided
if [ -z "$1" ]; then
  # No path provided, open new windows
  open -n "/Applications/Visual Studio Code - Insiders.app"
  open -n "/Applications/Cursor.app"
else
  # Path provided, open with the path
  open -n "/Applications/Visual Studio Code - Insiders.app" "$1"
  open -n "/Applications/Cursor.app" "$1"
fi

# Give applications time to open
sleep 2

# Use AppleScript to position the windows
osascript <<EOF
tell application "System Events"
  # Get screen dimensions directly without using Finder
  set screenBounds to bounds of first item of (get screens)
  set screenWidth to item 3 of screenBounds
  set screenHeight to item 4 of screenBounds
  
  # Position VS Code Insiders on the left half
  tell process "Visual Studio Code - Insiders"
    set position of window 1 to {0, 0}
    set size of window 1 to {screenWidth / 2, screenHeight}
  end tell
  
  # Position Cursor on the right half
  tell process "Cursor"
    set position of window 1 to {screenWidth / 2, 0}
    set size of window 1 to {screenWidth / 2, screenHeight}
  end tell
end tell
EOF

# Show notification
echo "Opened VS Code Insiders and Cursor in split screen mode"