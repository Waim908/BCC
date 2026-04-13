rootfsURL="${ROOTFS_URL:-https://mirror.adectra.com/archlinux/iso/2026.02.01/archlinux-bootstrap-2026.02.01-x86_64.tar.zst}"

# default: GITHUB_WORKSPACE
aria2c -s16 -x16 "$rootfsURL" || exit 1
rootfsPath="$GITHUB_WORKSPACE/archlinux"
mkdir "$rootfsPath"
pkgName=$(basename $rootfsURL)
sudo tar --strip-components=1 -xf $pkgName -C "$rootfsPath" && rm -rf $pkgName

sudo cp -r /etc/hostname "$rootfsPath/etc/hostname"
sudo cp -r /etc/hosts "$rootfsPath/etc/hosts"
sudo cp -r /etc/nsswitch.conf "$rootfsPath/etc/nsswitch.conf"

# 先备份原始的 resolv.conf
sudo cp "$rootfsPath/etc/resolv.conf" "$rootfsPath/etc/resolv.conf.backup"

# GitHub Actions 的宿主机通常使用 systemd-resolved，
# /etc/resolv.conf 里是 127.0.0.53，chroot 里用不了，强制改成公共 DNS
cat << EOF | sudo tee "$rootfsPath/etc/resolv.conf" > /dev/null
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 1.1.1.1
EOF

# 写入 pacman 镜像源列表
sudo mkdir -p "$rootfsPath/etc/pacman.d"
# 检测是否为 Arch Linux ARM（通过检查是否存在 alarm 仓库配置）
if [ -f "$rootfsPath/etc/pacman.d/mirrorlist-arm" ] || echo "$rootfsURL" | grep -qi "archlinuxarm"; then
  echo "Detected Arch Linux ARM, using ARM mirrors..."
  sudo tee $rootfsPath/etc/pacman.d/mirrorlist << 'EOF'
# Arch Linux ARM mirrors
Server = http://os.archlinuxarm.org/os/$arch/$repo
EOF
else
  sudo tee "$rootfsPath/etc/pacman.d/mirrorlist" < mirrorlist >/dev/null
fi

# 挂载必要的虚拟文件系统
bash mount.sh mount "$rootfsPath"

# 按照 arch-bootstrap.sh 的 configure_minimal_system 调整 pacman 配置，
# 关闭 DownloadUser、CheckSpace 和签名校验，适配 CI 环境
sudo sed -i 's/^DownloadUser/#DownloadUser/' "$rootfsPath/etc/pacman.conf" || true
sudo sed -i "s/^[[:space:]]*\\(CheckSpace\\)/# \\1/" "$rootfsPath/etc/pacman.conf" || true
sudo sed -i "s/^[[:space:]]*SigLevel[[:space:]]*=.*$/SigLevel = Never/" "$rootfsPath/etc/pacman.conf" || true

# 在 chroot 内更新系统
sudo chroot "$rootfsPath" /bin/pacman -Syu --noconfirm || exit 1

# 再次进入 chroot 清理 pacman 缓存，回收空间（失败不致命）
sudo chroot "$rootfsPath" /bin/pacman -Scc --noconfirm || true

# 退出后卸载
bash mount.sh unmount "$rootfsPath"

# 打包前清理 rootfs 内的缓存，减小体积
sudo rm -rf "$rootfsPath/var/cache/pacman/pkg" "$rootfsPath/var/lib/pacman/sync"

sudo tar -I "xz -T$(nproc) -9" -cf /tmp/archlinux-latest.tar.xz archlinux || exit 1
