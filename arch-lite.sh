rootfsURL="${ROOTFS_URL:-https://mirror.adectra.com/archlinux/iso/2026.02.01/archlinux-bootstrap-2026.02.01-x86_64.tar.zst}"

# default: GITHUB_WORKSPACE
wget -O rootfs.tar.zst "$rootfsURL"
rootfsPath="$GITHUB_WORKSPACE/archlinux"
mkdir "$rootfsPath"
sudo tar --strip-components=1 -xf rootfs.tar.zst -C "$rootfsPath"

sudo cp -r /etc/hostname "$rootfsPath/etc/hostname"
sudo cp -r /etc/hosts "$rootfsPath/etc/hosts"
sudo cp -r /etc/nsswitch.conf "$rootfsPath/etc/nsswitch.conf"

# GitHub Actions 的宿主机通常使用 systemd-resolved，
# /etc/resolv.conf 里是 127.0.0.53，chroot 里用不了，强制改成公共 DNS
sudo bash -c "cat > '$rootfsPath/etc/resolv.conf' << 'EOF'
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 1.1.1.1
EOF"

# 写入 pacman 镜像源列表
sudo mkdir -p "$rootfsPath/etc/pacman.d"
sudo tee "$rootfsPath/etc/pacman.d/mirrorlist" < mirrorlist >/dev/null

# 挂载必要的虚拟文件系统
bash mount.sh mount "$rootfsPath"

# 在 chroot 内更新系统
sudo chroot "$rootfsPath" /bin/pacman -Syu --noconfirm || exit 1

# 退出后卸载
bash mount.sh unmount "$rootfsPath"

sudo tar -I "xz -T$(nproc)" -cf /tmp/archlinux-latest.tar.xz archlinux || exit 1
