#!/bin/sh

set -e

usage() {
    echo "Usage: $0 [-f] [-t] [-u] arg"
    echo "  Convert between milliseconds since epoch and readable string"
    echo "  If arg not supplied, uses current time."
    echo "  Options:"
    echo "    -f  from millis to readable string (default)"
    echo "    -t  from string to millis"
    echo "    -u  Use UTC (valid for -f only)"
    echo "Examples:"
    echo "  $0 1364821657000"
    echo "  $0 -t \"Mon Apr  1 07:19:35 EDT 2013\""
    exit 1
}

truncateMillisToSecs() {
    len=`echo "$1" | wc -m`
    if [ $len == 14 ]; then
        secs=`echo "$1" | cut -c1-10`
    else
        secs=$1
    fi
    echo "$secs"
}

from() {
    if [ -z "$ARG" ]; then
        date $UTC
    else
        secs=$(truncateMillisToSecs $ARG)
        date $UTC -d @"$secs"
    fi
}

to() {
    if [ -z "$ARG" ]; then
        secs=`date "+%s"`
    else
        secs=`date --date="$ARG" "+%s"`
    fi
    echo "${secs}000"
}

UTC=""

while getopts ":ftuh" opt; do
    case $opt in
        f)
        ;;
        t) TO=1
        ;;
        u) UTC="-u"
        ;;
        h)
        usage
        ;;
        \?) "Invalid option: -$OPTARG" >&2
        usage
        ;;
    esac
done

shift $((OPTIND-1))
ARG=$1

if [ -z "${TO+xxx}" ]; then
    from
else
    to
fi
