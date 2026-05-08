# ComfyUI Docker Restore Notes

## Files
- robyn-comfyui-cu128-py312.tar.gz
- comfyui-data-backup.tar.gz
- docker-compose.yml
- start.sh

## Restore Procedure

### 1. Install Docker

### 2. Load image
```bash
gunzip -c robyn-comfyui-cu128-py312.tar.gz | docker load
```

Long version:

```bash
mkdir -p ~/docker/comfyui-docker
cd ~/docker/comfyui-docker
tar -xzf ~/comfyui-export/comfyui-data-backup.tar.gz
cp ~/comfyui-export/docker-compose.yml .
cp ~/comfyui-export/start.sh .
chmod +x start.sh
```


### 3. Extract data backup
```bash
tar -xzf comfyui-data-backup.tar.gz
```

### 4. Start container

```bash
docker compose up -d
```

### 5. Access

http://localhost:8188
