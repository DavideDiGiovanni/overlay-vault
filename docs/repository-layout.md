# OV Repository Layout

## Overview

An OV repository is identified by the presence of a `.ovconfig` file.

Commands executed inside the repository root or any of its subdirectories must resolve the repository by walking up the parent directories until `.ovconfig` is found.

If no `.ovconfig` file is found, the command must fail with a repository-not-found error.

---

## Repository Structure

An OV repository contains:

- `.ovconfig`
- `workspace/`
- `.ov/upper/`
- `.ov/work/`
- `.ov/trash/`

---

## Configuration File

The `.ovconfig` file is the source of truth for the repository configuration.

Initial format:

- repo=/absolute/path/to/protected/data
- workspace=workspace
- upper=.ov/upper
- work=.ov/work
- trash=.ov/trash

---

## Path Semantics

- `repo` points to the original protected data
- `workspace` is the user-facing working directory
- `upper` is the OverlayFS writable staging layer
- `work` is the OverlayFS internal workdir
- `trash` stores files removed through `ov del`

All paths except `repo` are resolved relative to the OV repository root.

---

## Repository Discovery

All commands must:

1. start from the current working directory
2. search for `.ovconfig`
3. if not found, move to the parent directory
4. repeat until filesystem root is reached

If not found, the command must fail.

The closest `.ovconfig` must always win.

---

## Constraints

- `workspace` must not be the same as `repo`
- `workspace` must not contain `repo`
- `repo` must not contain `workspace`
- `upper` and `work` must be on the same filesystem
- `.ov/` contents are internal and must not be modified manually

---

## Restore Model

OverlayFS whiteouts are considered an internal implementation detail.

User-level restore must always rely on the local trash managed by OverlayVault, not on direct manipulation of OverlayFS upperdir contents.
