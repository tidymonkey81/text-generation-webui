FROM python:3.11-slim-bullseye

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    GPU_CHOICE=E \
    INSTALL_EXTENSIONS=TRUE \
    LAUNCH_AFTER_INSTALL=FALSE \
    TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;6.1;7.0;7.5;8.0;8.6+PTX" \
    APP_UID=6972 \
    APP_GID=6972 \
    # Disable platform checks for pip
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PIP_BREAK_SYSTEM_PACKAGES=1

# Install system dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    git \
    build-essential \
    python3-dev \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Create app user and directory
RUN groupadd -g ${APP_GID} app && \
    useradd -u ${APP_UID} -g app -m app

# Set up working directory
WORKDIR /home/app
RUN chown -R app:app /home/app

# Switch to app user
USER app

# Clone the repository
RUN git clone https://github.com/oobabooga/text-generation-webui.git
WORKDIR /home/app/text-generation-webui

# Copy requirements files
COPY --chown=app:app requirements_apple_silicon.txt ./
COPY --chown=app:app requirements_simplified.txt ./

# Install Python dependencies optimized for Apple Silicon
RUN pip install --upgrade pip setuptools wheel

# Install core dependencies first to avoid the platform check issues
RUN pip install --no-deps rich pyyaml colorama tqdm requests numpy pandas fastapi gradio
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Install from simplified requirements
RUN pip install -r requirements_simplified.txt || echo "Some dependencies may have failed to install, continuing anyway..."

# Copy the start script and modify it for container use
COPY --chown=app:app start_container.sh ./
RUN chmod +x start_container.sh

# Copy API flags
COPY --chown=app:app CMD_FLAGS.txt ./

# Expose ports - use ARG for flexibility
ARG WEB_PORT=7860
ARG API_PORT=5010
ARG STREAMING_PORT=5015

# Expose ports
EXPOSE ${WEB_PORT} ${API_PORT} ${STREAMING_PORT}

# Set umask to ensure group read/write at runtime
CMD umask 0002 && ./start_container.sh 