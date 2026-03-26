#!/bin/bash
# Chroot Container IS default root user
export DEBIAN_FRONTEND=noninteractive
allPkg=(
git libwayland-bin libwayland-dev libxkbregistry-dev libunwind-dev autoconf bison ccache debhelper desktop-file-utils docbook-to-man docbook-utils docbook-xsl flex fontforge gawk gettext libacl1-dev libasound2-dev libcapi20-dev libcups2-dev libdbus-1-dev libgif-dev libglu1-mesa-dev libgphoto2-dev libgsm1-dev libgtk-3-dev libkrb5-dev libxi-dev liblcms2-dev libldap2-dev libmpg123-dev libncurses5-dev libopenal-dev libosmesa6-dev libpcap-dev libpulse-dev libsane-dev libssl-dev libtiff5-dev libudev-dev libv4l-dev libva-dev libxslt1-dev libxt-dev ocl-icd-opencl-dev oss4-dev prelink sharutils unixodbc-dev valgrind schedtool libfreetype6-dev xserver-xorg-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev gcc-multilib g++-multilib curl fonttools libsdl2-dev python3-tk libvulkan1 libc6-dev linux-libc-dev libkdb5-* libppl14 libcolord2 libvulkan-dev libgnutls28-dev libpng-dev libkadm5clnt-mit* libkadm5srv-mit* libavcodec-dev libavutil-dev libavformat-dev libswresample-dev libvkd3d-dev libxinerama-dev libxcursor-dev libxrandr-dev libxcomposite-dev mingw-w64 glslang-dev glslang-tools meson wget python3-pefile rustc cargo python3-ldb samba-libs samba-dev libgcrypt20-dev libusb-1.0-0-dev yasm jq
locales
)
apt update
apt install -y ${allPkg[@]}
apt install -f
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
apt clean
exit 0