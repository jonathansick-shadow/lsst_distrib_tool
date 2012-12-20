#!/bin/bash

set -e

for OS in $(find . -type d ! -name '.' | awk -F/ '{print $2}'); do
	HOST=$(head -n 1 $OS/host)
	./rebuild.sh "$OS" "$HOST"
done
