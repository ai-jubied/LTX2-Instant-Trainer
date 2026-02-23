#!/usr/bin/env python3
"""
download_models.py - Downloads LTX-2 model weights.

TODO: This is a placeholder. The original content was baked into the Docker image.
      Extract it from a running container:
      docker cp <container_id>:/app/download_models.py ./download_models.py

This script downloads the required model checkpoints from HuggingFace
to /workspace/huggingface for use by the LTX-2 training pipeline.
"""

import os

def main():
    hf_home = os.environ.get("HF_HOME", "/workspace/huggingface")
    os.makedirs(hf_home, exist_ok=True)

    print(f"download_models.py: Downloading models to {hf_home}...")

    # TODO: Add model download logic here, e.g.:
    # from huggingface_hub import snapshot_download
    # snapshot_download("Lightricks/LTX-Video-2", local_dir=f"{hf_home}/ltx-video-2")

    print("download_models.py: Done.")

if __name__ == "__main__":
    main()
