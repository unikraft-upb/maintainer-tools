#!/bin/bash

rm -fr .unikraft/build
~/kraftkit/dist/kraft build --log-level debug --log-type basic --plat qemu --arch x86_64 -j $(nproc)
