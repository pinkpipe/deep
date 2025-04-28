FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu20.04

WORKDIR /app
ARG DEBIAN_FRONTEND=noninteractive

# Установка системных зависимостей
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    libgl1-mesa-glx \
    libxcb-xinerama0 \
    libxcb-cursor0 \
    && rm -rf /var/lib/apt/lists/*

# Клонирование репозитория
RUN git clone https://github.com/iperov/DeepFaceLive.git

# Установка Python-зависимостей (исправленный формат)
RUN python -m pip install --upgrade pip && \
    pip install \
    onnxruntime-gpu==1.15.1 \
    numpy==1.21.6 \
    h5py \
    numexpr \
    protobuf==3.20.3 \
    "opencv-python==4.8.0.74" \
    "opencv-contrib-python==4.8.0.74" \
    "pyqt6==6.5.1" \
    "onnx==1.14.0" \
    "torch==1.13.1+cu117" --extra-index-url https://download.pytorch.org/whl/cu117 \
    "torchvision==0.14.1+cu117" --extra-index-url https://download.pytorch.org/whl/cu117

WORKDIR /app/DeepFaceLive

# Переменные окружения
ENV CUDA_VISIBLE_DEVICES=0
ENV QT_QPA_PLATFORM=xcb

CMD ["python", "main.py", "run", "DeepFaceLive"]
