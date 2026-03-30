#!/usr/bin/env bash

# args
readonly A_CHANGELOG_FILEPATH="$1"

# constants
readonly C_GEM_VERSION_TOKEN="__GEM_VER__"
readonly C_CURRENT_DATE_TOKEN="__CUR_DT__"

org_value="## \[unreleased]"
new_value="## [unreleased]\n\n## [$C_GEM_VERSION_TOKEN] - $C_CURRENT_DATE_TOKEN"
sed -e "s/$org_value/$new_value/g" $A_CHANGELOG_FILEPATH
