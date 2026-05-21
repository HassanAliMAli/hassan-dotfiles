# .stowrc — Documentation

**Location:** Root of the repository  
**Purpose:** Configuration file for GNU Stow, the symlink manager that connects this repo's files to your system

## What Is GNU Stow?

GNU Stow is a tool that creates symbolic links (shortcuts) from files in this repository to their correct locations on your system. Instead of manually copying each config file to `~/.config/`, Stow does it automatically and keeps them in sync.

## Line-by-Line Explanation

### Line 1: `--target=~/.config`
- **What it does:** Sets the destination directory for all symlinks
- **Plain English:** "Take every folder in this repo and link its contents into `~/.config/`"
- **Example:** `nushell/config.nu` in this repo becomes a symlink at `~/.config/nushell/config.nu`
- **Why `~/.config`:** This is the standard XDG configuration directory on Linux where most modern tools expect their config files

### Line 2: `--ignore=.stowrc`
- **What it does:** Tells Stow to skip this file itself
- **Plain English:** "Don't try to symlink this file — it's only for Stow's own use"
- **Why needed:** Without this, Stow would try to create `~/.config/.stowrc`, which is meaningless

### Line 3: `--ignore=DS_Store`
- **What it does:** Tells Stow to skip any `.DS_Store` files
- **Plain English:** "Ignore macOS metadata files if they exist"
- **Why needed:** These files are created automatically by macOS Finder and have no purpose on Linux

### Line 4: `--ignore=atuin/*`
- **What it does:** Tells Stow to skip all files inside the `atuin/` directory
- **Plain English:** "Don't symlink Atuin's config files — they're managed differently"
- **Why needed:** Atuin's config may contain machine-specific settings or the directory structure may differ from what Stow expects. Atuin is initialized via `eval "$(atuin init zsh)"` in the shell config instead

## How Stow Works in Practice

When you run `stow .` in this directory:

1. Stow reads `.stowrc` for rules
2. For each folder (e.g., `nushell/`), it creates a matching folder in `~/.config/`
3. For each file inside (e.g., `config.nu`), it creates a symlink pointing back to the original file in this repo
4. The result: editing `~/.config/nushell/config.nu` actually edits the file in this repo

This means:
- Your configs are version-controlled
- You can sync them across machines via Git
- Changes take effect immediately (no copy step needed)
