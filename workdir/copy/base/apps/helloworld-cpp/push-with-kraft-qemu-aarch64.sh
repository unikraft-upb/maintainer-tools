#!/bin/bash

RUNTIME_DIR=$HOME/.local/kraftkit/runtime
REPO_NAME=helloworld-cpp-qemu-aarch64:latest

kraft pkg push --log-level trace --log-type basic --as oci --runtime-dir $RUNTIME_DIR index.unikraft.io/unikraft.org/$REPO_NAME
