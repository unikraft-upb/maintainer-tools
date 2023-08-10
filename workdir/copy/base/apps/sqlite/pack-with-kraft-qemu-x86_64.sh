#!/bin/bash

RUNTIME_DIR=$HOME/.local/kraftkit/runtime
REPO_NAME=sqlite-qemu-x86_64:latest

rm -fr $RUNTIME_DIR
mkdir $RUNTIME_DIR

~/kraftkit/dist/kraft pkg --runtime-dir $RUNTIME_DIR --as oci --name index.unikraft.io/unikraft.org/$REPO_NAME --with-kconfig
