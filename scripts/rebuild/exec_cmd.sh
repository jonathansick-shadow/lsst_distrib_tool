#!/bin/bash

[[ $# -ge 2 ]] || { echo "Usage: $0 <cmd> <os> [os] [...]"; exit -1; }

. config.sh

CMD="$1"
shift;

for OS in "$@"; do
	HOST=$(head -n1 "$OS/host")

	ssh $HOST "(source /opt/lsst/$OS/loadLSST.sh; $CMD)"
done
