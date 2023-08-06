#!/bin/bash

rm -fr .unikraft/build
kraft build --plat qemu --arch x86_64 -j $(nproc)
