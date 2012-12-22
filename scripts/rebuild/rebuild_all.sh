#!/bin/bash

[[ $# -ge 1 ]] || { echo "Usage: $0 <os> [os [...]]"; exit -1; }

if hash parallel 2>/dev/null; then
	parallel -u -j0 ./rebuild_one.sh ::: "$@"
else
	for OS in "$@"; do
		./rebuild_one.sh "$OS"
	done
fi
