# Lonestar Lunar VM image

## Requirements

On an Ubuntu system:

$ sudo snap install --classic snapcraft
$ sudo snap install --classic ubuntu-image
$ sudo apt install squashfs-tools qemu-kvm qemu-utils ovmf zip

## Build

$ ./build.sh

## Run on qemu

$ ./run.sh build/pc.img
