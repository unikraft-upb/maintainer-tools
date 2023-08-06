#!/bin/bash

make distclean
config=$(ls $(pwd)/.config.*-qemu-aarch64)
UK_DEFCONFIG=$config make defconfig
make prepare
make -j $(nproc)
