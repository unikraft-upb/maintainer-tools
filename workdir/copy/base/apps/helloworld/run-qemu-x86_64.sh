#!/bin/sh

kernel_image="build/helloworld_qemu-x86_64"

if test $# -eq 1; then
    kernel_image="$1"
fi

qemu-system-x86_64 \
    -kernel "$kernel_image" -nographic
