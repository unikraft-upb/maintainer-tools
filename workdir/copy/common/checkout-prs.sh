#!/bin/bash

if ! test -f ./pr_list.inc; then
    echo "No pr_list.inc file. Not checking out." 1>&2
    exit 1
fi

. ./pr_list.inc

branch="work"

if test "$#" -eq 1; then
    branch="$1"
fi

echo "Using branch $branch"

git checkout staging
git branch -D "$branch"
git checkout -b "$branch"

for pr in $pr_list; do
    repository=$(gh pr view "$pr" --json headRepository | sed '/"name"/s/.*"\([^"]\+\)"}}$/\1/')
    login=$(gh pr view "$pr" --json headRepositoryOwner | sed '/"login"/s/.*"\([^"]\+\)"}}$/\1/')
    branch=$(gh pr view "$pr" --json headRefName | sed '/headRefName/s/.*"\([^"]\+\)"}$/\1/')
    git remote show | grep "^$login$" > /dev/null 2>&1
    if test $? -ne 0; then
        git remote add "$login" https://github.com/"$login"/"$repository"
    fi
    git fetch "$login"
    echo "* [$pr] $login/$branch"
    git merge --no-edit "$login"/"$branch" || exit 1
done
