#!/usr/bin/env bash

ov_find_repo_root() {
    local dir="${PWD}"

    while true; do
        if [[ -f "${dir}/.ovconfig" ]]; then
            printf '%s\n' "${dir}"
            return 0
        fi

        if [[ "${dir}" == "/" ]]; then
            return 1
        fi

        dir="$(dirname "${dir}")"
    done
}