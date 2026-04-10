#!/bin/bash
##################################
# Winlator Base Chroot Container #
##################################
# Chroot Container IS default root user
# libde265
#  nasm
#  yasm
allPkg=(
  curl
  wget
  zstd

  base-devel
  ninja
  meson
  git
  glib2-devel
  libx11
  mesa
  libpulse
  vulkan-devel
  libdrm

  python-pip

  glslang
  cmake
  patchelf

  ccache
)
pacman -Syu --noconfirm
pacman-key --init
pacman -S --needed --noconfirm ${allPkg[@]}
pacman -Scc --noconfirm
sed -i 's/^#en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen
locale-gen
exit 0