# OverlayFS Notes

## What is OverlayFS

OverlayFS is a union filesystem available in the Linux kernel.

It allows combining multiple directories into a single unified view.

---

## Key Concepts

### lowerdir

- Read-only base layer
- Contains original data

### upperdir

- Writable layer
- Stores all changes

### workdir

- Required for internal operations
- Must be on the same filesystem as upperdir

### merged

- The resulting mount point
- Exposed to the user

---

## Copy-on-Write

When a file is modified:

- It is copied from lowerdir to upperdir
- All changes are applied to the copy

---

## Deletions

OverlayFS does not delete files from lowerdir.

Instead, it creates a special marker in upperdir:

- called a "whiteout"
- hides the file from the merged view

---

## Implications for OverlayVault

- Deleted files are not actually removed from the original data
- They are only hidden in the overlay
- This behavior is not user-friendly by default

OverlayVault introduces a custom trash system to provide a safer alternative.

---

## Limitations

- OverlayFS is not designed for version control
- Manual manipulation of upperdir can cause inconsistencies
- Cache and inode behavior can sometimes appear inconsistent after manual changes

---

## Why OverlayFS

OverlayFS provides:

- native kernel support
- high performance
- minimal overhead
- copy-on-write semantics

It is the ideal base for implementing a staging layer without duplicating data.
