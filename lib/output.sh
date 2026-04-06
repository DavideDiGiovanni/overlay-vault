#!/usr/bin/env bash

ov_error() {
    printf 'ov: %s\n' "$*" >&2
}

ov_fatal_not_repo() {
    printf 'fatal: not an ov repository (or any of the parent directories): .ovconfig\n' >&2
    exit 1
}