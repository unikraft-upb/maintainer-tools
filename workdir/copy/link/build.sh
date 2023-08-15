#!/bin/sh

comp=""
plat=""
arch=""
fs=""
extra=""

name=$(basename "$0" .sh)

echo "$name" | grep "^clang-\([0-9]\+\-\)\?" > /dev/null 2>&1
if test $? -eq 0; then
    comp=$(echo "$name" | grep -o "^clang-\([0-9]\+\-\)\?")
    comp=$(echo "$comp" | sed 's/\-$//')
else
    echo "$name" | grep "^gcc-\([0-9]\+\-\)\?" > /dev/null 2>&1
    if test $? -eq 0; then
        comp=$(echo "$name" | grep -o "^gcc-\([0-9]\+\-\)\?")
	comp=$(echo "$comp" | sed 's/\-$//')
    else
        echo "Unknown compiler" 1>&2
        exit 1
    fi
fi

echo "$name" | grep "\-qemu\-" > /dev/null 2>&1
if test $? -eq 0; then
    plat="qemu"
else
    echo "$name" | grep "\-fc\-" > /dev/null 2>&1
    if test $? -eq 0; then
        plat="fc"
    else
        echo "Unknown platform" 1>&2
        exit 1
    fi
fi

echo "$name" | grep "\-aarch64" > /dev/null 2>&1
if test $? -eq 0; then
    arch="aarch64"
else
    echo "$name" | grep "\-x86_64" > /dev/null 2>&1
    if test $? -eq 0; then
        arch="x86_64"
    else
        echo "Unknown architecture" 1>&2
        exit 1
    fi
fi

rest=$(echo "$name" | sed 's/^.*\-\(x86_64\|aarch64\)//')

if test ! -z "$rest"; then
    echo "$rest" | grep '^\-9pfs' > /dev/null 2>&1
    if test $? -eq 0; then
        fs="9pfs"
    else
        echo "$rest" | grep '^\-initrd' > /dev/null 2>&1
        if test $? -eq 0; then
            fs="initrd"
        fi
    fi
fi

if test -z "$fs"; then
    extra="$rest"
else
    extra=$(echo "$rest" | sed 's/^\-[^-]\+//')
fi

echo "comp: $comp"
echo "plat: $plat"
echo "arch: $arch"
echo "fs: $fs"
echo "extra: $extra"

config_suffix="$plat"-"$arch"
if test ! -z "$fs"; then
    config_suffix="$config_suffix"-"$fs"
fi
if test ! -z "$extra"; then
    config_suffix="$config_suffix""$extra"
fi

# Do actual build steps.
make distclean
config=$(ls $(pwd)/.config.*-"$config_suffix")
UK_DEFCONFIG=$config make defconfig
make prepare

# Use COMPILER variable for GCC, to add cross compiler prefix.
# Use CC variable for Clang.
echo "$comp" | grep '^gcc' > /dev/null 2>&1
if test $? -eq 0; then
   make COMPILER="$comp" -j $(nproc)
else
   make CC="$comp" -j $(nproc)
fi

if test "$arch" = "aarch64"; then
    ln -fn build/*-arm64 img-"$name"
elif test "$arch" = "x86_64"; then
    ln -fn build/*-x86_64 img-"$name"
fi
