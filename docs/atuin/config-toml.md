# Atuin Configuration — Documentation

**Location:** `atuin/config.toml` → `~/.config/atuin/config.toml`  
**Purpose:** Configures Atuin, a shell history replacement that syncs and searches your command history

## What Is Atuin?

Atuin replaces your shell's default history (which is just a plain text file of past commands) with a SQLite database that supports:
- **Fuzzy search** — find commands by typing partial words
- **Sync across machines** — your history follows you
- **Statistics** — see your most-used commands
- **Encryption** — optional end-to-end encryption for privacy

## Line-by-Line Explanation

### Lines 1-14: File Paths (All Commented Out)
These lines show where Atuin stores its data by default:
- **`db_path`**: The SQLite database file (`~/.local/share/atuin/history.db`)
- **`key_path`**: The encryption key (`~/.local/share/atuin/key`)
- **`session_path`**: The auth session token (`~/.local/share/atuin/session`)

They're commented out because the defaults are fine.

### Lines 16-23: Display Settings (All Commented Out)
- **`dialect`**: Date format ("us" = MM/DD/YYYY, "uk" = DD/MM/YYYY)
- **`timezone`**: How to display timestamps

### Lines 25-37: Sync Settings (All Commented Out)
- **`auto_sync`**: Whether to automatically sync history to Atuin's servers
- **`sync_frequency`**: How often to sync (default: every 10 minutes)
- **`sync_address`**: The Atuin server URL

### Lines 39-59: Search & Filter (All Commented Out)
- **`search_mode`**: How to match queries ("fuzzy" = match characters in any order)
- **`filter_mode`**: Scope of search ("global" = all history, "host" = this machine only, "session" = current terminal session, "directory" = current directory only)

### Line 63: `style = "compact"`
- **What it does:** Sets the UI style to compact (fewer lines, more commands visible)
- **Options:** `auto`, `full`, `compact`
- **Why compact:** Shows more history entries on screen at once

### Lines 65-137: UI & Behavior (All Commented Out)
Various settings for interface behavior:
- **`inline_height`**: Max height of the search UI
- **`show_preview`**: Whether to show a preview of the selected command
- **`exit_mode`**: What happens when pressing Escape during search
- **`secrets_filter`**: Automatically prevents saving sensitive data (AWS keys, GitHub tokens, Stripe keys, etc.)

### Line 138: `enter_accept = true`
- **What it does:** When you press Enter in the search UI, the command runs immediately
- **Alternative:** If `false`, pressing Enter returns to the shell for editing; you'd press Tab to accept
- **Why true:** Faster workflow — search, press Enter, done

### Lines 140-157: Keymap & Performance (All Commented Out)
- **`keymap_mode`**: Editor style for the search UI ("emacs" or "vim")
- **`local_timeout`**: Database connection timeout

### Lines 163-195: `[stats]` Section (All Commented Out)
- **`common_subcommands`**: Commands where the subcommand matters for stats (e.g., `kubectl get` vs `kubectl apply`)
- **`common_prefix`**: Prefixes to strip before counting (e.g., `sudo apt install` counts as `apt install`)
- **`ignored_commands`**: Commands to exclude from stats entirely (e.g., `cd`, `ls`)

### Lines 197-199: `[keys]` Section (All Commented Out)
- **`scroll_exits`**: Whether pressing Down past the last entry exits the search UI

### Lines 201-205: `[sync]` Section
- **`records = true`**: Enables sync v2 (the newer, improved sync protocol)
- **Why enabled:** This is for new installs; it ensures they use the latest sync method

## Custom Shortcuts

Atuin doesn't define custom shortcuts in this config file. Its main shortcut is:
- **`Ctrl+R`**: Opens Atuin's history search (replaces the default shell history search)

This is configured in `~/.zshrc` via `eval "$(atuin init zsh)"`.
