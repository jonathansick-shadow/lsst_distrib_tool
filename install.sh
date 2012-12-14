#!/bin/bash
#
# bash install.sh [version] [dest_dir]
#

if [[ $# > 2 || $1 == "--help" || $1 == "-h" ]]; then
	cat <<-EOF;
		Usage: $0 [version] [destdir]

		Clones a pre-built binary distribution of the LSST Data Management
		Software Stack.
	
		version		The version of the stack to install (defaults to
		                'latest')
		dest_dir	EXPERIMENTAL: Install the stack to <destdir>, rather
		                than the directory it was originally built in. This
		                is an experimental feature and may cause some
		                misbehavior.
EOF
	exit;
fi

DEFROOT=/opt/lsst
TRANSPORT=${TRANSPORT-rsync}

STACKVER=${1-latest}
ROOT=${2-$DEFROOT}

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

mkdir -p "$ROOT" || { echo "Failed to create $ROOT. Have you forgotten to run this script as root?"; exit -1; }
[[ -w "$ROOT" ]] || { echo "$ROOT is not writable. Have you forgotten to run this script as root?"; exit -1; }

OS=$(detectOS)

echo "Installing to $ROOT"
echo "Detected $OS. Hit CTRL-C if I'm wrong."

case "$TRANSPORT" in
"tarball")
	[[ -e $ROOT && ! -z $(ls -A "$ROOT") ]] && { echo "Only fresh installs are allowed from a tarball, and $ROOT already has some content."; exit -1; }

	NAME="dmstack-$STACKVER-$OS.tar.bz2"
	URLBASE="https://moya.lsst.majuric.org/dmstack/binaries"
	URL="$URLBASE/$NAME"

	echo "Installing from tarball (source: $URL)"
	curl -\# -fL "$URL" | tar xzf - -C "$ROOT"
	mv "$ROOT"/lsst/* .
	rmdir "$ROOT"/lsst
	;;
"rsync")
	NAME="dmstack-$OS"
	URLBASE="rsync://moya.dev.lsstcorp.org/dmstack/"
	URL="$URLBASE/$NAME/"

	echo "Installing using rsync (source: $URL)"
	#line0=""
	n=0
	rsync --out-format='%n %b/%l' -avz "$URL" "$ROOT" | 
	while read line; do
		n=$((n+1))
		[[ $((n % 1000)) == 0 ]] && { echo -n '#'; }
		#echo -n $'\r'; head -c ${#line0} < /dev/zero | tr '\0' ' '
		#echo -n $'\r'"$line"
		#line0="$line"
	done
	echo " ...done."
	;;
esac

exit

if [[ $ROOT != "$DEFROOT" ]]; then
	echo "Fixing up EUPS paths"
	( cd "$ROOT" && grep -Rl --exclude '*.pyc' --exclude '*~' "$DEFROOT" eups loadLSST.* | xargs sed -i \~ "s|$DEFROOT|$ROOT|" )
fi

echo "Done. The $STACKVER LSST Data Management stack has been installed in $ROOT."

