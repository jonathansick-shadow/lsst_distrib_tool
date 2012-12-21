#!/bin/bash

NEWINSTALL="$(pwd)/newinstall.sh"
test -f "$NEWINSTALL" || { echo "No newinstall.sh script!"; exit -1; }

OS=rhel-6-x86_64
rm -rf "../$OS"
mkdir "../$OS" || exit -1

unset LSST_HOME EUPS_PATH LSST_DEVEL

export NCORES=$((sysctl -n hw.ncpu || (test -r /proc/cpuinfo && grep processor /proc/cpuinfo | wc -l) || echo 2) 2>/dev/null)
export MAKEFLAGS="-j $NCORES"
export SCONSFLAGS="-j $NCORES"





(
	cd ../$OS
	bash "$NEWINSTALL"

	source loadLSST.sh

	eups distrib install --nolocks -t "$1" lsst_distrib
	eups distrib install --nolocks lsst_distrib_tool "$2"

	python -m compileall -x ".*/\.tests/.*" . | grep -v "Listing"

	echo "$OS" > .os
)
