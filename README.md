# OverlayVault (ov)

A lightweight OverlayFS-based staging workspace to safely modify files before committing changes to real storage.

---

## Overview

OverlayVault introduces a staging layer on top of your filesystem using OverlayFS.

It allows you to modify, move and organize files without immediately affecting the original data.
Changes are applied only when explicitly confirmed, reducing the risk of accidental destructive operations.

This is particularly useful when working with sensitive data or directories that are continuously synchronized with cloud services.

---

## Why OverlayVault

Working directly on real files can be dangerous in scenarios such as:

- Cloud-synced directories (OneDrive, Google Drive, Nextcloud, etc.)
- Large file operations (bulk renames, moves, cleanups)
- Sensitive data where accidental deletion is costly

OverlayVault adds a safety layer between you and your data.

---

## What it does

- Creates an isolated workspace using OverlayFS
- Stores all changes in a staging layer
- Prevents immediate modification of original files
- Allows safe delete via a local trash system
- Applies changes only when explicitly committed

---

## What it is NOT

OverlayVault is intentionally simple and focused.

It is **not**:

- a version control system
- a backup solution
- a snapshot manager
- a tool for tracking file history

Once changes are applied to the original data, they are considered final.

---

## Core Concept

OverlayVault is based on a layered filesystem model:

- **repo (lower)** → original files (source of truth)
- **staging (upper)** → your changes
- **workspace (merged)** → where you work

All operations happen in the workspace, while the original data remains untouched until a push is performed.

---

## Use Cases

- Safe editing of cloud-synced folders
- Bulk file operations with rollback before commit
- Protecting archives and personal data from accidental changes
- Introducing a staging workflow for non-versioned files

---

## CLI Commands (Planned)

OverlayVault provides a simple CLI inspired by Git.

### ov init

Initializes an OverlayVault repository in the current directory.

- Creates `.ovconfig`
- Prepares internal directories (`.ov/`, trash, etc.)
- Defines repository and workspace structure

---

### ov mount

Mounts the OverlayFS workspace.

- Combines repository (lower) and staging (upper)
- Creates the working directory where all operations occur

---

### ov umount

Unmounts the workspace.

- Safely detaches the overlay filesystem

---

### ov status

Displays the current state of the workspace.

Shows:

- Added files
- Modified files
- Deleted files (overlay-level)
- Files moved to trash

---

### ov del <file>

Safely removes a file from the workspace.

- Moves the file to the local trash
- Avoids OverlayFS whiteout where possible
- Allows recovery before commit

---

### ov restore <file>

Restores a file from the trash.

- Returns the file to its original path
- Works only before changes are pushed

---

### ov push

Applies all staged changes to the repository.

- Syncs staging layer into the original data
- Makes changes permanent

---

### ov reset

Discards all staged changes.

- Clears the staging layer
- Restores workspace to match repository

---

## Command Philosophy

OverlayVault follows a simple model:

- Work safely in an isolated workspace
- Review changes using `ov status`
- Apply changes explicitly using `ov push`

Destructive operations are never immediate and always require explicit confirmation.

---

## Documentation

Detailed technical documentation is available in the `docs/` directory:

- [Architecture](docs/architecture.md)
- [OverlayFS Notes](docs/overlayfs-notes.md)
- [Repository Layout and Configuration](docs/repository-layout.md)

These documents describe the internal design, filesystem behavior and repository structure of OverlayVault.

## Status

Project in early development.
Core concepts and architecture are being defined.

---

## License

MIT License
