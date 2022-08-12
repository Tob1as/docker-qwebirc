#!/bin/sh

set -eu

: "${HTML_COMPILE:="1"}"

cd /qwebirc

if [ "$HTML_COMPILE" -eq "1" ] ; then
    echo ">> compile the HTML/js/css from config.py settings"
    ./clean.py
    ./compile.py
fi

# exec CMD
echo ">> exec CMD: \"$@\""
exec "$@"
