# Architecture

## Overview

OverlayVault is built on top of Linux OverlayFS to provide a safe staging layer for filesystem operations.

The system introduces a separation between:

- original data (source of truth)
- user modifications (staging layer)
- working view (merged filesystem)

---

## Core Components

### Repository (lower)

The repository contains the original files.

- It is the source of truth
- It should never be modified directly
- All changes are applied here only via `ov push`

---

### Staging (upper)

The staging layer contains all modifications made by the user.

- Modified files are copied here (copy-on-write)
- New files are created here
- Deletions are represented internally by OverlayFS (whiteouts)

---

### Workspace (merged)

The workspace is the mounted overlay filesystem.

- This is where the user operates
- It combines repository and staging
- It behaves like a normal directory from the user perspective

---

### Trash

OverlayVault introduces a custom trash system.

- Files are never deleted directly
- `ov del` moves files to a local trash directory
- Files can be restored before being permanently removed

---

## Data Flow

1. User works inside the workspace
2. Changes are stored in the staging layer
3. Original files remain untouched
4. When confirmed, changes are applied to the repository via `ov push`

---

## Design Principles

### Safety first

Prevent accidental destructive operations by isolating changes.

---

### Explicit commit

Changes are never applied automatically.  
User must explicitly confirm them.

---

### No hidden state

All data is visible in the filesystem (no binary metadata or hidden storage layers).

---

### Minimalism

OverlayVault does not implement:

- versioning
- snapshots
- history

It focuses only on safe staging.

---

## Limitations

- No rollback after push
- No conflict resolution
- Relies on OverlayFS behavior
- Not suitable for high-concurrency environments

---

## Summary

OverlayVault acts as a lightweight staging layer for filesystem operations, providing safety without introducing the complexity of a full version control system.
