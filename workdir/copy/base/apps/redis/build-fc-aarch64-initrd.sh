#!/bin/bash

make distclean
config=$(ls $(pwd)/.config.*-fc-aarch64-initrd)
UK_DEFCONFIG=$config make defconfig
make prepare
make -j $(nproc)
