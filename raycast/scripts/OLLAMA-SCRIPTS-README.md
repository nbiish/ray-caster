# Ollama Raycast Scripts

A collection of Raycast scripts for interacting with Ollama locally installed models.

## Consolidated Approach

We've consolidated multiple Ollama scripts into a single powerful script that handles all operations. This approach:

- Reduces maintenance overhead
- Provides a consistent interface for all Ollama operations
- Simplifies usage with a clear operation selection dropdown
- Automatically updates with your installed models
- Handles specialized operations like vision and embeddings

### ollama.sh - All-in-One Ollama Tool

An all-in-one script for various Ollama operations:

- **Chat**: Simple conversation with any Ollama model
- **Post**: Generate social media posts with hashtags and emojis
- **Question**: Get concise answers to questions
- **Vision**: Analyze images using vision-capable models
- **Embedding**: Generate vector embeddings from text
- **List**: Show all installed Ollama models
- **Update**: Update all installed Ollama models

## Usage Examples

### Basic Chat
```
ollama chat "phi4" "Explain quantum computing in simple terms"
```

### Social Media Post Generation 
```
ollama post "phi4-mini" "the importance of AI safety"
```

### Image Analysis
```
ollama vision "granite-vision" "/path/to/image.jpg" "What can you see in this image?"
```

### Text Embeddings
```
ollama embedding "granite-embedding" "This is text to convert to vectors"
```

## Supported Models

The script supports all your currently installed Ollama models:

- phi4-mini
- phi4
- granite (and variants)
- deepseek (and variants)
- And all other Ollama compatible models

## Prerequisites

- Ollama installed and functioning
- Models downloaded via `ollama pull [model-name]`
- For embeddings: jq installed (`brew install jq`)

## Legacy Scripts (Now Obsolete)

The following scripts have been consolidated into the main `ollama.sh` script:

- ollama-postit.sh
- ollama-choose.sh
- ollama-update-models.sh
- ollama-postit-plus.sh
- ollama-uncensored.sh
- ollama-vision.sh
- ollama-embedding.sh
- ollama-llama3-question.sh

## Why Consolidation?

1. **Easier Maintenance**: When Ollama updates or new models are released, you only need to update one script.
2. **Consistent Interface**: All operations follow the same pattern with dropdown selections.
3. **Reduced Clutter**: Fewer scripts in your Raycast interface means easier navigation.
4. **Model Validation**: Automatic checks ensure you use the right models for specialized tasks. 