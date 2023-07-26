#!/bin/bash

. ./app_list.inc

for a in $app_list; do
    if test ! -d "$a"; then
        echo "$a doesn't exists. Clone first."
        continue
    fi
    echo "* Updating $a ..."
    pushd "$a" > /dev/null 2>&1 || exit 1
    git checkout staging
    git fetch origin
    git rebase origin/staging
    popd > /dev/null 2>&1
done
