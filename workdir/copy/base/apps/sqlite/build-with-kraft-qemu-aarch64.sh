#!/bin/bash

rm -fr .unikraft/build
~/kraftkit/dist/kraft build -t sqlite-qemu-aarch64-initrd -j $(nproc)
