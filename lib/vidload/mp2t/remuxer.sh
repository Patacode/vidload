#!/usr/bin/env bash

# args
readonly A_URL="$1"
readonly A_NAME="${2:-output}"
readonly A_REFERER="$3"

# constants
readonly C_USER_AGENT="Mozilla/5.0"
readonly C_REFERER="$A_REFERER/"

ffmpeg \
    -user_agent "$C_USER_AGENT" \
    -referer "$C_REFERER" \
    -i "$A_URL" \
    -c copy \
    "$A_NAME".mp4
