# aida-genai-workshop
Workshop files for the AIDA Data Hub Generative AI workshop

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

2. Build the Docker image:
```bash
docker build -t comfyui-workshop .
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

5. Run the container with NFS mount:
```bash
docker run -it --gpus all \
  -p 8188:8188 \
  -v /mnt/shared_folder:/ComfyUI/models/checkpoints \
  comfyui-workshop
```
