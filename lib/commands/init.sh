#!/usr/bin/env bash

ov_cmd_init() {
    local repo_path="${1:-}"
    local target_dir="${PWD}"

    if [[ -f "${target_dir}/.ovconfig" ]]; then
        ov_error "repository already initialized: ${target_dir}"
        exit 1
    fi

    if [[ -n "${repo_path}" && "${repo_path}" != /* ]]; then
        ov_error "repo path must be absolute"
        exit 1
    fi

    if [[ $# -gt 1 ]]; then
        ov_error "usage: ov init [absolute-repo-path]"
        exit 1
    fi

    mkdir -p \
        "${target_dir}/workspace" \
        "${target_dir}/.ov/upper" \
        "${target_dir}/.ov/work" \
        "${target_dir}/.ov/trash"

    cat > "${target_dir}/.ovconfig" <<EOF
repo=${repo_path}
workspace=workspace
upper=.ov/upper
work=.ov/work
trash=.ov/trash
EOF

    printf 'Initialized empty OverlayVault repository in %s\n' "${target_dir}"
}