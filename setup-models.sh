#!/bin/bash

# Create necessary directories
mkdir -p cc-volumes/text-generation/models
mkdir -p cc-volumes/text-generation/loras
mkdir -p cc-volumes/text-generation/presets
mkdir -p cc-volumes/text-generation/characters
mkdir -p cc-volumes/text-generation/extensions
mkdir -p local/logs/text-generation-webui

echo "Directory structure created for text-generation-webui."
echo ""
echo "For Apple Silicon Macs, we recommend using GGUF models which are optimized for CPU inference."
echo ""
echo "To download a model from Hugging Face, you can use:"
echo "docker-compose run --rm text-generation-webui python /app/text-generation-webui/download-model.py organization/model"
echo ""
echo "Recommended models for Apple Silicon:"
echo ""
echo "1. Mistral 7B Instruct GGUF (Q4_K_M):"
echo "   docker-compose run --rm text-generation-webui python /app/text-generation-webui/download-model.py TheBloke/Mistral-7B-Instruct-v0.2-GGUF"
echo ""
echo "2. Llama 2 7B Chat GGUF (Q4_K_M):"
echo "   docker-compose run --rm text-generation-webui python /app/text-generation-webui/download-model.py TheBloke/Llama-2-7B-Chat-GGUF"
echo ""
echo "3. Phi-2 GGUF (Q4_K_M):"
echo "   docker-compose run --rm text-generation-webui python /app/text-generation-webui/download-model.py TheBloke/phi-2-GGUF"
echo ""
echo "You can also manually place model files in the cc-volumes/text-generation/models directory."
echo ""
echo "Setup complete! You can now run the container with:"
echo "docker-compose up -d text-generation-webui" 