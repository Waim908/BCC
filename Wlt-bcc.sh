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

  glslang
  cmake
  patchelf
)
pacman -Syu --noconfirm
pacman-key --init
pacman -S --needed --noconfirm ${allPkg[@]}
exit 0