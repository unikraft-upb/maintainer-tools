#!/bin/bash

if test -d unikraft; then
    echo "unikraft exists. Not cloning."
else
    echo " * Cloning unikraft ..."
    git clone https://github.com/unikraft/unikraft unikraft
fi

pushd apps > /dev/null 2>&1
./clone-all.sh
popd > /dev/null 2>&1

pushd libs > /dev/null 2>&1
./clone-all.sh
popd > /dev/null 2>&1

cp -r copy/base/* .

apps=(apps/*/)
for a in ${apps[@]}; do
    cp copy/common/checkout-prs.sh "$a"
    cp copy/common/make-hierarchy.sh "$a"
done

libs=(libs/*/)
for l in ${libs[@]}; do
    cp copy/common/checkout-prs.sh "$l"
done

cp copy/common/checkout-prs.sh unikraft/
