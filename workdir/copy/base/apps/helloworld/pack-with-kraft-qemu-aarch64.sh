#!/bin/bash

RUNTIME_DIR=$HOME/.local/kraftkit/runtime
REPO_NAME=helloworld-qemu-aarch64:latest

rm -fr $RUNTIME_DIR
mkdir $RUNTIME_DIR

kraft pkg --runtime-dir $RUNTIME_DIR --as oci --name index.unikraft.io/unikraft.org/$REPO_NAME --with-kconfig
