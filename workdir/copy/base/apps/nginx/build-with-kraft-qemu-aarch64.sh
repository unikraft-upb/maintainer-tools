#!/bin/bash

rm -fr .unikraft/build
~/kraftkit/dist/kraft build -t nginx-qemu-aarch64-initrd -j $(nproc)
