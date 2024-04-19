#!/bin/bash

# Loop over all .sh files in the current directory
for file in *.sh
do
    # Check if the file does not contain 'ollama' or 'open'
    if ! grep -q 'ollama\|open-\|call-\' "$file"
    then
        # Prepend 'call-' to the filename
        mv -- "$file" "call-$file"
    fi
done