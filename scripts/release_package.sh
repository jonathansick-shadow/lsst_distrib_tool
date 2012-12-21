#!/bin/bash
#
# Release a new version to the package server
#
# 	$0 tag
#

[[ $# == 1 ]] || { echo "Usage: $0 <tag>"; exit -1; }

GIT=git@git.lsstcorp.org:contrib/lsst_distrib_tool.git

set -e

T=$1
git show-ref -q "$T" || { echo "Ref $T does not exist in the current repository"; exit -1; }

sw() { ssh -CYA lsstsw@lsst-dev.ncsa.illinois.edu "$@"; }
DIR="/lsst/home/lsstsw/distrib/default/www/lsst_distrib_tool/$T"

sw "mkdir -p $DIR"
sw "cat > $DIR/b1.manifest" <<EOF;
EUPS distribution manifest for lsst_distrib_tool ($T+1). Version 1.0
#
# Creator:      Mario Juric
# pkg             flavor  version   tablefile                                         installation_directory      installID
#---------------------------------------------------------------------------------------------------------
lsst_distrib_tool generic $T+1 lsst_distrib_tool/$T/lsst_distrib_tool.table lsst_distrib_tool/$T+1 lsstbuild:lsst_distrib_tool/$T/lsst_distrib_tool-$T.tar.gz
EOF
sw "cd $DIR && (git archive --format=tar --prefix=lsst_distrib_tool-$T/ --remote=$GIT $T | gzip > lsst_distrib_tool-$T.tar.gz)"
sw "cd $DIR && (tar xzf lsst_distrib_tool-$T.tar.gz lsst_distrib_tool-$T/ups/lsst_distrib_tool.table --strip-components=2)"
sw "cd $DIR && (cp $DIR/b1.manifest ../../manifests/lsst_distrib_tool-$T+1.manifest)"
sw "setup devenv_servertools && synctostd"
