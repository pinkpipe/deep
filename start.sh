#!/bin/bash

NV_VER=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader | head -1 | cut -d. -f1)
if [ -z "$NV_VER" ]; then
    echo "ERROR: NVIDIA driver version not found!"
    exit 1
fi

DATA_FOLDER=$(realpath "${1:-./data}")
mkdir -p "$DATA_FOLDER"

CAMERA_DEVICES=()
for dev in /dev/video*; do
    [ -e "$dev" ] && CAMERA_DEVICES+=("--device=$dev:$dev")
done

xhost +local:docker

docker build . -t deepfacelive --build-arg NV_VER="$NV_VER" || {
    echo "Docker build failed!"
    exit 1
}

docker run \
    --ipc host \
    --gpus '"device=0"' \
    -e DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    -e QT_QPA_PLATFORM=xcb \
    -e __GLX_VENDOR_LIBRARY_NAME=mesa \
    -e VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/radeon_icd.x86_64.json \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "$DATA_FOLDER:/data" \
    "${CAMERA_DEVICES[@]}" \
    --rm -it \
    deepfacelive

xhost -local:docker
