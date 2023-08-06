#!/bin/bash

make distclean
config=$(ls $(pwd)/.config.*-fc-x86_64)
UK_DEFCONFIG=$config make defconfig
make prepare
make -j $(nproc)
