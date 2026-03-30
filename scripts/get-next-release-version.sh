#!/usr/bin/env bash

# args
readonly A_BUMP_LEVEL="$1"

echo "$(gem bump --pretend -v $A_BUMP_LEVEL | head -n1 | awk '{print $NF}')"
