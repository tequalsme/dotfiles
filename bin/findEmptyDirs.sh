#!/bin/sh

# TODO use find -prune just like rgrep

for i in `find . -type d`; do
    x=`ls -1 $i | wc -l`
    echo "$i : $x" | grep -v target | grep -v .git | grep " 0$"
done
