#!/bin/bash

TARGET=lua-qemu-x86_64-initrd
RUNTIME_DIR=$HOME/.local/kraftkit/runtime
REPO_NAME=lua-qemu-x86_64:latest

rm -fr $RUNTIME_DIR
mkdir $RUNTIME_DIR

kraft pkg --runtime-dir $RUNTIME_DIR --target $TARGET --as oci --name index.unikraft.io/unikraft.org/$REPO_NAME --with-kconfig --args /helloworld.lua --initrd ./fs0
