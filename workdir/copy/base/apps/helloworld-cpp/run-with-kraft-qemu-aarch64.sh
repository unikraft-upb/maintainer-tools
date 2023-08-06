#!/bin/bash

RUNTIME_DIR=$HOME/.local/runtime

rm -fr $RUNTIME_DIR
mkdir $RUNTIME_DIR

kraft run --runtime-dir $RUNTIME_DIR --plat qemu --arch arm64
