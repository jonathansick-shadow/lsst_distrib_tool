#!/bin/bash

NEWINSTALL="$(pwd)/newinstall.sh"
test -f "$NEWINSTALL" || { echo "No newinstall.sh script!"; exit -1; }

OS=rhel-5-x86_64
rm -rf "../$OS"
mkdir "../$OS" || exit -1

unset LSST_HOME EUPS_PATH LSST_DEVEL

export NCORES=$((sysctl -n hw.ncpu || (test -r /proc/cpuinfo && grep processor /proc/cpuinfo | wc -l) || echo 2) 2>/dev/null)
export MAKEFLAGS="-j $NCORES"
export SCONSFLAGS="-j $NCORES"




(
	cd ../$OS
	bash "$NEWINSTALL"

	# Note: this should really go in newinstall.sh, or the lsst package
	(
	cat <<-"EOF"
		# Multi-core settings
		export NCORES=$(((test -r /proc/cpuinfo && grep processor /proc/cpuinfo | wc -l) || echo 2) 2>/dev/null)
		export MAKEFLAGS="-j $NCORES"
		export SCONSFLAGS="-j $NCORES"
	EOF
	) | tee -a loadLSST.sh | tee -a loadLSST.zsh > /dev/null
	(
	cat <<-"EOF"
		# Multi-core settings
		setenv NCORES `(test -r /proc/cpuinfo && grep processor /proc/cpuinfo | wc -l) || echo 2`
		setenv MAKEFLAGS "-j $NCORES"
		setenv SCONSFLAGS "-j $NCORES"
	EOF
	) | tee -a loadLSST.csh > /dev/null

	source loadLSST.sh

	eups distrib install --nolocks rhel5_gcc44 4.4
	setup rhel5_gcc44

	(
	cat <<-"EOF"
		setup rhel5_gcc44
	EOF
	) | tee -a loadLSST.sh | tee -a loadLSST.zsh | tee -a loadLSST.csh > /dev/null

	eups distrib install --nolocks -t "$1" lsst_distrib
	eups distrib install --nolocks lsst_distrib_tool "$2"

	python -m compileall -x ".*/\.tests/.*" . | grep -v "Listing"

	echo "$OS" > .os
)
