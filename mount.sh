#!/bin/bash

case $1 in
  mount)
    # 检查目标目录参数
    if [ -z "$2" ]; then
      echo "Error: mount point not specified"
      exit 1
    fi

    # 挂载 /proc
    sudo mount --bind /proc "$2"/proc || {
      echo "Error: failed to mount /proc"
      exit 1
    }
    echo "Success: mounted /proc to $2/proc"

    # 挂载 /sys
    sudo mount --bind /sys "$2"/sys || {
      echo "Error: failed to mount /sys"
      exit 1
    }
    echo "Success: mounted /sys to $2/sys"

    # 挂载 /dev
    sudo mount --bind /dev "$2"/dev || {
      echo "Error: failed to mount /dev"
      exit 1
    }
    echo "Success: mounted /dev to $2/dev"

    # 挂载 devpts
    sudo mount -t devpts devpts "$2"/dev/pts -o gid=5,mode=620 || {
      echo "Error: failed to mount devpts"
      exit 1
    }
    echo "Success: mounted devpts to $2/dev/pts"
    ;;

  unmount)
    # 检查目标目录参数
    if [ -z "$2" ]; then
      echo "Error: mount point not specified"
      exit 1
    fi

    # 卸载 /dev/pts
    sudo umount -l "$2"/dev/pts || {
      echo "Error: failed to unmount $2/dev/pts"
      exit 1
    }
    echo "Success: unmounted $2/dev/pts"

    # 卸载 /dev
    sudo umount -l "$2"/dev || {
      echo "Error: failed to unmount $2/dev"
      exit 1
    }
    echo "Success: unmounted $2/dev"

    # 卸载 /sys
    sudo umount -l "$2"/sys || {
      echo "Error: failed to unmount $2/sys"
      exit 1
    }
    echo "Success: unmounted $2/sys"

    # 卸载 /proc
    sudo umount -l "$2"/proc || {
      echo "Error: failed to unmount $2/proc"
      exit 1
    }
    echo "Success: unmounted $2/proc"
    ;;

  *)
    echo "Usage: $0 {mount|unmount} <target-directory>"
    exit 1
    ;;
esac