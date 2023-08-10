#!/bin/bash

make distclean
config=$(ls $(pwd)/.config.*-qemu-aarch64-initrd)
UK_DEFCONFIG=$config make defconfig
make prepare
make -j $(nproc)
