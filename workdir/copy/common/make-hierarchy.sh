#!/bin/bash

if test -d .unikraft; then
    echo " * .unikraft/ already exists. Not creating."
else
    echo " * Creating .unikraft/ ..."
    mkdir .unikraft
fi

echo " * Adding .unikraft/unikraft/ as symlink ..."
cd .unikraft
ln -sfn ../../../unikraft .

if test -d libs; then
    echo " * .unikraft/libs/ already exists. Not creating."
else
    echo " * Creating .unikraft/libs/ ..."
    mkdir libs
fi

echo " * Adding .unikraft/libs/*/ as symlinks ..."
cd libs
for l in ../../../../libs/*/; do
    ln -sfn "$l" .
done

cd ../..

echo ""
echo "Use this command to validate:"
echo ""
echo "    tree .unikraft/"
