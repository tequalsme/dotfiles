#!/bin/sh

# Perform maintenance on a git repo
# e.g. find ~/src/ -name .git -type d -execdir ~/bin/git-maint.sh {} +

git fetch --all --prune && git gc --auto
