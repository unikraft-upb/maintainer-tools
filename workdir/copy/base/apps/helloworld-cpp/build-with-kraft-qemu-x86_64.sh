#!/bin/bash

rm -fr .unikraft/build
kraft build --log-level debug --log-type basic --plat qemu --arch x86_64 -j $(nproc)
