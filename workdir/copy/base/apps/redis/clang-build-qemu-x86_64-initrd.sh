#!/bin/bash

make distclean
config=$(ls $(pwd)/.config.*-qemu-x86_64-initrd)
UK_DEFCONFIG=$config make defconfig
make prepare
make CC=clang -j $(nproc)
