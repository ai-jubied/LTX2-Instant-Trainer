# LTX-2 Instant-Boot RunPod Template

A lightning-fast, highly optimized RunPod Template for **LTX-2 Video & Character LoRA Training (Image-Only support included)**.

Unlike other enormous templates that take 20+ minutes to boot because they force RunPod to download a 40GB Docker image, this template uses a **Thin Docker Image + Persistent Volume** architecture. 

It boots in seconds by using RunPod's officially cached PyTorch container, and automatically configures your `LTX-2` environment and models straight onto your persistent Network Volume the very first time you launch it. Subsequent boots are nearly instant!

---

## 🚀 Features
- **Lightning Fast Boot:** Built on top of `runpod/pytorch` (officially cached by RunPod).
- **Persistent Environment:** LTX-2, Python `venv`, and HuggingFace models are stored in your `/workspace`. They are never lost when you terminate the pod.
- **Image-Only LoRA Training:** Perfect for training character likenesses, specific art styles, and identities without requiring complex video datasets. 
- **Gradio Trainer UI:** Accessible natively on Port 7860.
- **JupyterLab:** Accessible natively on Port 8888.

---

## 🛠️ How to Deploy on RunPod

### 1. Build and Push the Docker Image (Automated via GitHub)

This repository is set up with a **GitHub Action** that automatically builds and publishes the Docker image to the GitHub Container Registry (GHCR) every time you push code to the `main` branch. 

Your image will be available at:
`ghcr.io/ai-jubied/ltx2-instant-trainer:latest`

*(Note: Because your repository is Public, the GHCR package will also be public and RunPod can pull it without needing any login credentials!)*

### 2. Create the Template in RunPod

Go to your [RunPod Custom Templates](https://console.runpod.io/templates) and create a new template with the following settings:

*   **Template Name:** `LTX-2 Trainer (Instant Boot)`
*   **Container Image:** `ghcr.io/ai-jubied/ltx2-instant-trainer:latest`
*   **Container Disk:** `10 GB` (The container is thin, so it needs very little space!)
*   **Volume Disk:** `100 GB+` (All LTX-2 models and your training datasets will be stored here).
*   **Volume Mount Path:** `/workspace`
*   **Exposed HTTP Ports:** `7860, 8888`
*   **Start Command:** *(Leave blank, the Dockerfile handles this)*

---

## 📂 Project Structure

```text
├── Dockerfile              # The ultra-thin Docker config
├── start.sh                # The container entrypoint
├── init_workspace.sh       # The persistent volume setup script (runs on first boot)
├── runpod.txt              # Branded terminal login banner
├── fix_embeddings.py       # (Placeholder) Add your LTX-2 embedding patches here
├── gradio_trainer.py       # (Placeholder) Your Gradio UI code
└── download_models.py      # (Placeholder) Your model download logic
```

## 📝 A Note on Training Character LoRAs with Images
This environment is perfect for **Image-Only LoRA Training**. Since LTX-2 is a video model, it treats images as 1-frame videos. 
Ensure your dataset is strictly images (PNG/JPEG), all cropped to dimensions that are **multiples of 32**, and include descriptive `.txt` captions for each image with your chosen trigger word!
