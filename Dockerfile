FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu20.04

WORKDIR /app
ARG DEBIAN_FRONTEND=noninteractive

# Установка всех зависимостей
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3 \
    python3-pip \
    python3-dev \
    libgl1-mesa-glx \
    libxcb-xinerama0 \
    libxcb-cursor0 \
    libxkbcommon-x11-0 \
    && rm -rf /var/lib/apt/lists/*

# Создание симлинков
RUN ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip

# Клонирование репозитория
RUN git clone https://github.com/iperov/DeepFaceLive.git

# Установка Python-пакетов
RUN pip install --upgrade pip && \
    pip install \
    onnxruntime-gpu==1.15.1 \
    numpy==1.21.6 \
    protobuf==3.20.3 \
    opencv-python==4.8.0.74 \
    pyqt6==6.5.1 \
    torch==1.13.1+cu117 --extra-index-url https://download.pytorch.org/whl/cu117

WORKDIR /app/DeepFaceLive

# Переменные окружения
ENV CUDA_VISIBLE_DEVICES=0
ENV QT_QPA_PLATFORM=xcb

# Точка входа
CMD ["./example.sh"]
