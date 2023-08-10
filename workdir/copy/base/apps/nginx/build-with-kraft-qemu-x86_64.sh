#!/bin/bash

rm -fr .unikraft/build
~/kraftkit/dist/kraft build -t nginx-qemu-x86_64-initrd -j $(nproc)
