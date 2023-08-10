#!/bin/bash

make distclean
config=$(ls $(pwd)/.config.*-qemu-aarch64-initrd)
UK_DEFCONFIG=$config make defconfig
make CC=clang LD=aarch64-linux-gnu-gcc OBJCOPY=aarch64-linux-gnu-objcopy STRIP=aarch64-linux-gnu-strip prepare
make CC=clang LD=aarch64-linux-gnu-gcc OBJCOPY=aarch64-linux-gnu-objcopy STRIP=aarch64-linux-gnu-strip -j $(nproc)
