#!/bin/bash

NEWINSTALL="$(pwd)/newinstall.sh"
test -f "$NEWINSTALL" || { echo "No newinstall.sh script!"; exit -1; }

OS=osx-10.8-x86_64
##rm -rf "../$OS"
##mkdir "../$OS" || exit -1

unset LSST_HOME EUPS_PATH LSST_DEVEL

##export NCORES=$((sysctl -n hw.ncpu || (test -r /proc/cpuinfo && grep processor /proc/cpuinfo | wc -l) || echo 2) 2>/dev/null)
##export MAKEFLAGS="-j $NCORES"
##export SCONSFLAGS="-j $NCORES cc=clang"

##export LANG=C
##export CC=clang
##export CXX=clang++

(
	cd ../$OS
	bash "$NEWINSTALL"

	# Note: this should really go in newinstall.sh, or the lsst package
	(
	cat <<-"EOF"
		# Mac-specific compiler settings
		export NCORES=$((sysctl -n hw.ncpu || echo 2) 2>/dev/null)
		export MAKEFLAGS="-j $NCORES"
		export SCONSFLAGS="-j $NCORES cc=clang"
		export LANG=C
		export CC=clang
		export CXX=clang++
	EOF
	) | tee -a loadLSST.sh | tee -a loadLSST.zsh > /dev/null
	(
	cat <<-"EOF"
		# Mac-specific compiler settings
		setenv NCORES `sysctl -n hw.ncpu || echo 2`
		setenv MAKEFLAGS "-j $NCORES"
		setenv SCONSFLAGS "-j $NCORES cc=clang"
		setenv LANG C
		setenv CC clang
		setenv CXX clang++
	EOF
	) | tee -a loadLSST.csh > /dev/null

	source loadLSST.sh
	eups distrib install --nolocks -t "$1" lsst_distrib
	eups distrib install --nolocks lsst_distrib_tool "$2"

	python -m compileall -x ".*/\.tests/.*" . | grep -v "Listing"

	echo "$OS" > .os
)

#	rsync -azH osx-10.8-x86_64 moya.dev.lsstcorp.org:/var/www/html/dmstack/binaries/tmp
