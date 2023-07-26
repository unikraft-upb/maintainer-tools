#!/bin/bash

mv Makefile.uk Makefile.uk.default
cp Makefile.uk.clang.aarch64 Makefile.uk

make distclean
config=$(ls $(pwd)/.config.*-qemu-aarch64-9pfs)
set -x
UK_DEFCONFIG=$config make defconfig
make CC=clang LD=aarch64-linux-gnu-gcc OBJCOPY=aarch64-linux-gnu-objcopy STRIP=aarch64-linux-gnu-strip prepare
make CC=clang LD=aarch64-linux-gnu-gcc OBJCOPY=aarch64-linux-gnu-objcopy STRIP=aarch64-linux-gnu-strip -j $(nproc)

mv Makefile.uk.default Makefile.uk
