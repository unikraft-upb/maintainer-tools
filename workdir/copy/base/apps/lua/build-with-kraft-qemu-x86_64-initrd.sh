#!/bin/bash

rm -fr .unikraft/build
kraft build -t lua-qemu-x86_64-initrd -j $(nproc)
