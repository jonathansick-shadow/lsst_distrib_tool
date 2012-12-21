#!/bin/bash

[[ $# == 1 ]] || { echo "Usage: $0 <os>"; exit -1; }

. config.sh

OS="$1"
HOST=$(head -n1 "$OS/host")

echo "Building platform $OS on $HOST..."
rsync -az $OS/ $HOST:/opt/lsst/$OS.buildscripts || { echo "Failed to rsync build script to $HOST"; exit -1; }
ssh $HOST "cd /opt/lsst/$OS.buildscripts && bash rebuild.sh $RELEASE_TAG $DISTRIB_TOOL_VER > build.log 2>&1"
scp -q $HOST:/opt/lsst/$OS.buildscripts/build.log build.$OS.log
echo "Build done for $OS on $HOST. Log is in build.$OS.log"
