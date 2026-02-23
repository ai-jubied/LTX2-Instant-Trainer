# ==============================================================================
# LTX-2 RunPod Template (Instant-Boot)
# Author: Configured for GitHub & RunPod
# Base: Official RunPod PyTorch Image (Cached for fast boots)
# ==============================================================================

FROM runpod/pytorch:2.2.0-py3.10-cuda12.1.1-devel-ubuntu22.04

# ---- Environment Variables ----
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_PREFER_BINARY=1
ENV WORKSPACE=/workspace

# Set HF_HOME so models are downloaded to the persistent volume
ENV HF_HOME=/workspace/huggingface

# ---- Install uv ----
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# ---- System Dependencies ----
# These install quickly and keep the Docker image extremely thin.
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    git-lfs \
    ffmpeg \
    libsm6 \
    libxext6 \
    libgl1 \
    libglib2.0-0 \
    libsndfile1 \
    unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ---- Application Files ----
RUN mkdir -p /app
COPY . /app/
RUN chmod +x /app/start.sh /app/init_workspace.sh

# ---- Nginx Config for Jupyter and UI Proxy ----
# Overwrite the default runpod nginx config if necessary, or let runpod handle it
# RunPod base image already sets up Jupyter on 8888.

WORKDIR /workspace

# Exposed ports (8888 for Jupyter is standard in the base image, 7860 for Gradio)
EXPOSE 7860 8888

# Use our custom start script as the entrypoint
CMD ["bash", "/app/start.sh"]
