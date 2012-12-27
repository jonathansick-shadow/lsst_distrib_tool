#!/bin/bash
#
# Copies lsst-distrib from the commit referenced by the tag
# into http://lsst-web.ncsa.illinois.edu/~lsstsw/lsst-distrib
#

set -e

. ../etc/config.sh

echo "Copying lsst-distrib from tag $DISTRIB_TOOL_TAG to ~lsstsw/lsst-distrib"

sw "mkdir -p ~/public_html && cd ~/public_html && git archive --format=tar --remote=$REPO $DISTRIB_TOOL_TAG bin/lsst-distrib | tar xf - --strip-components=1"
