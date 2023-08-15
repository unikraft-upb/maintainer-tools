#!/bin/bash

RUNTIME_DIR=$HOME/.local/runtime

rm -fr $RUNTIME_DIR
mkdir $RUNTIME_DIR

kraft run --runtime-dir $RUNTIME_DIR --target redis-qemu-x86_64-initrd --initrd ./fs0 -p 6379:6379 -- /redis.conf
