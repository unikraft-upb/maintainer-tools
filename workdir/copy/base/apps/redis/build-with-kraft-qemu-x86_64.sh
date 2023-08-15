#!/bin/bash

rm -fr .unikraft/build
kraft build -t redis-qemu-x86_64-initrd -j $(nproc)
