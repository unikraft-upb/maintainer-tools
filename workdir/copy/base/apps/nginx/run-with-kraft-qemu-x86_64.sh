#!/bin/bash

RUNTIME_DIR=$HOME/.local/runtime

rm -fr $RUNTIME_DIR
mkdir $RUNTIME_DIR

~/kraftkit/dist/kraft run -W --runtime-dir $RUNTIME_DIR --target nginx-qemu-x86_64-initrd --initrd ./fs0 -p 8080:80
