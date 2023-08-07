#!/bin/sh

kernel_image="build/lua_qemu-arm64"

if test $# -eq 1; then
    kernel_image="$1"
fi

qemu-system-aarch64 \
    -fsdev local,id=myid,path=$(pwd)/fs0,security_model=none \
    -device virtio-9p-pci,fsdev=myid,mount_tag=fs0,disable-modern=on,disable-legacy=off \
    -kernel "$kernel_image" -nographic \
    -append "-- /helloworld.lua" \
    -machine virt -cpu max
