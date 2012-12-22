#!/bin/bash
#
# Executed a command on host that builds the given OS. LSST/EUPS environment
# will be set up for the command.
#

[[ $# -ge 2 ]] || { echo "Usage: $0 <cmd> <os> [os] [...]"; exit -1; }

. ../config.sh

CMD="$1"
shift;

for OS in "$@"; do
	HOST=$(head -n1 "$OS/host")

	ssh $HOST "(source /opt/lsst/$OS/loadLSST.sh; $CMD)"
done
