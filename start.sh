#!/bin/bash

# Проверка наличия NVIDIA драйверов
if ! nvidia-smi &>/dev/null; then
    echo "Ошибка: NVIDIA драйверы не найдены!"
    exit 1
fi

# Папка для данных (по умолчанию ./data)
DATA_FOLDER=$(realpath "${1:-./data}")
mkdir -p "$DATA_FOLDER"

# Подключение камер
CAMERA_DEVICES=()
for dev in /dev/video*; do
    [ -e "$dev" ] && CAMERA_DEVICES+=("--device=$dev:$dev")
done

# Разрешения для X11
xhost +local:docker

# Сборка образа
docker build -t deepfacelive . || {
    echo "Ошибка сборки Docker образа!"
    exit 1
}

# Запуск контейнера
docker run \
    --gpus all \
    -e DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "$DATA_FOLDER:/data" \
    "${CAMERA_DEVICES[@]}" \
    --rm -it \
    deepfacelive

# Восстановление настроек X11
xhost -local:docker
