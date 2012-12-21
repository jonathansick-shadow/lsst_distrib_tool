#!/bin/bash

set -e

for OS in "$@"; do
	./rebuild.sh "$OS"
done
