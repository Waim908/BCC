#!/bin/bash
# Chroot Container IS default root user
# Thanks: https://github.com/AndreRH/hangover
export DEBIAN_FRONTEND=noninteractive
echo "Types: deb" > /tmp/new.src; echo "URIs: http://archive.ubuntu.com/ubuntu/" >> /tmp/new.src; echo "Suites: noble noble-updates noble-backports" >> /tmp/new.src; echo "Components: main universe restricted multiverse" >> /tmp/new.src; echo "Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg" >> /tmp/new.src; echo "Architectures: amd64" >> /tmp/new.src; \
    echo "" >> /tmp/new.src; \
    echo "Types: deb" >> /tmp/new.src; echo "URIs: http://ports.ubuntu.com/ubuntu-ports/" >> /tmp/new.src; echo "Suites: noble noble-updates noble-backports" >> /tmp/new.src; echo "Components: main universe restricted multiverse" >> /tmp/new.src; echo "Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg" >> /tmp/new.src; echo "Architectures: arm64" >> /tmp/new.src; \
    cp /tmp/new.src /etc/apt/sources.list.d/ubuntu.sources && dpkg --add-architecture arm64
allPkg=(
    binutils-aarch64-linux-gnu gcc-aarch64-linux-gnu \
    ca-certificates nano python3 python3-setuptools clang screen llvm lld wget curl \
    flex bison nasm \
    libglib2.0-dev \
    libltdl-dev \
    libxcb1-dev \
    libx11-dev  \
    librsvg2-bin \
    git gettext make automake autoconf pkg-config libtool gtk-doc-tools clang \
    dpkg-dev \
    libglib2.0-dev:arm64 \
    libfreetype-dev:arm64 \
    libltdl-dev:arm64 \
    libxcb1-dev:arm64 \
    libx11-dev:arm64 \
    build-essential libc-dev-arm64-cross less libc-devtools libidn2-0:arm64 \
    libx11-dev libxinerama-dev libfreetype-dev libfontconfig-dev \
    cmake \
    libstdc++6-arm64-cross \
    libstdc++-13-dev-arm64-cross \
    libepoxy-dev:arm64 \
    libsdl2-dev:arm64 \
    ninja-build \
    dpkg-dev fakeroot debhelper dh-make \
    libxcursor-dev:arm64 \
    libxi-dev:arm64 \
    libxshmfence-dev:arm64 \
    libxxf86vm-dev:arm64 \
    libxrandr-dev:arm64 \
    libxrender-dev:arm64 \
    libxfixes-dev:arm64 \
    libxcomposite-dev:arm64 \
    libdbus-1-dev:arm64 \
    libsane-dev:arm64 \
    libusb-1.0-0-dev:arm64 \
    libv4l-dev:arm64 \
    libpulse-dev:arm64 \
    libgstreamer1.0-dev:arm64 \
    libgstreamer-plugins-base1.0-dev:arm64 \
    libudev-dev:arm64 \
    libunwind-dev:arm64 \
    libsdl2-dev:arm64 \
    libfontconfig1-dev:arm64 \
    libkrb5-dev:arm64 \
    libvulkan-dev:arm64 \
    libgl-dev:arm64 \
    libgnutls28-dev:arm64 \
    libcups2-dev:arm64 \
    libxkbcommon-dev:arm64 \
    libxkbregistry-dev:arm64 \
    libwayland-dev:arm64 \
    ocl-icd-opencl-dev:arm64 libavcodec-dev:arm64 libavutil-dev:arm64 libavformat-dev:arm64 libswresample-dev:arm64 locales
)
apt-get update
apt-get install -y --no-install-recommends ${allPkg[@]} || exit 1
apt-get install -f || exit 1
apt-get clean
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
exit 0