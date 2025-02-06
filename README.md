# aida-genai-workshop
Workshop files for the AIDA Data Hub Generative AI workshop

## VSCode Setup for Verdi/DSP System
1. Install Remote SSH extension in VSCode
2. Open VSCode Settings (File > Preferences > Settings / Code > Settings ... > Settings)
3. Search for and modify these settings:
```json
{
    "remote.SSH.showLoginTerminal": true,
    "remote.SSH.useLocalServer": false,
    "remote.SSH.enableAgentForwarding": true
}
```

## NFS Setup
1. Install NFS client:
```bash
sudo apt update
sudo apt install nfs-common
```

2. Create mount point and mount NFS share:
```bash
sudo mkdir -p /mnt/shared_folder
sudo mount 10.39.196.133:/shared_folder /mnt/shared_folder
```

## Docker Setup and Usage

1. Test CUDA compatibility:
```bash
docker run --rm --gpus all nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04 nvidia-smi
```

2. Clone this repository:
```bash
git clone https://github.com/NBISweden/aida-genai-workshop.git
cd aida-genai-workshop
git branch docker-comfyui
```

3. Build the Docker image:
```bash
docker build -t comfyui .
```

4. Run the container with NFS mount:
```bash
docker run -it --gpus all \
  -p 8188:8188 \
  -v /mnt/shared_folder:/ComfyUI/models/checkpoints \
  comfyui
```

## Docker workflow

### Building the Image Locally

1. Modify the Dockerfile to use CPU-only mode by changing the CMD line:
```dockerfile
CMD ["python3", "main.py", "--listen", "0.0.0.0", "--port", "8188", "--cpu"]
```

2. Build the image for your platform:

**macOS(arm)**:
```bash
docker buildx build --platform=linux/amd64 -t comfyui:latest .
```

**Windows/Linux**:
```powershell
docker build -t comfyui:latest .
```

3. Login to Docker registry:
```bash
docker login
```

4. Tag and push the image:
```bash
docker tag comfyui-workshop <your-registry>/comfyui-workshop:latest
docker push <your-registry>/comfyui-workshop:latest
```

### Running the Container

**macOS**:
```bash
docker run --platform=linux/amd64 -p 8188:8188 comfyui
```

**Linux/Windows**:
```bash
docker run -p 8188:8188 comfyui
```

### Installing ComfyUI Manager

1. Execute into the running container:
```bash
docker exec -it <container_id> bash
```

2. Install ComfyUI Manager:
```bash
cd ComfyUI/custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager comfyui-manager
cd comfyui-manager
pip install -r requirements.txt
```

3. Exit the container and commit changes:
```bash
# Get container ID
docker ps

# Commit changes
docker commit <container_id> comfyui
```

### Saving and Transferring the Image

1. Save the image to a tar file:
```bash
docker save comfyui:latest > comfyui-custom.tar
```

2. Transfer to remote machine:
```bash
scp comfyui-custom.tar verdi-vm-cpu:/shared_folder/
```

3. On the remote machine, load the image:
```bash
sudo docker load < /mnt/shared_folder/comfyui-custom.tar
```

4. Run with docker-compose:
```bash
sudo docker compose up
```
