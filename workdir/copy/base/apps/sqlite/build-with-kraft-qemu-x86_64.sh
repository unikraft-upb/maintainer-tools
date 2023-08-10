#!/bin/bash

rm -fr .unikraft/build
~/kraftkit/dist/kraft build -t sqlite-qemu-x86_64-initrd -j $(nproc)
