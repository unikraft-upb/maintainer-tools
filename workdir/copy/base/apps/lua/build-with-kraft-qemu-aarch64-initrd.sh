#!/bin/bash

rm -fr .unikraft/build
kraft build -t lua-qemu-aarch64-initrd -j $(nproc)
