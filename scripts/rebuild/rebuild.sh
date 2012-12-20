#!/bin/bash

[[ $# == 2 ]] || { echo "Usage: $0 <os> <host>"; exit -1; }

OS="$1"
HOST="$2"

echo "Building platform $OS on $HOST..."
rsync -az $OS/ $HOST:/opt/lsst/$OS.buildscripts || { echo "Failed to rsync build script to $HOST"; exit -1; }
ssh $HOST "cd /opt/lsst/$OS.buildscripts && bash rebuild.sh v6_1 0.1+1 > build.log 2>&1"
scp $HOST:/opt/lsst/$OS.buildscripts/build.log build.$OS.log
echo "Build done for $OS on $HOST. Log is in build.$OS.log"
