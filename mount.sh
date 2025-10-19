#!/bin/bash
case $1 in
  mount)
    sudo mount --bind /proc $2/proc
    sudo mount --bind /sys $2/sys
    sudo mount --bind /dev $2/dev
    sudo mount --bind /dev/pts $2/dev/pts
  ;;
  unmount)
    sudo unmount $2/dev
    sudo unmount $2/sys
    sudo unmount $2/dev
    sudo unmount $2/dev/pts
  ;;
esac