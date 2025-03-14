#!/bin/bash

# Set environment variables for Apple Silicon
export GPU_CHOICE=E
export INSTALL_EXTENSIONS=TRUE
export TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;6.1;7.0;7.5;8.0;8.6+PTX"

# Use environment variables for ports if available
API_PORT=${PORT_TEXT_GENERATION_API:-5010}

# Read command line flags from file if it exists
if [ -f "CMD_FLAGS.txt" ]; then
    CMD_FLAGS=$(cat CMD_FLAGS.txt)
    # Replace placeholders with actual values
    CMD_FLAGS=${CMD_FLAGS//5010/$API_PORT}
else
    # Default flags for API server
    CMD_FLAGS="--trust-remote-code --api --listen --api-port=$API_PORT"
fi

echo "Starting with API port: $API_PORT"

# Make sure core dependencies are installed
echo "Ensuring core dependencies are installed..."
pip install --no-deps --no-cache-dir rich pyyaml colorama tqdm requests numpy pandas fastapi gradio || true

# Try to install from simplified requirements if available
if [ -f "requirements_simplified.txt" ]; then
    echo "Installing dependencies from requirements_simplified.txt..."
    pip install --no-cache-dir -r requirements_simplified.txt || echo "Some dependencies may have failed to install, continuing anyway..."
elif [ -f "requirements_apple_silicon.txt" ]; then
    echo "Installing dependencies from requirements_apple_silicon.txt..."
    pip install --no-cache-dir -r requirements_apple_silicon.txt || echo "Some dependencies may have failed to install, continuing anyway..."
else
    echo "Warning: No requirements file found, using default requirements.txt"
    pip install --no-cache-dir -r requirements.txt || echo "Some dependencies may have failed to install, continuing anyway..."
fi

# Install extensions if not already installed
if [ ! -d "extensions" ] || [ "$FORCE_INSTALL_EXTENSIONS" = "TRUE" ]; then
    echo "Installing extensions..."
    mkdir -p extensions
    
    # Install common extensions
    if [ -d "extensions/api" ]; then
        echo "Installing API extension..."
        pip install --no-cache-dir SpeechRecognition==3.10.0 flask_cloudflared==0.0.14 sse-starlette==1.6.5 tiktoken || true
    fi
    
    if [ -d "extensions/openai" ]; then
        echo "Installing OpenAI extension..."
        pip install --no-cache-dir tiktoken || true
    fi
    
    # Install other extensions as needed
    if [ -d "extensions/silero_tts" ]; then
        echo "Installing Silero TTS extension..."
        pip install --no-cache-dir silero || true
    fi
    
    if [ -d "extensions/elevenlabs_tts" ]; then
        echo "Installing ElevenLabs TTS extension..."
        pip install --no-cache-dir elevenlabs || true
    fi
fi

# Run the server with the specified flags
echo "Starting text-generation-webui with flags: $CMD_FLAGS"
python server.py $CMD_FLAGS 