#!/bin/bash

rm -fr .unikraft/build
~/kraftkit/dist/kraft build -t redis-qemu-aarch64-initrd -j $(nproc)
