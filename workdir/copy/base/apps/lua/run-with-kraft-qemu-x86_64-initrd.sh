#!/bin/bash

RUNTIME_DIR=$HOME/.local/runtime

rm -fr $RUNTIME_DIR
mkdir $RUNTIME_DIR

kraft run --runtime-dir $RUNTIME_DIR --initrd ./fs0 .unikraft/build/lua-qemu-x86_64-initrd_qemu-x86_64 -- /helloworld.lua
