#!/bin/bash

RUNTIME_DIR=$HOME/.local/runtime

rm -fr $RUNTIME_DIR
mkdir $RUNTIME_DIR

~/kraftkit/dist/kraft run --runtime-dir $RUNTIME_DIR --target sqlite-qemu-aarch64-initrd --initrd fs0/
