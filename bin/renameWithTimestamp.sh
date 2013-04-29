#!/bin/sh

set -e

if [ $# -ne 1 ]; then
    echo "Usage: $0 filename"
    echo "Renames the given file with a timestamp (millis) extension"
    exit 1
elif [ ! -f "${1}" ]; then
    echo "${1} does not exist, exiting"
    exit 1
fi

TS=`stat -c "%Y" ${1}`

echo "Moving from ${1} to ${1}.${TS}"
mv ${1} ${1}.${TS}
