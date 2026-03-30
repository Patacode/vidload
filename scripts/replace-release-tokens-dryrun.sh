#!/usr/bin/env bash

# args
readonly A_BUMP_LEVEL="$1"

# constants
readonly C_NEXT_VERSION="$(./scripts/get-next-release-version.sh $A_BUMP_LEVEL)"
readonly C_CURRENT_DATE="$(date +%d/%m/%Y)"
readonly C_ANSI_BOLD_LIGHT_GREEN='\033[1;92m'
readonly C_ANSI_BOLD_LIGHT_RED='\033[1;91m'
readonly C_ANSI_BOLD_WHITE=$'\033[1;97m'
readonly C_ANSI_RESET=$'\033[0m'

# functions
print_custom_txt() {
    local txt="$1"
    printf "―――――――――――――――――――――――――――――――――――――――――――――――――▶ "
    printf "$txt\n"
}

replace_token() {
    local token="$1"
    local value="$C_ANSI_BOLD_WHITE$2$C_ANSI_RESET"
    local file="$3"

    sed -i -e "s|__${token}__|$C_ANSI_BOLD_WHITE$value$C_ANSI_RESET|g" "$file"
}

print_header() {
    local file="$1"
    print_custom_txt "Replacement in $C_ANSI_BOLD_WHITE$file$C_ANSI_RESET file"
}

print_content() {
    local file="$1"
    while IFS= read -r line; do
        printf "%s\n" "$line"
    done <"$file"
}

print_before() {
    local file="$1"
    printf "$C_ANSI_BOLD_LIGHT_RED<<<<<<<<<< Before$C_ANSI_RESET\n"
    print_content "$file"
}

print_after() {
    local file="$1"
    printf "$C_ANSI_BOLD_LIGHT_GREEN>>>>>>>>>> After$C_ANSI_RESET\n"
    print_content "$file"
}

highlight_release_tokens_in_tmp_file() {
    local file="$1"
    local unix_timestamp="$(date +%s)"
    local tmp_file=".$unix_timestamp-tmp"

    cat "$file" >"$tmp_file"
    replace_token GEM_VER __GEM_VER__ "$tmp_file"
    replace_token CUR_DT __CUR_DT__ "$tmp_file"
    print_before "$tmp_file"
    rm $tmp_file
}

replace_release_tokens_in_tmp_file() {
    local file="$1"
    local unix_timestamp="$(date +%s)"
    local tmp_file=".$unix_timestamp-tmp"

    cat "$file" >"$tmp_file"
    replace_token GEM_VER "$C_NEXT_VERSION" "$tmp_file"
    replace_token CUR_DT "$C_CURRENT_DATE" "$tmp_file"
    print_after "$tmp_file"
    rm $tmp_file
}

for file in "${@:2}"; do
    print_header "$file"
    highlight_release_tokens_in_tmp_file "$file"
    replace_release_tokens_in_tmp_file "$file"
done
