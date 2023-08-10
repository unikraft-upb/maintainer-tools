#!/bin/bash

RUNTIME_DIR=$HOME/.local/runtime

rm -fr $RUNTIME_DIR
mkdir $RUNTIME_DIR

~/kraftkit/dist/kraft run --log-level debug --log-type basic --runtime-dir $RUNTIME_DIR --target redis-qemu-x86_64-initrd --initrd ./fs0 -p 6379:6379 -- /redis.conf
