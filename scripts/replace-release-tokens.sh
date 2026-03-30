#!/usr/bin/env bash

# args
readonly A_BUMP_LEVEL="$1"

# constants
readonly C_NEXT_VERSION="$(./scripts/get-next-release-version.sh $A_BUMP_LEVEL)"
readonly C_CURRENT_DATE="$(date +%d/%m/%Y)"

# functions
run_cmd_in_bg() {
    local cmd="$1"
    "$cmd" "${@:2}" &
}

display_loading_spinner_with_txt() {
    local msg="$1"
    local pid="$2"
    local delay=0.1
    local spin='|/-\'

    while kill -0 "$pid" 2>/dev/null; do
        for ((i = 0; i < ${#spin}; i++)); do
            printf "\r%c %s" "${spin:$i:1}" "$msg"
            sleep "$delay"
        done
    done

    printf "\r✅ %s\n" "$msg"
}

run_cmd_in_bg_with_loading_txt() {
    local txt="$1"
    local cmd="$2"

    run_cmd_in_bg "$cmd" "${@:3}"
    display_loading_spinner_with_txt "$txt" $!
}

replace_token() {
    local token="$1"
    local value="$2"
    local file="$3"

    sed -i -e "s|__${token}__|$value|g" "$file"
}

replace_release_tokens() {
    local file="$1"

    replace_token GEM_VER "$C_NEXT_VERSION" "$file"
    replace_token CUR_DT "$C_CURRENT_DATE" "$file"
}

for file in "${@:2}"; do
    loading_txt="Replacing tokens in '$file'"
    run_cmd_in_bg_with_loading_txt "$loading_txt" replace_release_tokens "$file"
done
