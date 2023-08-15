#!/bin/bash

generate_gcc_x86_64_links()
{
    for v in $(compgen -A command gcc | grep 'gcc-[0-9]\+' | sort -u); do
        ln -sfn ../../copy/link/build.sh "$v"-build-"$name".sh
    done
}

generate_gcc_aarch64_links()
{
    for v in $(compgen -A command aarch64-linux-gnu-gcc | grep -o 'gcc-[0-9]\+' | sort -u); do
        ln -sfn ../../copy/link/build.sh "$v"-build-"$name".sh
    done
}

generate_clang_links()
{
    for v in $(compgen -A command clang | grep 'clang-[0-9]\+' | sort -u); do
        ln -sfn ../../copy/link/build.sh "$v"-build-"$name".sh
    done
}

for f in .config.*-*; do
    name=$(echo "$f" | grep -o '\(fc\|qemu\|xen\|vmware\|hyperv\)\-.*$')
    echo "$name"
    echo "$name" | grep "\-x86_64" > /dev/null 2>&1
    if test $? -eq 0; then
        generate_gcc_x86_64_links
    else
        generate_gcc_aarch64_links
    fi
    generate_clang_links
    echo "$name" | grep '^[^\-]*-[^\-]*$' > /dev/null 2>&1
    if test $? -eq 0; then
        ln -sfn ../../copy/link/run.sh run-"$name".sh
    else
	echo "$name" | grep '\(\-9pfs\|\-initrd\)' > /dev/null 2>&1
        if test $? -eq 0; then
            new_name=$(echo "$name" | sed 's/^\([^\-]*-[^\-]*-[^\-]*\).*$/\1/')
            ln -sfn ../../copy/link/run.sh run-"$new_name".sh
        fi
    fi
done
