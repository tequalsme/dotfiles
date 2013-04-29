#!/bin/sh

# Displays total commit lines per file and author.
# Pipe to grep to only show/hide certain authors.

git ls-files | \
  xargs -n1 -d'\n' -i git blame {} | \
  perl -n -e '/\s\((.*?)\s[0-9]{4}/ && print "$1 $2\n"' | sort -f | uniq -c | \
  sort -rg
