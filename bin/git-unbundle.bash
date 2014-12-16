#!/bin/bash

# Helper script for 'git bundle'.
# Unbundles the file created by git-bundle.bash.

set -e

if [ $# -ne 1 ]; then
    echo "Usage: $0 <bundle>"
    exit 1
elif [ ! -f "$1" ]; then
    echo "$1 does not exist, exiting"
    exit 1
fi

bundle=$1
echo "Verifying bundle..."
git bundle verify "${bundle}"

read -e -p "Dry run only? (y/n) " dryRun
[[ -n "$dryRun" ]]

read -e -p "Does bundle represent a branch or tag? " refType
[[ "$refType" == "branch" || "$refType" == "tag" ]]

read -e -p "Branch/tag to unbundle? (e.g. master, dev/1.x) " bundleRefName
[[ -n "$bundleRefName" ]]

if [ "$refType" == "branch" ]; then
    read -e -p "Repository name where bundle was created (e.g. origin)? " bundleRepository
    [[ -n "$bundleRepository" ]]
    bundleRef="remotes/${bundleRepository}/${bundleRefName}"
else
    bundleRef="refs/tags/${bundleRefName}"
fi

read -e -p "Repository name to push to? (empty to create local branch only) " remoteRepository
if [ -n "$remoteRepository" ]; then
    read -e -p "Branch/tag to push to? (e.g. dev/2.1, release/1.2) " refName
    [[ -n "$refName" ]]

    if [ "$refType" == "branch" ]; then
        destRef="refs/heads/${refName}"
    else
        destRef="refs/tags/${refName}"
    fi
else
    read -e -p "Local branch to create? (e.g. dev/2.1, release/1.2) " destRef
    [[ -n "$destRef" ]]
fi

echo ""
echo "dryRun: $dryRun"
echo "bundle: $bundle"
echo "bundleRef: $bundleRef"
echo "remoteRepository: $remoteRepository"
echo "destRef: $destRef"
echo ""

execCommand() {
    if [ "$dryRun" != "y" ]; then
        echo "Executing '$1'"
        $1
    else
        echo "(dryrun) '$1'"
    fi
}

if [ -n "$remoteRepository" ]; then
    execCommand "git fetch ${bundle} ${bundleRef}"
    execCommand "git push ${remoteRepository} FETCH_HEAD:${destRef}"
else
    # could also do this in two steps:
    #execCommand "git fetch ${bundle} ${bundleRef}"
    #execCommand "git checkout -b ${destRef} FETCH_HEAD"
    # fetch directly to a local branch
    execCommand "git fetch ${bundle} ${bundleRef}:${destRef}"
fi

echo "Done."
