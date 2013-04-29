#!/bin/sh

# Displays total commit lines per author.
# Pipe to grep to only show/hide certain authors.

git ls-files | \
  xargs -n1 -d'\n' -i git blame {} | \
  perl -n -e '/\s\((.*?)\s[0-9]{4}/ && print "$1\n"' | sort -f | uniq -c -w3 | \
  sort -rg
