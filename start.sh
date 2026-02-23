#!/bin/bash
# ==============================================================================
# start.sh - Main container entrypoint
# ==============================================================================
set -e

echo "=========================================="
echo "  Starting LTX-2 RunPod Template"
echo "=========================================="

# 1. Boot up the workspace (Downloads LTX-2 to volume on first launch)
bash /app/init_workspace.sh

# 2. Activate the virtual environment
source /workspace/venv/bin/activate

# 3. Start JupyterLab (RunPod base images often have a built-in start-jupyter.sh, 
# but we can start it manually here if we want to ensure it runs in the background)
echo ">> Starting JupyterLab on port 8888..."
jupyter lab \
    --ip=0.0.0.0 \
    --port=8888 \
    --no-browser \
    --allow-root \
    --ServerApp.token="" \
    --ServerApp.allow_origin="*" \
    --notebook-dir=/workspace \
    > /workspace/jupyter.log 2>&1 &

# 4. Start the Gradio Trainer UI
echo ">> Starting Gradio Trainer on port 7860..."
if [ -f "/app/gradio_trainer.py" ]; then
    cd /app
    # Run in the foreground so the container doesn't exit
    python3 /app/gradio_trainer.py
else
    echo ">> WARNING: /app/gradio_trainer.py not found. Container will sleep to stay alive."
    sleep infinity
fi
