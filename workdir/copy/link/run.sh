#!/bin/sh

plat=""
arch=""
fs=""
net=0
kvm=0
root=0
extra_boot_args=""

prepare_initrd()
{
    cd fs0
    find -depth -print | tac | bsdcpio -o --format newc > ../fs0.cpio
    cd ..
}


prepare_qemu_net()
{
    sudo ip link set dev virbr0 down 2> /dev/null
    sudo ip link del dev virbr0 2> /dev/null
    sudo ip link add dev virbr0 type bridge
    sudo ip address add 172.44.0.1/24 dev virbr0
    sudo ip link set dev virbr0 up
}

prepare_fc_net()
{
    sudo ip link set dev tap0 down 2> /dev/null
    sudo ip link del dev tap0 2> /dev/null
    sudo ip tuntap add dev tap0 mode tap
    sudo ip address add 172.45.0.1/24 dev tap0
    sudo ip link set dev tap0 up
}

run_qemu()
{
    if test "$arch" = "aarch64"; then
        cmd="qemu-system-aarch64 -kernel $kernel_image -nographic -machine virt -cpu max"
    elif test "$arch" = "x86_64"; then
        cmd="qemu-system-x86_64 -kernel $kernel_image -nographic"
        if test "$kvm" -eq 1; then
            cmd="$cmd -enable-kvm -cpu host"
        fi
    fi
    if test "$net" -eq 1; then
        prepare_qemu_net
        cmd="$cmd -netdev bridge,id=en0,br=virbr0 -device virtio-net-pci,netdev=en0 -append \"netdev.ip=172.44.0.2/24:172.44.0.1 -- $extra_boot_args\""
    elif test ! -z "$extra_boot_args"; then
        cmd="$cmd -append \"-- $extra_boot_args\""
    fi
    if test "$fs" = "initrd"; then
        prepare_initrd
        cmd="$cmd -initrd fs0.cpio"
    fi
    if test "$fs" = "9pfs"; then
        cmd="$cmd -fsdev local,id=myid,path=$(pwd)/fs0,security_model=none -device virtio-9p-pci,fsdev=myid,mount_tag=fs0,disable-modern=on,disable-legacy=off"
    fi

    if test "$root" -eq 1; then
        cmd="sudo $cmd"
    fi
    echo "Running command:"
    echo "$cmd"
    eval "$cmd"
}

prepare_fc_json()
{
    cp ../../copy/common-nocopy/fc_template.json fc.json
    sed -i "s|__KERNEL_IMAGE__|$kernel_image|g" fc.json
    boot_args=""
    network_interfaces=""
    if test "$net" -eq 1; then
        prepare_fc_net
        boot_args="netdev.ipv4_addr=172.45.0.2 netdev.ipv4_gw_addr=172.45.0.1 netdev.ipv4_subnet_mask=255.255.255.0 --"
        network_interfaces='{"iface_id": "net1", "guest_mac":  "06:00:ac:10:00:02", "host_dev_name": "tap0"}'
    fi
    sed -i "s/__NETWORK_INTERFACES__/$network_interfaces/g" fc.json
    if test ! -z "$extra_boot_args"; then
        boot_args="$boot_args $extra_boot_args"
    fi
    if test ! -z "$boot_args"; then
        sed -i "/kernel_image_path/s/$/,/" fc.json
        sed -i "/kernel_image_path/a     \"boot_args\": \"$boot_args\"" fc.json
        if test "$fs" = "initrd"; then
            sed -i "/boot_args/s/$/,/" fc.json
            sed -i "/boot_args/a     \"initrd_path\": \"fs0.cpio\"" fc.json
        fi
    elif test "$fs" = "initrd"; then
        sed -i "/kernel_image_path/s/$/,/" fc.json
        sed -i "/kernel_image_path/a     \"initrd_path\": \"fs0.cpio\"" fc.json
    fi
}

run_fc()
{
    prepare_fc_json
    if test "$fs" = "initrd"; then
        prepare_initrd
    fi

    > /tmp/firecracker.log
    rm -f /tmp/firecracker.socket
    if test "$arch" = "aarch64"; then
        cmd="firecracker-aarch64"
    elif test "$arch" = "x86_64"; then
        cmd="firecracker-x86_64"
    fi
    cmd="$cmd --api-sock /tmp/firecracker.socket --config-file fc.json"

    if test "$root" -eq 1; then
        cmd="sudo $cmd"
    fi
    echo "Running command:"
    echo "$cmd"
    eval "$cmd"
}

name=$(basename "$0" .sh | sed 's/^run\-//')

echo "$name" | grep "qemu\-" > /dev/null 2>&1
if test $? -eq 0; then
    plat="qemu"
else
    echo "$name" | grep "fc\-" > /dev/null 2>&1
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
    kernel_image="$(ls build/*-arm64 2> /dev/null)"
else
    echo "$name" | grep "\-x86_64" > /dev/null 2>&1
    if test $? -eq 0; then
        arch="x86_64"
        kernel_image="$(ls build/*-x86_64 2> /dev/null)"
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

if test -f "requires_net"; then
    net=1
    root=1
fi
if test -f "requires_kvm"; then
    kvm=1
    if test "$plat" = "qemu"; then
        root=1
    fi
fi
if test -f "uses_paging"; then
    if test "$plat" = "qemu"; then
        root=1
        kvm=1
    fi
fi
if test -f "extra_boot_args"; then
    extra_boot_args=$(cat "extra_boot_args")
fi

if test "$#" -eq 1; then
    kernel_image="$1"
fi

if test ! -f "$kernel_image"; then
    echo "Kernel image not found: $kernel_image" 1>&2
    exit 1
fi

if test "$plat" = "qemu"; then
    run_qemu
elif test "$plat" = "fc"; then
    run_fc
fi
