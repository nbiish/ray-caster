#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Ollama Scripts Cleanup
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🧹
# @raycast.packageName Ollama Tools

# Documentation:
# @raycast.description Manage obsolete Ollama scripts after consolidation
# @raycast.author nbiish
# @raycast.authorURL https://raycast.com/nbiish
# @raycast.argument1 { "type": "dropdown", "placeholder": "action", "data": [{"title": "List Legacy Scripts", "value": "list"}, {"title": "Backup Legacy Scripts", "value": "backup"}, {"title": "Delete Legacy Scripts", "value": "delete"}] }

action="$1"
script_dir="$(dirname "$0")"
backup_dir="${script_dir}/ollama_legacy_backup"
current_date=$(date +"%Y%m%d")

# List of legacy scripts that have been consolidated
legacy_scripts=(
  "ollama-postit.sh"
  "ollama-choose.sh"
  "ollama-update-models.sh"
  "ollama-postit-plus.sh"
  "ollama-uncensored.sh"
  "ollama-llama3-question.sh"
  "ollama-vision.sh"
  "ollama-embedding.sh"
  "ollama-wizardlm2-question.sh"
  "ollama-codegemma-question.sh"
  "ollama-solve-wizardlm2.sh"
  "ollama-solve-codegemma.sh"
  "ollama-solvex2.sh"
  "ollama-summary.sh"
  "ollama-solve-agentic.sh"
  "ollama-terminal.sh"
)

# Function to check if a file exists and handle it
check_file() {
  local file="$1"
  local full_path="${script_dir}/${file}"
  
  if [ -f "$full_path" ]; then
    echo "✅ Found: $file"
    return 0
  else
    echo "❌ Not found: $file"
    return 1
  fi
}

# Function to list all legacy scripts
list_legacy_scripts() {
  echo "Checking for legacy Ollama scripts..."
  echo "---------------------------------"
  
  found_count=0
  not_found_count=0
  
  for script in "${legacy_scripts[@]}"; do
    if check_file "$script"; then
      ((found_count++))
    else
      ((not_found_count++))
    fi
  done
  
  echo "---------------------------------"
  echo "Summary: Found $found_count legacy scripts, $not_found_count not present."
  
  if [ $found_count -gt 0 ]; then
    echo ""
    echo "These scripts have been consolidated into the main ollama.sh script."
    echo "You can backup or delete them using this cleanup tool."
  fi
}

# Function to backup legacy scripts
backup_legacy_scripts() {
  echo "Backing up legacy Ollama scripts..."
  echo "---------------------------------"
  
  # Create backup directory with date
  backup_dir_with_date="${backup_dir}_${current_date}"
  mkdir -p "$backup_dir_with_date"
  
  backup_count=0
  
  for script in "${legacy_scripts[@]}"; do
    local full_path="${script_dir}/${script}"
    
    if [ -f "$full_path" ]; then
      cp "$full_path" "$backup_dir_with_date/"
      echo "✅ Backed up: $script"
      ((backup_count++))
    fi
  done
  
  echo "---------------------------------"
  
  if [ $backup_count -gt 0 ]; then
    echo "Successfully backed up $backup_count scripts to: $backup_dir_with_date"
  else
    echo "No legacy scripts found to backup."
    rmdir "$backup_dir_with_date" 2>/dev/null
  fi
}

# Function to delete legacy scripts
delete_legacy_scripts() {
  echo "Deleting legacy Ollama scripts..."
  echo "---------------------------------"
  echo "WARNING: This will permanently delete legacy scripts."
  echo "Make sure you have a backup or run 'Backup Legacy Scripts' first."
  echo ""
  echo "Continue? (yes/no)"
  read -r confirm
  
  if [ "$confirm" != "yes" ]; then
    echo "Operation cancelled."
    return
  fi
  
  delete_count=0
  
  for script in "${legacy_scripts[@]}"; do
    local full_path="${script_dir}/${script}"
    
    if [ -f "$full_path" ]; then
      rm "$full_path"
      echo "🗑️ Deleted: $script"
      ((delete_count++))
    fi
  done
  
  echo "---------------------------------"
  
  if [ $delete_count -gt 0 ]; then
    echo "Successfully deleted $delete_count legacy scripts."
  else
    echo "No legacy scripts found to delete."
  fi
}

# Main execution based on action
case "$action" in
  "list")
    list_legacy_scripts
    ;;
  "backup")
    backup_legacy_scripts
    ;;
  "delete")
    delete_legacy_scripts
    ;;
  *)
    echo "Invalid action. Please choose from: list, backup, delete"
    exit 1
    ;;
esac


echo ""
echo "Done! You can now use the consolidated ollama.sh script for all operations." 