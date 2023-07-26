# Workdir

This directory is used to setup and test Unikraft applications.
It facilitates large scale testing of multiple applications with common setups.
It is designed to make it easy to test open pull requests (PRs) as part of the review process to ensure they work.

It consists of mostly scripts that are to be run at different stages: setting up, updating the setup, customizing the setup, building, running, cleaning up.

## Setting Up

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

Customizing the setup refers to creating branches for different repositories.
This is done by using the `checkout-prs.sh` script in each repository: `unikraft`, app repositories, lib repositories:

```console
cd apps/<app-name>/
./checkout-prs.sh
```

By itself, the script will complain that it requires a `pr_list.inc` file:

```text
No pr_list.inc file. Aborting.
```

The `pr_list.inc` file will define a `pr_list` Bash variable filled with the PR ids that you require:

```bash
pr_list="65 64 63 61 60 59 55 54 52"
```

You can generate this file by hand, or you can use a predefined one in the `copy/base/` directory.

**Note**: Because PR ids are transient (they will eventually get merged), we don't keep `pr_list.inc` files in the main branch (`staging`) of this repository.
Rather, we will have temporary branches that we switch to that fill the `copy/base/` directory with the relevant `pr_list.inc` files.
The temporary branch will have a short span, very likely between two releases, until the PRs get merged.

So, after deciding to use a given set or predefined PRs, switch to the corresponding branch and then run the `fill-workdir.sh` script to populate the repositories with the `pr_list.inc` files.

## Preparing the Build Environment

Inside each application directory, use the `make-hierarchy.sh` script to prepare the directory structure:

```
./make-hierarchy.sh
```

This will create a `.unikraft/` directory where the `unikraft` and the library repositories are added as symbolic links.

You will get a hint to run the command below to validate the environment:

```
tree -a .unikraft/
```

## Building

TODO

## Running

TODO
