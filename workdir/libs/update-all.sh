#!/bin/bash

. ./lib_list.inc

for l in $list; do
    if test ! -d "$l"; then
        echo "$l doesn't exists. Clone first."
        continue
    fi
    echo "* Updating $l ..."
    pushd "$l" > /dev/null 2>&1 || exit 1
    git checkout staging
    git fetch origin
    git rebase origin/staging
    popd > /dev/null 2>&1
done
