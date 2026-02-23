rootfsURL="${ROOTFS_URL:-https://mirror.adectra.com/archlinux/iso/2026.02.01/archlinux-bootstrap-2026.02.01-x86_64.tar.zst}"

# default: GITHUB_WORKSPACE
wget -O rootfs.tar.zst "$rootfsURL"
rootfsPath="$GITHUB_WORKSPACE/archlinux"
mkdir "$rootfsPath"
sudo tar --strip-components=1 -xf rootfs.tar.zst -C "$rootfsPath"

sudo cp -r /etc/resolv.conf "$rootfsPath/etc/resolv.conf"
sudo cp -r /etc/hostname "$rootfsPath/etc/hostname"
sudo cp -r /etc/hosts "$rootfsPath/etc/hosts"
sudo cp -r /etc/nsswitch.conf "$rootfsPath/etc/nsswitch.conf"

sudo cat BCC/mirrorlist > "$rootfsPath/etc/pacman.d/mirrorlist"

# 挂载必要的虚拟文件系统
bash BCC/mount.sh mount "$rootfsPath"

# 在 chroot 内更新系统
sudo chroot "$rootfsPath" /bin/pacman -Syu --noconfirm || exit 1

# 退出后卸载
bash BCC/mount.sh unmount "$rootfsPath"

tar -I "xz -T$(nproc)" -cf /tmp/archlinux-latest.tar.xz archlinux || exit 1
