#!/bin/bash

RUNTIME_DIR=$HOME/.local/kraftkit/runtime
REPO_NAME=redis-qemu-aarch64:latest

kraft pkg push --as oci --runtime-dir $RUNTIME_DIR index.unikraft.io/unikraft.org/$REPO_NAME
