#!/bin/bash

echo "This will remove cloned repositories and changes to them."
echo -n "Are you sure? [y/N] "
read ans

if test ! "$ans" = "y"; then
    echo "Aborting cleanup."
    exit 1
fi

echo ""
echo " * Removing unikraft ..."
rm -fr unikraft

echo " * Removing apps ..."
find apps -mindepth 1 -maxdepth 1 -type d -exec rm -fr {} \;

echo " * Removing libs ..."
find libs -mindepth 1 -maxdepth 1 -type d -exec rm -fr {} \;
