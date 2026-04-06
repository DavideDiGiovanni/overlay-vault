#!/usr/bin/env bash

OV_CONFIG_ALLOWED_KEYS=(
    repo
    workspace
    upper
    work
    trash
)

ov_config_file() {
    local repo_root

    repo_root="$(ov_find_repo_root)" || return 1
    printf '%s/.ovconfig\n' "${repo_root}"
}

ov_config_is_allowed_key() {
    local key="${1:-}"
    local allowed

    for allowed in "${OV_CONFIG_ALLOWED_KEYS[@]}"; do
        if [[ "${allowed}" == "${key}" ]]; then
            return 0
        fi
    done

    return 1
}

ov_config_get() {
    local key="${1:-}"
    local config_file
    local line

    ov_config_is_allowed_key "${key}" || return 2

    config_file="$(ov_config_file)" || return 1

    while IFS= read -r line; do
        if [[ "${line}" == "${key}="* ]]; then
            printf '%s\n' "${line#*=}"
            return 0
        fi
    done < "${config_file}"

    return 1
}

ov_config_list() {
    local config_file

    config_file="$(ov_config_file)" || return 1
    cat "${config_file}"
}

ov_config_set() {
    local key="${1:-}"
    local value="${2:-}"
    local config_file
    local tmp_file

    ov_config_is_allowed_key "${key}" || return 2
    config_file="$(ov_config_file)" || return 1

    tmp_file="$(mktemp)"

    awk -F= -v target_key="${key}" -v target_value="${value}" '
        BEGIN {
            updated = 0
        }
        $1 == target_key {
            print target_key "=" target_value
            updated = 1
            next
        }
        {
            print $0
        }
        END {
            if (updated == 0) {
                print target_key "=" target_value
            }
        }
    ' "${config_file}" > "${tmp_file}"

    mv "${tmp_file}" "${config_file}"
}