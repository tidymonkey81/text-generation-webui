# Text Generation WebUI for ClassroomCopilot

This directory contains the configuration for running Text Generation WebUI with TensorRT-LLM in a Docker container as part of the ClassroomCopilot project.

## Setup

### Prerequisites

1. Make sure you have Docker installed and running.
2. If you want to use GPU acceleration, ensure you have NVIDIA drivers and the NVIDIA Container Toolkit installed.

### Models

Place your language models in the following directory:

```
cc-volumes/text-generation/models/
```

The container supports various model formats including:
- GGUF models (for CPU inference)
- HuggingFace models
- TensorRT-LLM optimized models

## Running

The container is configured to start automatically with the rest of the ClassroomCopilot services:

```bash
docker-compose up -d text-generation-webui
```

Or you can start all services:

```bash
docker-compose up -d
```

## Accessing the WebUI

Once the container is running, you can access the WebUI at:

```
http://localhost:7861
```

Or through the Nginx reverse proxy at:

```
http://textgen.localhost
```

The API is available at:

```
http://localhost:5010
```

Or through the Nginx reverse proxy at:

```
http://textgen.localhost/api
```

## Configuration

The container is configured with the following settings:

- Uses CPU-only inference optimized for Apple Silicon
- Exposes both the web interface (port 7861) and API (port 5010)
- Mounts volumes for models, LoRAs, presets, characters, and extensions

## Apple Silicon Compatibility

This container is specifically configured for Apple Silicon (M1/M2/M3) Macs. It uses CPU-only inference since TensorRT-LLM is not compatible with Apple Silicon. For optimal performance on Apple Silicon:

1. Use GGUF models which are optimized for CPU inference
2. Smaller models (7B parameters or less) will perform better
3. Consider using models with quantization (like Q4_K_M) for faster inference

### Recommended Models for Apple Silicon

- Mistral 7B Instruct GGUF (Q4_K_M)
- Llama 2 7B Chat GGUF (Q4_K_M)
- Phi-2 GGUF (Q4_K_M)

You can download these models using the setup script or manually place them in the models directory.

## Troubleshooting

If you encounter issues:

1. **Model loading errors**: Ensure your models are in the correct format and location.

2. **GPU issues**: Check that your NVIDIA drivers and CUDA are properly installed and that the NVIDIA Container Toolkit is configured.

3. **Container logs**: Check the container logs for more detailed error messages:
   ```bash
   docker-compose logs text-generation-webui
   ```

4. **Restart the container**: Sometimes simply restarting the container can resolve issues:
   ```bash
   docker-compose restart text-generation-webui
   ```
