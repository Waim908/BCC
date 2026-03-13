#!/bin/bash
# Chroot Container IS default root user
allPkg=(
attr fontconfig lcms2 libxml2 libxcursor libxrandr libxdamage libxi gettext ffmpeg freetype2 glu libsm gcc-libs libpcap desktop-file-utils git autoconf ncurses bison perl fontforge flex gcc pkgconf giflib libpng gnutls wayland libxinerama libxcomposite libxmu libxxf86vm libldap mpg123 openal v4l-utils alsa-lib mesa libgl libxslt libpulse libva glib2-devel gtk3 gst-plugins-base-libs gst-plugins-good vulkan-headers vulkan-icd-loader sdl2 libcups samba opencl-headers meson ninja glslang wget ocl-icd giflib libpng alsa-plugins libjpeg-turbo cups dosbox ccache schedtool mingw-w64-gcc python-fonttools python-pefile rust gst-plugins-ugly libxpresent libgcrypt yasm jq libusb
git
patch
base-devel
)
pacman -Syu --noconfirm
pacman-key --init
pacman -S --noconfirm --needed ${allPkg[@]}
pacman -Scc --noconfirm
sed -i 's/^#en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen
locale-gen
exit 0