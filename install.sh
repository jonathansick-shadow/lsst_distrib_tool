#!/bin/bash
#
# bash install.sh [version]
#

URLBASE=https://moya.lsst.majuric.org/dmstack/binaries
STACKVER=${1-latest}
ROOT=${2-/opt/lsst}

set -e

detectOS()
{
	OS=$(uname)
	MACH=$(uname -m)

	case $OS in
	"Darwin")
		OS=osx
		VER=$(sw_vers -productVersion | cut -d . -f 1-2)
		;;
	"Linux")
		if [ -f /etc/redhat-release ]; then
			OS="rhel_compatible"
			VER=$(cat /etc/redhat-release | sed -r 's/^.[^0-9.]*([0-9]*).*$/\1/')
		else
			echo "Unknown Linux flavor; please install from source."
		fi
	esac
	
	echo $OS-$VER-$MACH
}

## [[ -e $ROOT && ! -z $(ls -A "$ROOT") ]] && { echo "This script only does fresh installs, and $ROOT already has some content."; exit -1; }
mkdir -p $ROOT || { echo "Failed to create $ROOT. Have you forgotten to run this script as root?"; exit -1; }

OS=$(detectOS)

echo "Installing to $ROOT"
echo "Detected $OS. Hit CTRL-C if I'm wrong."

cd $ROOT

NAME="dmstack-$STACKVER-$OS.tar.bz2"
URL="$URLBASE/$NAME"
echo "Fetching tarball of binaries from $URL"
echo -n "Progress: "
## curl -\# -fLO "$URL"

echo "Extracting binaries."
tar xzf "$NAME"
mv lsst/* .
rmdir lsst
rm "$NAME"

echo "Done. The $STACKVER LSST Data Management stack has been installed in $ROOT."
