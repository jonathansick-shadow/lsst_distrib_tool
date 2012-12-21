#!/bin/bash

[[ $# -ge 1 ]] || { echo "Usage: $0 <os> [os] [...]"; exit -1; }

. config.sh

for OS in "$@"; do
	HOST=$(head -n1 "$OS/host")

	echo -n "rsyncing from $HOST:/opt/lsst/$OS to $DISTURL/$OS... "
	ssh -CA $HOST "rsync -azH /opt/lsst/$OS $DISTURL"
	echo "done."
done
