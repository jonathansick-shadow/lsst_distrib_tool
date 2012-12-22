#!/bin/bash
#
# Release a new version to the package server. Will create the necessary
# directories, tarball, manifest and table file.
#

set -e

. config.sh

echo "Releasing $DISTRIB_TOOL_TAG as $DISTRIB_TOOL_VER"

DIR="$PKGDIR/$DISTRIB_TOOL_TAG"

git show-ref -q "$DISTRIB_TOOL_TAG" || { echo "Ref $DISTRIB_TOOL_TAG does not exist in the current repository"; exit -1; }

sw "mkdir -p $DIR"
sw "cat > $DIR/b1.manifest" <<EOF;
EUPS distribution manifest for lsst_distrib_tool ($DISTRIB_TOOL_VER). Version 1.0
#
# Creator:      Mario Juric
# pkg             flavor  version   tablefile                                         installation_directory      installID
#---------------------------------------------------------------------------------------------------------
lsst_distrib_tool generic $DISTRIB_TOOL_VER lsst_distrib_tool/$DISTRIB_TOOL_TAG/lsst_distrib_tool.table lsst_distrib_tool/$DISTRIB_TOOL_VER lsstbuild:lsst_distrib_tool/$DISTRIB_TOOL_TAG/lsst_distrib_tool-$DISTRIB_TOOL_TAG.tar.gz
EOF
sw "cd $DIR && (git archive --format=tar --prefix=lsst_distrib_tool-$DISTRIB_TOOL_TAG/ --remote=$REPO $DISTRIB_TOOL_TAG | gzip > lsst_distrib_tool-$DISTRIB_TOOL_TAG.tar.gz)"
sw "cd $DIR && (tar xzf lsst_distrib_tool-$DISTRIB_TOOL_TAG.tar.gz lsst_distrib_tool-$DISTRIB_TOOL_TAG/ups/lsst_distrib_tool.table --strip-components=2)"
sw "cd $DIR && (cp $DIR/b1.manifest ../../manifests/lsst_distrib_tool-$DISTRIB_TOOL_VER.manifest)"
sw "setup devenv_servertools && synctostd"
