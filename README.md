# Academic Advisor LLM for School of Engineering
**High-Performance RAG Pipeline and Fine-Tuned Model for Penn State Behrend**

This repository contains the infrastructure and application logic for a Large Language Model (LLM) designed to assist with academic advising. By leveraging **Retrieval-Augmented Generation (RAG)**, the system can answer specific questions about the Penn State Behrend course catalog and degree requirements. The system will also leverage Fine-Tuning to allow the model to have intrinsic knowledge of the Behrend School of Engineering advisng documents.

---

## Project Architecture
The system is built to run on the **ROAR Collab** High-Performance Computing (HPC) environment:
* **Inference Engine:** [vLLM](https://github.com/vllm-project/vllm) running inside an Apptainer container for high-throughput instruction following.
* **Model:** Still under discussion with team.
* **Compute:** Optimized for NVIDIA A100 GPUs with 40GB VRAM.
* **Storage:** Entirely contained within the `/storage/work` partition.

---

## Setup for Collaborators

### 1. Prerequisites
Before starting, ensure you have:
1.  **ROAR Collab Access:** An active ICDS account.
2.  **Hugging Face Token:** A "Read" token generated from your [HF Settings](https://huggingface.co/settings/tokens).

### 2. Initializing the Project
Clone the repository and set up your local environment file:

```bash
# Clone the repository
git clone https://github.com/nateenglert04/LLM-For-Advising.git
cd llm-for-advising
```
```bash
# Create your environment file
cp .env.example .env
```
```bash
# Edit the .env file and paste your Hugging Face token
HUGGING_FACE_HUB_TOKEN=hf_your_token_here

# Model is under disucssion. This is the model I am currently testing with. You will need to authorize yourself on HuggingFace to allow yourself to use this model
MODEL_NAME=meta-llama/Llama-3.1-8B-Instruct
```

### 3. Running on ROAR Collab
Since this project requires a GPU, you must request a compute node before running the initialization script.

<strong> Step A: Request a Node </strong>
```bash
salloc --partition=sla-prio --account={account_name_with_gpu_on_roar_collabn} --gres=gpu:a100:1 --mem=128G --time={alloted_time_of_allocation_you_desire}
```

<strong> Step B: Launch vLLM </strong>\
The vllminit.sh script automatically handles path redirection to the work partition and pulls the container image if it is missing. 

<strong>Disclaimer: </strong> This may not work at the moment. I am lookinbg into creating a group on ROAR Collab to use to host our model weights and vLLM rather than them exclusively living in my account.
```bash
./scripts/vllminit.sh
```

## Testing the Inference Engine
While the server is running on the compute node, open a second terminal tab and run:
```bash
curl http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "meta-llama/Llama-3.1-8B-Instruct",
    "messages": [{"role": "user", "content": "What are the core requirements for a CS degree at Behrend?"}]
  }'
```

You can also read the API endpoints that vLLM provides via Swagger Docs at https://localhost:8000 but you will have to forward a port by running the following script:
```bash
ssh -L 8000:localhost:8000 {roar_collab_username}@submit.hpc.psu.edu
```