#!/bin/bash

RUNTIME_DIR=$HOME/.local/kraftkit/runtime
REPO_NAME=nginx-qemu-aarch64:latest

~/kraftkit/dist/kraft pkg push --log-level trace --log-type basic --as oci --runtime-dir $RUNTIME_DIR index.unikraft.io/unikraft.org/$REPO_NAME
