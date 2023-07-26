#!/bin/bash

cd fs0
find -depth -print | tac | bsdcpio -o --format newc > ../fs0.cpio
cd ..

rm /tmp/firecracker.socket
firecracker-x86_64 \
    --api-sock /tmp/firecracker.socket \
    --config-file lua-fc-x86_64-initrd.json
