#!/bin/bash -ex

if [ $# -ne 1 ]; then
    printf "Usage: %s <image_file>\n" "$(basename "$0")"
    exit 1
fi

img=$1

kvm -bios /usr/share/OVMF/OVMF_CODE.fd -smp 2 -m 4096 \
    -netdev user,id=net0,hostfwd=tcp::8022-:22 \
    -device virtio-net-pci,netdev=net0 \
    -drive if=virtio,file="$img",format=raw \
    -device virtio-rng-pci \
    -serial mon:stdio
