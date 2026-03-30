#!/usr/bin/env bash

# functions
get_current_version() {
    cat lib/vidload/version.rb | sed -n '4p' | awk '{print $NF}' | tr -d "'"
}

# constants
readonly C_GEMSPEC_FILE="vidload.gemspec"
readonly C_CURRENT_VERSION="$(get_current_version)"

gem build vidload.gemspec
gem install vidload-"$C_CURRENT_VERSION".gem
rm vidload-"$C_CURRENT_VERSION".gem
