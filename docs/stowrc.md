# .stowrc — Documentation

**Location:** Root of the repository  
**Purpose:** Configuration file for GNU Stow, the symlink manager that connects this repo's files to your system

## What Is GNU Stow?

GNU Stow is a tool that creates symbolic links (shortcuts) from files in this repository to their correct locations on your system. Instead of manually copying each config file to `~/.config/`, Stow does it automatically and keeps them in sync.

## Line-by-Line Explanation

### Line 1: `--target=/home/hassanalimali/.config`
- **What it does:** Sets the destination directory for all symlinks
- **Plain English:** "Take every folder in this repo and link its contents into `~/.config/`"
- **Example:** `nushell/config.nu` in this repo becomes a symlink at `~/.config/nushell/config.nu`
- **Why `~/.config`:** This is the standard XDG configuration directory on Linux where most modern tools expect their config files
- **Note:** If you fork this repo, change this to your own home directory. Stow does not expand `~`.

### Line 2: `--ignore=.stowrc`
- **What it does:** Tells Stow to skip this file itself
- **Plain English:** "Don't try to symlink this file — it's only for Stow's own use"
- **Why needed:** Without this, Stow would try to create `~/.config/.stowrc`, which is meaningless

### Line 3: `--ignore=DS_Store`
- **What it does:** Tells Stow to skip any `.DS_Store` files
- **Plain English:** "Ignore macOS metadata files if they exist"
- **Why needed:** These files are created automatically by macOS Finder and have no purpose on Linux

### Line 4: `--ignore=zshrc`
- **What it does:** Tells Stow to skip the `zshrc/` directory
- **Plain English:** "Don't symlink Zsh config into `~/.config/` — it goes in the home directory"
- **Why needed:** Zsh expects `.zshrc` in `~/.zshrc`, not `~/.config/zshrc/.zshrc`. The script handles this with an explicit symlink later.

### Line 5: `--ignore=ssh`
- **What it does:** Tells Stow to skip the `ssh/` directory
- **Plain English:** "Don't symlink SSH config into `~/.config/` — it goes in `~/.ssh/config`"
- **Why needed:** SSH expects its config at `~/.ssh/config`, not `~/.config/ssh/config`. The script handles this with an explicit symlink later.

### Line 6: `--ignore=docs`
- **What it does:** Tells Stow to skip the `docs/` directory
- **Plain English:** "Don't symlink documentation into `~/.config/docs/` — it's just project docs"
- **Why needed:** The `docs/` folder contains Markdown documentation, not configuration. Without this ignore, Stow would create `~/.config/docs/` pointing to the documentation folder.

## How Stow Works in Practice

When you run `stow .` in this directory:

1. Stow reads `.stowrc` for rules
2. For each folder that isn't ignored (e.g., `nushell/`, `nvim/`, `starship/`), it creates a matching folder in `~/.config/`
3. For each file inside, it creates a symlink pointing back to the original file in this repo
4. The result: editing `~/.config/nushell/config.nu` actually edits the file in this repo

This means:
- Your configs are version-controlled
- You can sync them across machines via Git
- Changes take effect immediately (no copy step needed)

## Exceptions Handled Separately

Three folders are excluded from stow and managed individually by the script:

| Folder | Target | Why Not Stow |
|--------|--------|-------------|
| `zshrc/` | `~/.zshrc` | Zsh expects the file directly in home, not in `~/.config/` |
| `ssh/` | `~/.ssh/config` | SSH expects config in `~/.ssh/`, and the `~/.ssh/` dir has strict permissions |
| `docs/` | N/A | Not config — just project documentation |
