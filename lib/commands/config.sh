#!/usr/bin/env bash

ov_cmd_config_usage() {
    printf 'usage: ov config [list|get <key>|set <key=value>]\n' >&2
}

ov_cmd_config_list() {
    ov_config_list
}

ov_cmd_config_get() {
    local key="${1:-}"

    if [[ -z "${key}" ]]; then
        ov_cmd_config_usage
        exit 1
    fi

    if ! ov_config_is_allowed_key "${key}"; then
        ov_error "unknown config key: ${key}"
        exit 1
    fi

    ov_config_get "${key}" || true
}

ov_cmd_config_set() {
    local assignment="${1:-}"
    local key
    local value

    if [[ -z "${assignment}" || "${assignment}" != *=* ]]; then
        ov_cmd_config_usage
        exit 1
    fi

    key="${assignment%%=*}"
    value="${assignment#*=}"

    if [[ -z "${key}" ]]; then
        ov_cmd_config_usage
        exit 1
    fi

    if ! ov_config_is_allowed_key "${key}"; then
        ov_error "unknown config key: ${key}"
        exit 1
    fi

    if [[ "${key}" == "repo" && -n "${value}" && "${value}" != /* ]]; then
        ov_error "repo path must be absolute"
        exit 1
    fi

    ov_config_set "${key}" "${value}"
    printf '%s=%s\n' "${key}" "${value}"
}

ov_cmd_config() {
    local subcommand="${1:-}"

    case "${subcommand}" in
        list)
            shift
            if [[ $# -ne 0 ]]; then
                ov_cmd_config_usage
                exit 1
            fi
            ov_cmd_config_list
            ;;
        get)
            shift
            if [[ $# -ne 1 ]]; then
                ov_cmd_config_usage
                exit 1
            fi
            ov_cmd_config_get "$1"
            ;;
        set)
            shift
            if [[ $# -ne 1 ]]; then
                ov_cmd_config_usage
                exit 1
            fi
            ov_cmd_config_set "$1"
            ;;
        *)
            ov_cmd_config_usage
            exit 1
            ;;
    esac
}