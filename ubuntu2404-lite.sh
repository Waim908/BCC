rootfsURL="${ROOTFS_URL:-https://cdimage.ubuntu.com/ubuntu-base/releases/24.04.4/release/ubuntu-base-24.04.4-base-amd64.tar.gz}"

# default: GITHUB_WORKSPACE
wget -O rootfs.tar.gz "$rootfsURL"
rootfsPath="$GITHUB_WORKSPACE/ubuntu2404"
mkdir -p "$rootfsPath"
mkdir "$rootfsPath"
sudo tar -xf rootfs.tar.gz -C "$rootfsPath" && rm -rf rootfs.tar.gz

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

# 挂载必要的虚拟文件系统
bash mount.sh mount "$rootfsPath"

# 在 chroot 内更新系统
sudo chroot "$rootfsPath" /bin/apt update || exit 1

sudo chroot "$rootfsPath" /bin/bash -c "yes | apt upgrade" || true

sudo chroot "$rootfsPath" /bin/bash -c "yes | apt clean" || true

# 退出后卸载
bash mount.sh unmount "$rootfsPath"

# 打包前清理 rootfs 内的缓存，减小体积
sudo rm -rf "$rootfsPath/var/cache/pacman/pkg" "$rootfsPath/var/lib/pacman/sync"

sudo tar -I "xz -T$(nproc) -9" -cf /tmp/ubuntu2404-latest.tar.xz ubuntu2404 || exit 1
