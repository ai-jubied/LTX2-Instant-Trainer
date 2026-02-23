#!/bin/bash
# ==============================================================================
# init_workspace.sh - Installs LTX-2 and models into the persistent Network Volume
# ==============================================================================
set -e

echo "=========================================="
echo "  Initializing Workspace (Persistent Data)"
echo "=========================================="

WORKSPACE_DIR="/workspace"
LTX_DIR="$WORKSPACE_DIR/LTX-2"
VENV_DIR="$WORKSPACE_DIR/venv"

# 1. Check if LTX-2 is already installed
if [ -d "$LTX_DIR" ] && [ -d "$VENV_DIR" ]; then
    echo ">> LTX-2 is already installed in the workspace. Skipping cloning and installation."
else
    echo ">> First boot detected! Installing LTX-2 to the persistent volume..."

    # 1. Clone LTX-2
    echo ">> Cloning Lightricks/LTX-2..."
    cd $WORKSPACE_DIR
    git clone --depth 1 https://github.com/Lightricks/LTX-2.git
    
    # 3. Create Virtual Environment
    echo ">> Creating Python virtual environment..."
    uv venv $VENV_DIR
fi

# 4. Activate VENV and Install Packages (uv pip install is idempotent and fast)
echo ">> Activating virtual environment and ensuring dependencies are installed..."
source $VENV_DIR/bin/activate

cd $LTX_DIR
echo ">> Installing LTX-2 dependencies..."
uv pip install -e packages/ltx-trainer
uv pip install hf_transfer gradio pyyaml pillow pandas watchdog psutil gputil huggingface_hub[hf_xet]

# 5. Apply any custom patches (e.g., embeddings patch)
# If you extract fix_embeddings.py, you can run it here:
if [ -f "/app/fix_embeddings.py" ]; then
    echo ">> Applying embedding patches..."
    python3 /app/fix_embeddings.py || true
fi

# 6. Download models (if needed)
if [ ! -d "$WORKSPACE_DIR/huggingface/ltx-video-2" ]; then
    echo ">> Downloading LTX-Video-2 models to HuggingFace cache..."
    if [ -f "/app/download_models.py" ]; then
        python3 /app/download_models.py || true
    fi
fi

echo "=========================================="
echo "  Workspace Initialization Complete!"
echo "=========================================="
