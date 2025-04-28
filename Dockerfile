FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu20.04

WORKDIR /app
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    && add-apt-repository universe \
    && apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    libgl1-mesa-glx \
    libegl1-mesa \
    libxrandr2 \
    libxss1 \
    libxcursor1 \
    libxcomposite1 \
    libasound2 \
    libxi6 \
    libxtst6 \
    libsm6 \
    curl \
    ffmpeg \
    git \
    nano \
    gnupg2 \
    wget \
    unzip \
    libxcb-xinerama0 \
    libxcb-cursor0 \
    libxcb-keysyms1 \
    libxcb-render0 \
    libxcb-render-util0 \
    libxcb-image0 \
    libglvnd0 \
    libopengl0 \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN git clone https://github.com/iperov/DeepFaceLive.git

RUN python -m pip install --upgrade pip && \
    pip install \
    onnxruntime-gpu==1.15.1 \
    numpy==1.21.6 \
    h5py \
    numexpr \
    protobuf==3.20.3 \  # Обновленная версия для совместимости
    opencv-python==4.8.0.74 \
    opencv-contrib-python==4.8.0.74 \
    pyqt6==6.5.1 \
    onnx==1.14.0 \
    torch==1.13.1+cu117 --extra-index-url https://download.pytorch.org/whl/cu117 \
    torchvision==0.14.1+cu117 --extra-index-url https://download.pytorch.org/whl/cu117

WORKDIR /app/DeepFaceLive
COPY example.sh example.sh

ENV CUDA_VISIBLE_DEVICES=0
ENV QT_QPA_PLATFORM=xcb
ENV QT_DEBUG_PLUGINS=1

CMD ["./example.sh"]
