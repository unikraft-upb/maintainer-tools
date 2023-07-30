# Workdir

This directory is used to set up and test Unikraft applications.
It facilitates large scale testing of multiple applications with common setups.
It is designed to make it easy to test open pull requests (PRs) as part of the review process to ensure they work.

It consists of mostly scripts that are to be run at different stages: setting up, updating the setup, customizing the setup, building, running, cleaning up.

## Quick Use Guide (aka TLDR)

If you want to test a certain set of PRs, you would checkout the corresponding branch, such as `0.14-prs`.
You would use a command such as:

```console
git checkout 0.14-prs
```

Otherwise, you would use the latest `staging` versions of repositories.

Clone and populate the contents of all repositories using:

```console
./fill-workdir.sh
```

Build an application, such as `lua` by first entering the application directory:

```console
cd apps/lua/
```

There are multiple build scripts:

```console
[...]/workdir/apps/lua$ ls *build-*
build-fc-aarch64-initrd.sh  build-qemu-aarch64-initrd.sh  clang-build-fc-aarch64-initrd.sh  clang-build-qemu-aarch64-initrd.sh
build-fc-x86_64-initrd.sh   build-qemu-x86_64-9pfs.sh     clang-build-fc-x86_64-initrd.sh   clang-build-qemu-x86_64-9pfs.sh
build-qemu-aarch64-9pfs.sh  build-qemu-x86_64-initrd.sh   clang-build-qemu-aarch64-9pfs.sh  clang-build-qemu-x86_64-initrd.sh
```

Run one of the build scripts, such as:

```console
./build-qemu-x86_64-initrd.sh
```

Then run the corresponding run scripts to start a Unikraft instance:

```console
./run-qemu-x86_64-initrd.sh
```

## Setting Up

If you want to test a certain set of PRs, you would checkout the corresponding branch, such as `0.14-prs`.
You would use a command such as:

```console
git checkout 0.14-prs
```

Otherwise, you would use the latest `staging` versions of repositories.

Run the `fill-workdir.sh` to create the setup.
This will clone the repositories (unikraft, applications, libraries) and fill them with helper scripts and files:

```console
./fill-workdir.sh
```

Repositories are cloned, respectively, in `unikraft/`, in the `apps/` directory and in the `libs/` directory.

Helper scripts and files are part of the `copy/` directory.
Files in `copy/base/` are copied verbatim in the current workdir directory.
This gives a nice way of adding custom items to repositories **after** they've been cloned.
Files in `copy/common/` care duplicated in almost all repositories.
In `copy/base/` you have a specific file per directory, and the copying is something like `cp -r copy/base/* .`.
In `copy/common/` the files are common to all directories, and the copying is something like `for d in apps/*/; do cp copy/common/* "$d"; done`.
Scripts in `copy/common-nocopy/` are to be used / called directly in this location, without being copied to specific directories.

Scripts are then run.
In the end, the entire environment is ready for building and running applications.

## Building Applications

### Make-based Application Builds

Applications are built using the `build` scripts in the application directory.
There are multiple scripts, each for a specific environment.
Variations of the environment are:

* Architecture: x86_64 or AArch64
* Platform (hypervisor / VMM): QEMU-KVM, Firecracker-KVM, Xen etc.
* Filesystem: 9pfs or initrd
* Compiler toolchain: GCC or LLVM / Clang

For example, for `app/lua/`, the build script are:

```console
[...]/workdir/apps/lua$ ls *build-*
build-fc-aarch64-initrd.sh  build-qemu-aarch64-initrd.sh  clang-build-fc-aarch64-initrd.sh  clang-build-qemu-aarch64-initrd.sh
build-fc-x86_64-initrd.sh   build-qemu-x86_64-9pfs.sh     clang-build-fc-x86_64-initrd.sh   clang-build-qemu-x86_64-9pfs.sh
build-qemu-aarch64-9pfs.sh  build-qemu-x86_64-initrd.sh   clang-build-qemu-aarch64-9pfs.sh  clang-build-qemu-x86_64-initrd.sh
```

For example, to build the QEMU image for x86_64 using `initrd` as a filesystem, use:

```console
./build-qemu-x86_64-initrd.sh
```

### Kraftkit-based Application Builds

Applications can be built using KraftKit.
Before building an application with KraftKit, it's safest to clean up the build directory:

```console
rm -fr .unikraft/build/
```

Then, use the command below:

```console
kraft build -j $(nproc)
```

You will be prompted with a set of options to select the build target:

```text
[?] select target:
  ▸ lua-fc-arm64-initrd (fc/arm64)
    lua-fc-x86_64-initrd (fc/x86_64)
    lua-qemu-arm64-9pfs (qemu/arm64)
    lua-qemu-arm64-initrd (qemu/arm64)
    lua-qemu-x86_64-9pfs (qemu/x86_64)
    lua-qemu-x86_64-initrd (qemu/x86_64)
```

Select one of them and obtain the corresponding Unikraft image.

**Note**: Currently, KraftKit doesn't support 9pfs.
When using Kraftkit, aim for the `-initrd` targets.

## Running Applications

### Make-based Builds

To run applications, use the corresponding run script in the application directory:

```console
[...]/workdir/apps/lua$ ls run-*
run-fc-x86_64-initrd.sh  run-qemu-aarch64-9pfs.sh  run-qemu-aarch64-initrd.sh  run-qemu-x86_64-9pfs.sh  run-qemu-x86_64-initrd.sh
```

For example, to run the QEMU image for x86_64 using `initrd` as a filesystem, use:

```console
./run-qemu-x86_64-initrd.sh
```

### KraftKit-based Builds

To run applications with KraftKit, use `kraft run`.
For the sample `initrd` build (e.g. `lua-qemu-x86_64-initrd`) above, use:

```console
kraft run --initrd fs0.cpio "/helloworld.lua"
```

## Cleaning Up

Use the `cleanup-workdir.sh` script to clean up the workdir:

```console
./cleanup-workdir.sh
```

This removes all repositories cloned, together with helper scripts and files copied.

As files will be lost, running the script gives you a prompt to confirm your choice.

## Updating the Setup

At any point in time, you can run the `fill-workdir.sh` script to recreate removed repositories or to restore helper scripts and files.

In case library or application repositories have been updated upstream and you require them updated locally, run the `update-all.sh` script in the `apps/` or in the `libs/` directory.

## Customizing the Setup

Customizing the setup refers to creating custom branches for different repositories.
It's easiest to use the `checkout-prs.sh` script in this top-level folder.
Running it without arguments will show a sample use case:

```console
$ ./checkout-prs.sh 
Usage: ./checkout-prs.sh <pr-list>

e.g. ./checkout-prs.sh unikraft/1001 lib-musl/20 unikraft/1000 app-lua/10
will pull PRs 1001 and 1000 from the unikraft core, PR 20 from lib-musl and PR 10 form app-lua.
```

Each argument is the repository name and the PR ID to checkout.
The same repository name can appear multiple times to integrate multiple PRs.

After this, each repository will be checkout to a branch with corresponding PRs integrated.

### Fine-grained Manual Customization

If you want more control, you can use the `checkout-prs.sh` script in each repository: `unikraft`, app repositories, lib repositories.
`checkout-prs.sh` scripts make use of a `pr_list.inc` file that lists required PRs:

A sample file `pr_list.inc` file is:

```bash
pr_list="65 64 63 61 60 59 55 54 52"
```

The `pr_list.inc` file will define a `pr_list` Bash variable filled with the PR ids that you require.

You would then run the script:

```console
./checkout-prs.sh
```

At the end of the script run, the `work` branch will be created, with the PRs integrated.

By itself, the script will complain that it requires a `pr_list.inc` file:

```text
No pr_list.inc file. Aborting.
```

Typically, `pr_list.inc` files are created by the `fill-workdir.sh` script when part of a PR testing branch (such as `0.14-prs`).
And it is updated by the top-level `checktou-prs.sh` script.
You can create / edit this file by hand in each repository, according to your needs.

**Note**: Because PR ids are transient (they will eventually get merged), we don't keep `pr_list.inc` files in the main branch (`staging`) of this repository.
Rather, we will have temporary branches (such as `0.14-prs`) that we switch to that fill the `copy/base/` directory with the relevant `pr_list.inc` files.
The temporary branch will have a short span, very likely between two releases, until the PRs get merged.
