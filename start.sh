#!/bin/bash

# Определение версии драйвера NVIDIA
NV_LIB=$(find /usr/lib/modules -name nvidia.ko | grep $(uname -r) | head -1)
if [ -z "$NV_LIB" ]; then
    echo "ERROR: NVIDIA kernel module not found!"
    exit 1
fi
NV_VER=$(modinfo "$NV_LIB" | grep ^version | awk '{print $2}' | cut -d. -f1)

# Настройка данных
DATA_FOLDER=$(realpath "${1:-./data}")
mkdir -p "$DATA_FOLDER"

# Подключение камер
CAMERA_DEVICES=()
for dev in /dev/video*; do
    [ -e "$dev" ] && CAMERA_DEVICES+=("--device=$dev:$dev")
done

# Разрешение X11
xhost +local:docker

# Сборка образа
docker build . -t deepfacelive --build-arg NV_VER="$NV_VER" || {
    echo "Docker build failed!"
    exit 1
}

# Запуск контейнера
docker run \
    --ipc host \
    --gpus '"device=0"' \
    -e DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    -e __GLX_VENDOR_LIBRARY_NAME=mesa \
    -e VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/radeon_icd.x86_64.json \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "$DATA_FOLDER:/data" \
    "${CAMERA_DEVICES[@]}" \
    --rm -it \
    deepfacelive

# Отмена разрешений
xhost -local:docker
