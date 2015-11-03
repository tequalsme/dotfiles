#!/bin/sh

# Perform maintenance on a git repo
# e.g. find ~/src/ -name .git -type d -execdir ~/bin/git-maint.sh {} +

set -e

if [ $# -ne 1 ]; then
    echo "Usage: $0 dir"
    echo "Finds all git repos under the given base dir, and performs a fetch/prune"
    exit 1
elif [ ! -d "$1" ]; then
    echo "$1 is not a directory, exiting"
    exit 1
fi

for dir in `find $1 -name .git -type d`
do
    REPO="$dir/.."
    echo
    echo $REPO
    pushd $REPO > /dev/null
    git fetch --all --tags --prune
    git --no-pager l ..`git rev-parse --abbrev-ref @{u}`
    git merge --ff-only
    git gc --auto
    popd > /dev/null
done

