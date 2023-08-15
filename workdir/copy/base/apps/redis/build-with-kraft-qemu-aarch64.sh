#!/bin/bash

rm -fr .unikraft/build
kraft build -t redis-qemu-aarch64-initrd -j $(nproc)
