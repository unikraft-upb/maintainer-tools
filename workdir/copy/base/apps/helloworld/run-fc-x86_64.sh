#!/bin/bash

rm /tmp/firecracker.socket
firecracker-x86_64 \
    --api-sock /tmp/firecracker.socket \
    --config-file helloworld-fc-x86_64.json
