FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Stockholm
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

RUN printf '%s\n' \
    'deb http://archive.ubuntu.com/ubuntu/ xenial main restricted universe multiverse' \
    'deb http://archive.ubuntu.com/ubuntu/ xenial-updates main restricted universe multiverse' \
    'deb http://archive.ubuntu.com/ubuntu/ xenial-security main restricted universe multiverse' \
    > /etc/apt/sources.list

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
    file \
    android-tools-fsutils \
    openjdk-8-jdk \
    python \
    python-pip \
    python3 \
    git-core \
    gnupg \
    flex \
    bison \
    gperf \
    build-essential \
    zip \
    curl \
    gawk \
    liblz4-tool \
    zlib1g-dev \
    gcc-multilib \
    g++-multilib \
    libc6-dev-i386 \
    lib32ncurses5 \
    lib32ncurses5-dev \
    x11proto-core-dev \
    libx11-dev \
    lib32z-dev \
    ccache \
    libgl1-mesa-dev \
    libxml2-utils \
    xsltproc \
    unzip \
    mtools \
    u-boot-tools \
    htop \
    iotop \
    sysstat \
    iftop \
    pigz \
    bc \
    device-tree-compiler \
    lunzip \
    dosfstools \
    vim-common \
    parted \
    udev \
    libssl-dev \
    lzop \
    swig \
    sudo \
    rsync \
    cpio \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN groupadd -g ${GROUP_ID} builder \
    && useradd -m -u ${USER_ID} -g ${GROUP_ID} -s /bin/bash builder

ENV HOME=/home/builder

USER builder
WORKDIR /src
