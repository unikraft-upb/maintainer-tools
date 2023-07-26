#!/bin/sh

kernel_image="build/lua_qemu-x86_64"

if test $# -eq 1; then
    kernel_image="$1"
fi

cd fs0
find -depth -print | tac | bsdcpio -o --format newc > ../fs0.cpio
cd ..

qemu-system-x86_64 \
    -kernel "$kernel_image" -nographic \
    -initrd fs0.cpio \
    -append "-- /helloworld.lua"
