#!/bin/bash

if test $# -lt 1; then
    echo -e "Usage: $0 <pr-list>\n" 1>&2
    echo -e "e.g. $0 unikraft/1001 lib-musl/20 unikraft/1000 app-lua/10" 1>&2
    echo "will pull PRs 1001 and 1000 from the unikraft core, PR 20 from lib-musl and PR 10 form app-lua."
    exit 1
fi

declare -A changes

for dep in "$@"; do
    lib=$(echo "$dep" | cut -d'/' -f1)
    pr=$(echo "$dep" | cut -d'/' -f2)

    if [[ "$lib" == "unikraft" ]]; then
        pushd "unikraft" > /dev/null || exit 1
        changes["unikraft"]=
    elif [[ "$lib" =~ ^lib-.* ]]; then
        ch_lib=$(echo "$lib" | cut -d'-' -f2-)
        changes["libs/$ch_lib"]=
        pushd "libs/$ch_lib" > /dev/null || exit 1
    elif [[ "$lib" =~ ^app-.* ]]; then
        ch_app=$(echo "$lib" | cut -d'-' -f2-)
        changes["apps/$ch_app"]=
        pushd "apps/$ch_app" > /dev/null || exit 1
    fi

    if test -a "pr_list.inc"; then
        sed -i "s/\"$/ $pr\"/g" pr_list.inc
    else
        echo "pr_list=\"$pr\"" > pr_list.inc
    fi

    popd > /dev/null || exit 1
done

for dep in "${!changes[@]}"; do
    pushd "$dep" > /dev/null || exit 1
    ./checkout-prs.sh
    popd > /dev/null || exit 1
done
