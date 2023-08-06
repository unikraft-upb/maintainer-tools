#!/bin/bash

rm -fr .unikraft/build
kraft build --plat qemu --arch arm64 -j $(nproc)
