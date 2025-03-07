# Ollama Raycast Scripts

A collection of Raycast scripts for interacting with Ollama locally installed models.

## Consolidated Approach

We've consolidated multiple Ollama scripts into a single powerful script that handles all operations. This approach:

- Reduces maintenance overhead
- Provides a consistent interface for all Ollama operations
- Simplifies usage with a clear operation selection dropdown
- Automatically updates with your installed models
- Handles specialized operations like image analysis and embeddings

### ollama.sh - All-in-One Ollama Tool

An all-in-one script for various Ollama operations:

- **Prompt**: Simple one-shot interaction with any model
- **Question**: Specialized expert problem-solving with model-specific prompting
- **Solve**: Process clipboard content with model-specific prompting
- **SolveX2**: Process clipboard content with two models (phi4 and deepseek) for comparison
- **Postit**: Create a social media post with hashtags and emojis
- **Terminal**: Simulate terminal output for code in clipboard
- **Summary**: Summarize text from clipboard
- **Image**: Analyze images using any model (best with vision models)
- **Embedding**: Generate vector embeddings from text (best with embedding models)
- **List**: Show all installed Ollama models
- **Update**: Update all installed Ollama models

## Flexible Model Usage

Any model can be used for any operation! This means:
- Vision models can handle text prompts
- Text models can attempt to process images
- Any model can generate embeddings

The script will provide appropriate warnings when you're using a model outside its specialized function but will still attempt to process your request.

## Special Prompting

You can use special flags at the beginning of your prompt to set specific system prompts:

- `--post` prefix will use the social media post prompt style
- `--question` prefix will use the expert problem-solving prompt style

Example: `--post This is my topic for a social media post`

## Usage Examples

### Basic Prompt
```
ollama prompt "phi4" "Explain quantum computing in simple terms"
```

### Expert Question
```
ollama question "phi4" "How do I implement quicksort in Python?"
```

### Solve from Clipboard
```
# Copy content to clipboard first, then:
ollama solve "deepseek"
```

### Solve with Two Models
```
# Copy content to clipboard first, then:
ollama solvex2
```

### Social Media Post
```
ollama postit "phi4-mini" "the importance of AI safety"
```

### Terminal Simulation
```
# Copy code to clipboard first, then:
ollama terminal "phi4"
```

### Summarize Text
```
# Copy text to clipboard first, then:
ollama summary "phi4"
```

### Image Analysis
```
ollama image "granite-vision" "/path/to/image.jpg"
```

### Text Embeddings
```
ollama embedding "granite-embedding" "This is text to convert to vectors"
```

## Supported Models

The script supports all your currently installed Ollama models:

- phi4, phi4-mini
- dolphin3
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
- ollama-postit-plus.sh
- ollama-choose.sh
- ollama-update-models.sh
- ollama-uncensored.sh
- ollama-vision.sh
- ollama-embedding.sh
- ollama-llama3-question.sh
- ollama-wizardlm2-question.sh
- ollama-codegemma-question.sh
- ollama-solve-wizardlm2.sh
- ollama-solve-codegemma.sh
- ollama-solve-agentic.sh
- ollama-solvex2.sh
- ollama-summary.sh
- ollama-terminal.sh
- ollama-unified-question.sh
- ollama-unified-solve.sh

## Why Consolidation?

1. **Easier Maintenance**: When Ollama updates or new models are released, you only need to update one script.
2. **Consistent Interface**: All operations follow the same pattern with dropdown selections.
3. **Reduced Clutter**: Fewer scripts in your Raycast interface means easier navigation.
4. **Model Flexibility**: Use any model for any operation while still receiving appropriate guidance.

# @raycast.argument1 { "type": "dropdown", "placeholder": "operation", "data": [...] }
# @raycast.argument2 { "type": "dropdown", "placeholder": "model", "data": [...] }
# @raycast.argument3 { "type": "text", "placeholder": "prompt/path", "optional": true } 