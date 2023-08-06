#!/bin/bash

rm /tmp/firecracker.socket
firecracker-x86_64 \
    --api-sock /tmp/firecracker.socket \
    --config-file helloworld-cpp-fc-x86_64.json
