#!/bin/bash
#
# Release a new version of the distrib tool, and install it into the binary
# distributions, all in one go. See the README for step-by-step explanation.
#

set -e

./release_distrib_tool_package.sh

(
  cd rebuild &&
  source ../../etc/config.sh &&
  ./exec_cmd.sh "eups distrib install --nolocks lsst_distrib_tool $DISTRIB_TOOL_VER" $DISTROS
  ./exec_cmd.sh "eups declare -c lsst_distrib_tool $DISTRIB_TOOL_VER" $DISTROS
)

./release_distrib_tool_webscript.sh

(
  cd rebuild &&
  source ../../etc/config.sh &&
  ./rsync_distros.sh $DISTROS
)
