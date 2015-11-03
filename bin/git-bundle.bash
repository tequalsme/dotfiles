#!/bin/bash

# Helper script for 'git bundle'.
# Supports tagging in order to only grab changes since the last bundle.

set -e

read -e -p "Dry run only? (y/n) " dryRun
[[ -n "$dryRun" ]]

read -e -p "Read-only (i.e. do not tag)? (y/n) " noTag
[[ -n "$noTag" ]]

read -e -p "Will bundle represent a branch or tag? " refType
[[ "$refType" == "branch" || "$refType" == "tag" ]]

read -e -p "Repository name? " repository
[[ -n "$repository" ]]

read -e -p "Branch/tag to bundle? (e.g. dev/2.1, release/1.2) " refToBundle
[[ -n "$refToBundle" ]]

read -e -p "Tag base to use? " tagBase
[[ -n "$tagBase" ]]

read -e -p "Hash to start from? ('-' for previous bundle of this branch/tag, empty for all commits) " startingPointName

tagName="${tagBase}/${refToBundle}"
[[ "$refType" == "branch" ]] && refToBundle="${repository}/${refToBundle}"

if [ -z "$startingPointName" ]; then
    startingPointName="epoch"
    refList="${refToBundle}"
elif [ "$startingPointName" == "-" ]; then
    startingPointName=`git ls-remote ${repository} refs/tags/${tagName} | cut -f1`
    refList="${startingPointName}..${refToBundle}"
else
    startingPointName=`git rev-parse ${startingPointName}`
    refList="${startingPointName}..${refToBundle}"
fi

# replace all '/' with '-'
safeRefName=${refToBundle////-}

echo ""
echo "dryRun: $dryRun"
echo "noTag: $noTag"
echo "refType: $refType"
echo "repository: $repository"
echo "refToBundle: $refToBundle"
echo "startingPointName: $startingPointName"
echo "tagName: $tagName"
echo "safeRefName: $safeRefName"
echo "refList: $refList"
echo ""

execCommand() {
    if [ "$dryRun" != "y" ]; then
        echo "Executing '$1'"
        $1
    else
        echo "(dryrun) '$1'"
    fi
}

execCommand "git fetch ${repository}"
execCommand "git bundle create bundle_${safeRefName}_from_${startingPointName} ${refList}"
if [ "$noTag" != "y" ]; then
    execCommand "git push -f ${repository} ${refToBundle}:refs/tags/${tagName}"
fi

echo "Done."
