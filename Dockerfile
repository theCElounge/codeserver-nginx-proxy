FROM codercom/code-server:latest

USER root

RUN apt-get update && \
    apt-get install -y \
    git \
    curl \
    wget \
    python3 \
    python3-pip \
    build-essential \
    nano \
    nodejs \
    npm \
    htop \
    tmux \
    vim \
    binutils \
    qemu-user \
    gcc-aarch64-linux-gnu \
    && rm -rf /var/lib/apt/lists/*
RUN pip install numpy --break-system-packages\
    pandas --break-system-packages\
    matplotlib --break-system-packages\
    scikit-learn --break-system-packages

USER coder