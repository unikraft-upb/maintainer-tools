#!/bin/bash

RUNTIME_DIR=$HOME/.local/kraftkit/runtime
REPO_NAME=sqlite-qemu-aarch64:latest

~/kraftkit/dist/kraft pkg push --as oci --runtime-dir $RUNTIME_DIR index.unikraft.io/unikraft.org/$REPO_NAME
