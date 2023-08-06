#!/bin/sh

kernel_image="build/helloworld-cpp_qemu-arm64"

if test $# -eq 1; then
    kernel_image="$1"
fi

qemu-system-aarch64 \
    -kernel "$kernel_image" -nographic \
    -machine virt -cpu max
