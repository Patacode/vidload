#!/usr/bin/env bash

if [[ -n "$(git status --porcelain)" ]]; then
    echo "Uncommitted changes found. Please commit or stash. Aborting."
    exit 1
fi

# args
readonly A_BUMP_LEVEL="$1"

# functions
clean_exit() {
    local status="$1"
    rm CHANGELOG-tmp.md
    exit $status
}

./scripts/preprocess-changelog-dryrun.sh CHANGELOG.md >CHANGELOG-tmp.md || clean_exit 1
./scripts/replace-release-tokens-dryrun.sh $A_BUMP_LEVEL CHANGELOG-tmp.md || clean_exit 1
gem bump -t -r -v "$A_BUMP_LEVEL" --pretend || clean_exit 1
clean_exit 0
