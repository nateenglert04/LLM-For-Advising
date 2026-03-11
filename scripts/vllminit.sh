#!/bin/bash

# Check for .env (required for model, HuggingFace and future dependency secrets)
if [ -f .env ]; then
    set -a
    source .env
    set +a
else
    echo "ERROR: .env file not found."
    exit 1
fi

# Set project directories and dependencies for Apptainer
PROJECT_ROOT="/storage/work/nke5100/llm-for-advising"
export APPTAINER_CACHEDIR="$PROJECT_ROOT/infra/apptainer_cache"
export APPTAINER_TMPDIR="$PROJECT_ROOT/infra/apptainer_tmp"
export APPTAINERENV_HUGGING_FACE_HUB_TOKEN=$HUGGING_FACE_HUB_TOKEN

# Path to the container and cache
IMAGE="$PROJECT_ROOT/infra/images/vllm-openai.sif"
CACHE="$PROJECT_ROOT/infra/model_cache"

# Run vLLM
apptainer run --nv \
  --bind $CACHE:/root/.cache/huggingface \
  $IMAGE \
  --model "$MODEL_NAME" \
  --port "8000" \
  --gpu-memory-utilization "0.90"