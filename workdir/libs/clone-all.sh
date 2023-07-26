#!/bin/bash

. ./lib_list.inc

for l in $list; do
    if test -d "$l"; then
        echo "$l exists. Not cloning."
        continue
    fi
    echo " * Cloning $l ..."
    git clone https://github.com/unikraft/lib-"$l" "$l"
done
