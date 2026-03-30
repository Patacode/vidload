#!/usr/bin/env bash

if [[ -n "$(git status --porcelain)" ]]; then
    echo "Uncommitted changes found. Please commit or stash. Aborting."
    exit 1
fi

# args
readonly A_BUMP_LEVEL="$1"

./scripts/preprocess-changelog.sh CHANGELOG.md || exit 1
git commit -am "chore: preprocess files before release"
./scripts/replace-release-tokens.sh $A_BUMP_LEVEL CHANGELOG.md || exit 1
git commit -am "chore: replace release tokens"
gem bump -t -r -v "$A_BUMP_LEVEL" || exit 1
git push
