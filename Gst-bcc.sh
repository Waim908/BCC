#!/bin/bash
echo -e "deb http://ports.ubuntu.com/ubuntu-ports $1 main restricted universe multiverse\ndeb-src http://ports.ubuntu.com/ubuntu-ports $1 main restricted universe multiverse" | tee /etc/apt/sources.list
apt update
apt install -y build-essential libde265-0 libde265-dev pkg-config cmake automake autoconf libtool libltdl-dev autopoint flex bison libx11-dev pkg-config libx11-xcb-dev libvulkan-dev libxkbcommon-dev libxkbcommon-x11-dev libde265-dev glslang-dev libmpg123-dev mesa-common-dev libasound2-dev libpulse-dev yasm nasm glslang-tools libvulkan1 mesa-vulkan-drivers
apt build-dep libde265 gstreamer1.0 -y
apt autoremove meson ninja-build -y
pip install meson ninja --break-system-package
mkdir -p /data
# chmod 777 /data
mkdir -p /data/data/com.termux/files/usr/glibc/
