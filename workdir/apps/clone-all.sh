#!/bin/bash

. ./app_list.inc

for a in $app_list; do
    if test -d "$a"; then
        echo "$a exists. Not cloning."
        continue
    fi
    echo " * Cloning $a ..."
    git clone https://github.com/unikraft/app-"$a" "$a"
done
