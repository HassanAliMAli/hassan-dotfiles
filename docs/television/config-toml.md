# Television Configuration — Documentation

**Location:** `television/config.toml` → `~/.config/television/config.toml`  
**Purpose:** Configures Television (aka `tv`), a fast fuzzy finder for files, git repos, environment variables, and more

## What Is Television?

Television is a terminal fuzzy finder written in Rust. It's like `fzf` but with:
- Built-in preview panels
- Multiple "channels" for different content types (files, git branches, docker images, etc.)
- Shell integration for automatic context-aware fuzzy finding
- Catppuccin theme support

## Line-by-Line Explanation

### Lines 16-19: General Settings

```toml
tick_rate = 50
default_channel = "files"
```

- **`tick_rate = 50`**: How often the UI refreshes (50ms = 20 frames per second). Lower = smoother but more CPU
- **`default_channel = "files"`**: When you run `tv` without arguments, search through files

### Lines 29-37: History Settings

```toml
history_size = 200
global_history = false
```

- **`history_size = 200`**: Remember the last 200 search queries
- **`global_history = false`**: Each channel has its own history (not shared across all channels)

### Lines 39-57: UI Settings

```toml
[ui]
ui_scale = 100
orientation = "landscape"
theme = "catppuccin"
```

- **`ui_scale = 100`**: Use 100% of the terminal screen
- **`orientation = "landscape"`**: Horizontal layout (preview on the right)
- **`theme = "catppuccin"`**: Use the Catppuccin color theme

### Lines 61-68: Input Bar

```toml
[ui.input_bar]
position = "top"
prompt = ">"
border_type = "rounded"
```

- **`position = "top"`**: Search bar at the top of the UI
- **`prompt = ">"`**: The symbol before your cursor
- **`border_type = "rounded"`**: Rounded corners on the input bar border

### Lines 70-77: Status Bar

```toml
[ui.status_bar]
separator_open = ""
separator_close = ""
hidden = false
```

- **`separator_open/close`**: Powerline-style arrow separators ( and )
- **`hidden = false`**: Show the status bar at the bottom

### Lines 79-91: Results & Preview Panels

```toml
[ui.results_panel]
border_type = "rounded"

[ui.preview_panel]
size = 65
scrollbar = true
border_type = "rounded"
hidden = false
```

- **`results_panel.border_type`**: Rounded corners on the results list
- **`preview_panel.size = 65`**: Preview panel takes 65% of the width
- **`scrollbar = true`**: Show a scrollbar in the preview panel
- **`hidden = false`**: Preview panel is visible by default

### Lines 93-103: Help & Remote Control

```toml
[ui.help_panel]
show_categories = true
hidden = true

[ui.remote_control]
show_channel_descriptions = true
sort_alphabetically = true
```

- **`help_panel.hidden = true`**: Help is hidden by default (press `F9` to show)
- **`remote_control.show_channel_descriptions`**: Show what each channel does
- **`sort_alphabetically`**: Sort channels A-Z in the channel selector

### Lines 122-180: Keybindings

#### Application Control
| Shortcut | Action |
|----------|--------|
| `Esc` | Quit |
| `Ctrl+C` | Quit |

#### Navigation
| Shortcut | Action |
|----------|--------|
| `Down` / `Ctrl+N` / `Ctrl+J` | Select next item |
| `Up` / `Ctrl+P` / `Ctrl+K` | Select previous item |

#### History Navigation
| Shortcut | Action |
|----------|--------|
| `Ctrl+Up` | Previous search in history |
| `Ctrl+Down` | Next search in history |

#### Multi-Selection
| Shortcut | Action |
|----------|--------|
| `Tab` | Select item and move down |
| `Backtab` (Shift+Tab) | Select item and move up |
| `Enter` | Confirm selection |

#### Preview Control
| Shortcut | Action |
|----------|--------|
| `Ctrl+D` | Scroll preview down half page |
| `Ctrl+U` | Scroll preview up half page |
| `Ctrl+F` | Cycle through available previews |

#### Data Operations
| Shortcut | Action |
|----------|--------|
| `Ctrl+Y` | Copy selected item to clipboard |
| `Ctrl+S` | Cycle through sources |

#### UI Toggles
| Shortcut | Action |
|----------|--------|
| `Ctrl+R` | Toggle remote control (channel selector) |
| `Ctrl+X` | Toggle action picker |
| `Ctrl+O` | Toggle preview panel on/off |
| `F9` | Toggle help panel |
| `F10` | Toggle status bar |
| `Ctrl+T` | Toggle layout |

#### Input Editing
| Shortcut | Action |
|----------|--------|
| `Backspace` | Delete character before cursor |
| `Ctrl+W` | Delete word before cursor |
| `Delete` | Delete character after cursor |
| `Left` | Move cursor left |
| `Right` | Move cursor right |

### Lines 190-247: Shell Integration

#### Fallback Channel (Lines 190-192)
```toml
[shell_integration]
fallback_channel = "files"
```

- **What it does:** When no specific channel matches the command, search files

#### Channel Triggers (Lines 194-246)

When you press `Ctrl+T` after typing a command, Television automatically opens the right channel:

| Channel | Triggered By Commands |
|---------|----------------------|
| `alias` | `alias`, `unalias` |
| `env` | `export`, `unset` |
| `dirs` | `cd`, `ls`, `rmdir`, `z` |
| `files` | `cat`, `less`, `vim`, `cp`, `mv`, `rm`, `tar`, `zip`, etc. |
| `git-diff` | `git add`, `git restore` |
| `git-branch` | `git checkout`, `git merge`, `git push`, `git pull` |
| `git-log` | `git log`, `git show` |
| `docker-images` | `docker run` |
| `git-repos` | `nvim`, `code`, `git clone` |

**Example:** Type `git checkout ` then press `Ctrl+T` → Television opens with a list of git branches to choose from.

### Lines 249-255: Shell Integration Keybindings

```toml
[shell_integration.keybindings]
"smart_autocomplete" = "ctrl-t"
"command_history" = "ctrl-r"
```

- **`Ctrl+T`**: Trigger smart autocomplete (context-aware channel)
- **`Ctrl+R`**: Trigger command history search (replaces default `Ctrl+R` history)

## Design Decisions

1. **Catppuccin theme** — Matches the rest of the dotfiles ecosystem
2. **`ui_scale = 100`** — Full screen for maximum visibility
3. **Preview at 65%** — Larger preview for code/file inspection
4. **Rounded borders** — Consistent with other UI elements in the dotfiles
5. **Powerline separators** — Arrow-shaped status bar separators for a polished look
6. **`Ctrl+P/K` for up** — Matches vim/neovim navigation conventions
7. **`Ctrl+N/J` for down** — Matches vim/neovim navigation conventions
