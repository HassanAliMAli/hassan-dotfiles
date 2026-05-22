# OpenCode TUI Configuration — Documentation

**Location:** `ai/tui.json` (also accessible at `opencode/tui.json` via symlink) → `~/.config/opencode/tui.json`  
**Purpose:** Configures the OpenCode AI assistant terminal UI, including all keyboard shortcuts. Lives in the shared `ai/` folder.

## What Is OpenCode?

OpenCode is an AI-powered coding assistant that runs in your terminal. It can:
- Answer questions about your codebase
- Write and edit code
- Run commands and tests
- Manage multiple sessions

## Line-by-Line Explanation

### Lines 1-2: Schema

```json
{
  "$schema": "https://opencode.ai/tui.json",
```

- **What it does:** Tells your editor what format this file should be in (enables autocomplete and validation)

### Line 3-4: Leader Key

```json
"keybinds": {
  "leader": "ctrl+o",
```

- **What it does:** Sets `Ctrl+O` as the "leader" key — a prefix for most shortcuts
- **How it works:** Press `Ctrl+O`, then press another key to trigger an action
- **Example:** `Ctrl+O` then `e` opens the editor

### Line 5: Exit

```json
"app_exit": "ctrl+c,<leader>q",
```

- **What it does:** Two ways to quit: `Ctrl+C` or `Ctrl+O` then `q`

### Lines 6-12: View Toggles

| Shortcut | Action |
|----------|--------|
| `<leader>e` | Open external editor |
| `<leader>t` | List and switch themes |
| `<leader>b` | Toggle sidebar |
| `none` | Scrollbar toggle (disabled) |
| `none` | Username toggle (disabled) |
| `<leader>s` | Status view |
| `none` | Tool details (disabled) |

### Lines 13-25: Session Management

| Shortcut | Action |
|----------|--------|
| `<leader>x` | Export session |
| `none` | New session (disabled) |
| `<leader>l` | List sessions |
| `<leader>g` | Session timeline |
| `none` | Fork session (disabled) |
| `none` | Rename session (disabled) |
| `none` | Share session (disabled) |
| `none` | Unshare session (disabled) |
| `Escape` | Interrupt session |
| `<leader>c` | Compact session |
| `<leader>right` | Next child session |
| `<leader>left` | Previous child session |
| `<leader>up` | Go to parent session |

### Lines 26-40: Message Navigation

| Shortcut | Action |
|----------|--------|
| `PageUp` / `Ctrl+U` | Page up in messages |
| `PageDown` / `Ctrl+D` | Page down in messages |
| `Ctrl+Alt+Y` | One line up |
| `Ctrl+Alt+E` | One line down |
| `Ctrl+Alt+U` | Half page up |
| `Ctrl+Alt+D` | Half page down |
| `Ctrl+G` / `Home` | Go to first message |
| `Ctrl+Alt+G` / `End` | Go to last message |
| `<leader>n` | Next message |
| `<leader>p` | Previous message |
| `<leader>y` | Copy message |
| `<leader>u` | Undo last action |
| `<leader>r` | Redo |
| `<leader>h` | Toggle conceal (hide/show code blocks) |

### Lines 41-50: Models & Agents

| Shortcut | Action |
|----------|--------|
| `<leader>m` | List models |
| `F2` | Cycle recent models |
| `Shift+F2` | Cycle recent models (reverse) |
| `Ctrl+T` | Cycle variants |
| `Ctrl+P` | Command list |
| `<leader>a` | List agents |
| `Tab` | Cycle agents |
| `Shift+Tab` | Cycle agents (reverse) |

### Lines 51-93: Input Editing

#### Basic Input
| Shortcut | Action |
|----------|--------|
| `Ctrl+C` | Clear input |
| `Ctrl+V` | Paste |
| `Enter` | Submit |
| `Shift+Enter` / `Ctrl+J` | New line |

#### Cursor Movement
| Shortcut | Action |
|----------|--------|
| `Left` / `Ctrl+B` | Move left |
| `Right` / `Ctrl+F` | Move right |
| `Up` / `Down` | Move up/down |
| `Ctrl+A` | Go to line start |
| `Ctrl+E` | Go to line end |
| `Home` / `End` | Go to buffer start/end |
| `Alt+F` / `Ctrl+Right` | Word forward |
| `Alt+B` / `Ctrl+Left` | Word backward |

#### Selection
| Shortcut | Action |
|----------|--------|
| `Shift+Arrow` | Select text |
| `Ctrl+Shift+A/E` | Select to line start/end |
| `Alt+A/E` | Visual line start/end |
| `Shift+Home/End` | Select to buffer start/end |
| `Alt+Shift+F/B` | Select word forward/backward |

#### Deletion
| Shortcut | Action |
|----------|--------|
| `Backspace` | Delete character backward |
| `Ctrl+D` / `Delete` | Delete character forward |
| `Ctrl+K` | Delete to line end |
| `Ctrl+U` | Delete to line start |
| `Alt+D` | Delete word forward |
| `Ctrl+W` / `Ctrl+Backspace` | Delete word backward |
| `Ctrl+Shift+D` | Delete entire line |

#### Undo/Redo
| Shortcut | Action |
|----------|--------|
| `Ctrl+-` / `Super+Z` | Undo |
| `Ctrl+.` / `Super+Shift+Z` | Redo |

### Lines 88-93: History & Terminal

| Shortcut | Action |
|----------|--------|
| `Up` / `Down` | Previous/next in history |
| `Ctrl+Z` | Suspend terminal |
| `none` | Title toggle (disabled) |
| `<leader>h` | Toggle tips |
| `none` | Display thinking (disabled) |

## Custom Shortcuts Summary

All shortcuts use `Ctrl+O` as the leader key:

| Leader Combo | Action |
|-------------|--------|
| `Ctrl+O q` | Quit |
| `Ctrl+O e` | Open editor |
| `Ctrl+O t` | Theme list |
| `Ctrl+O b` | Toggle sidebar |
| `Ctrl+O s` | Status view |
| `Ctrl+O x` | Export session |
| `Ctrl+O l` | List sessions |
| `Ctrl+O g` | Session timeline |
| `Ctrl+O c` | Compact session |
| `Ctrl+O a` | Agent list |
| `Ctrl+O m` | Model list |
| `Ctrl+O n/p` | Next/previous message |
| `Ctrl+O y` | Copy message |
| `Ctrl+O u/r` | Undo/redo |
| `Ctrl+O h` | Toggle conceal/tips |
| `Ctrl+O arrows` | Navigate child sessions |

## Design Decisions

1. **`Ctrl+O` leader key** — Doesn't conflict with terminal or shell shortcuts
2. **Many features disabled** (`"none"`) — Only essential features enabled, keeping the UI clean
3. **Vim-style navigation** — `Ctrl+B/F` for left/right, `Ctrl+A/E` for start/end
4. **Multiple undo options** — Both `Ctrl+-` and `Super+Z` for undo (cross-platform)
