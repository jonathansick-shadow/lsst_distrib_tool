#!/bin/bash

set -e

for OS in "$@"; do
	HOST=$(head -n 1 "$OS/host")
	./rebuild.sh "$OS" "$HOST"
done
