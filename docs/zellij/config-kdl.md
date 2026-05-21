# Zellij Configuration — Documentation

**Location:** `zellij/config.kdl` → `~/.config/zellij/config.kdl`  
**Purpose:** Configures Zellij, a terminal multiplexer that manages multiple terminal sessions, panes, and tabs

## What Is Zellij?

Zellij is a terminal multiplexer — it lets you:
- Split your terminal into multiple panes (like tmux or screen)
- Create tabs for different projects
- Detach from sessions and reattach later
- Navigate between panes with keyboard shortcuts

## Line-by-Line Explanation

### Lines 2-6: UI Settings

```kdl
ui {
    pane_frames {
        hide_session_name false
    }
}
```

- **`pane_frames`**: Shows borders around each pane
- **`hide_session_name false`**: Displays the session name in the pane frame

### Line 7: Clear Default Keybindings

```kdl
keybinds clear-defaults=true {
```

- **What it does:** Removes all default Zellij shortcuts so only the custom ones below are active
- **Why:** Prevents conflicts with terminal and shell shortcuts

### Lines 8-15: Normal Mode (Unbindings)

```kdl
normal {
    unbind "Ctrl p"
    unbind "Ctrl o"
    unbind "Ctrl q"
    unbind "Ctrl h"
}
```

- **What it does:** Explicitly unbinds these keys in normal mode
- **Why:** These shortcuts are used by other tools:
  - `Ctrl+P` — Used by `tp` prompt toggle in shells
  - `Ctrl+O` — OpenCode AI assistant leader key
  - `Ctrl+Q` — WezTerm fullscreen toggle
  - `Ctrl+H` — Shell history search

### Lines 16-18: Locked Mode

```kdl
locked {
    bind "Ctrl g" { SwitchToMode "Normal"; }
}
```

- **What it does:** `Ctrl+G` exits locked mode (a "safe" mode where no accidental key presses work)

### Lines 19-31: Resize Mode (`Ctrl+N`)

| Shortcut | Action |
|----------|--------|
| `Ctrl+N` | Exit resize mode |
| `h` / `Left` | Increase pane width on the left |
| `j` / `Down` | Increase pane height downward |
| `k` / `Up` | Increase pane height upward |
| `l` / `Right` | Increase pane width on the right |
| `H` | Decrease pane width on the left |
| `J` | Decrease pane height downward |
| `K` | Decrease pane height upward |
| `L` | Decrease pane width on the right |
| `=` / `+` | Increase pane size evenly |
| `-` | Decrease pane size evenly |

### Lines 32-49: Pane Mode (`Ctrl+A`)

| Shortcut | Action |
|----------|--------|
| `Ctrl+A` | Exit pane mode |
| `h/j/k/l` or arrows | Move focus to adjacent pane |
| `p` | Cycle focus through panes |
| `n` | New pane (default position) |
| `d` | New pane below |
| `x` | Close focused pane |
| `z` | Toggle fullscreen for focused pane |
| `f` | Toggle pane borders on/off |
| `w` | Toggle floating panes |
| `Ctrl+A` | Toggle floating panes (alternate) |
| `e` | Toggle between embedded and floating |
| `r` | Rename current pane |

### Lines 50-71: Tab Mode (`Ctrl+T`)

| Shortcut | Action |
|----------|--------|
| `Ctrl+T` | Exit tab mode |
| `r` | Rename current tab |
| `h/k/Left/Up` | Go to previous tab |
| `l/j/Right/Down` | Go to next tab |
| `n` | New tab |
| `x` | Close current tab |
| `s` | Toggle sync tab (sync input across panes) |
| `b` | Break pane out of tab |
| `]` | Break pane to the right |
| `[` | Break pane to the left |
| `1-9` | Go to tab number |
| `a` | Toggle between current and previous tab |

### Lines 72-85: Scroll Mode (`Ctrl+S`)

| Shortcut | Action |
|----------|--------|
| `Ctrl+S` | Exit scroll mode |
| `e` | Edit scrollback buffer |
| `s` | Enter search mode |
| `G` | Scroll to bottom |
| `j` / `Down` | Scroll down one line |
| `k` / `Up` | Scroll up one line |
| `Ctrl+f` / `PageDown` | Page down |
| `Ctrl+b` / `PageUp` | Page up |
| `d` | Half page down |
| `u` | Half page up |

### Lines 86-99: Search Mode

| Shortcut | Action |
|----------|--------|
| `Ctrl+/` | Exit search mode |
| `j/k` | Scroll through results |
| `n` | Next result (down) |
| `p` | Previous result (up) |
| `c` | Toggle case sensitivity |
| `w` | Toggle wrap around |
| `o` | Toggle whole word matching |

### Lines 100-111: Rename Modes

**Enter Search Mode (Lines 100-103):**
- `Ctrl+S` / `Esc` → Go to scroll mode
- `Enter` → Start searching

**Rename Tab Mode (Lines 104-107):**
- `Ctrl+C` → Cancel rename
- `Esc` → Undo rename and return to tab mode

**Rename Pane Mode (Lines 108-111):**
- `Ctrl+C` → Cancel rename
- `Esc` → Undo rename and return to pane mode

### Lines 112-123: Session Mode (`Ctrl+X`)

| Shortcut | Action |
|----------|--------|
| `Ctrl+X` | Exit session mode / go to scroll mode |
| `d` | Detach from session |
| `w` | Open session manager (floating window) |

### Lines 124-146: Tmux Compatibility Mode (`Ctrl+B`)

Provides tmux-style shortcuts for users transitioning from tmux:

| Shortcut | tmux Equivalent | Action |
|----------|----------------|--------|
| `[` | `Ctrl+B [` | Enter scroll mode |
| `Ctrl+B` | Prefix | Write prefix character |
| `"` | `Ctrl+B "` | New pane below |
| `%` | `Ctrl+B %` | New pane right |
| `z` | `Ctrl+B z` | Toggle fullscreen |
| `c` | `Ctrl+B c` | New tab |
| `,` | `Ctrl+B ,` | Rename tab |
| `p/n` | `Ctrl+B p/n` | Previous/next tab |
| `h/j/k/l` | `Ctrl+B arrows` | Move focus |
| `o` | `Ctrl+B o` | Focus next pane |
| `d` | `Ctrl+B d` | Detach |
| `Space` | `Ctrl+B Space` | Next layout |
| `x` | `Ctrl+B x` | Close pane |

### Lines 147-182: Shared Shortcuts (Available in Most Modes)

| Shortcut | Available In | Action |
|----------|-------------|--------|
| `Ctrl+G` | All except locked | Enter locked mode |
| `Alt+n` | All except locked | New pane |
| `Alt+h/Left` | All except locked | Move focus left |
| `Alt+l/Right` | All except locked | Move focus right |
| `Alt+j/Down` | All except locked | Move focus down |
| `Alt+k/Up` | All except locked | Move focus up |
| `Alt=/+` | All except locked | Resize increase |
| `Alt--` | All except locked | Resize decrease |
| `Alt+[` | All except locked | Previous layout |
| `Alt+]` | All except locked | Next layout |
| `Enter/Esc` | All except normal/locked | Return to normal mode |

### Mode Entry Shortcuts

| Shortcut | Mode |
|----------|------|
| `Ctrl+A` | Pane mode |
| `Ctrl+N` | Resize mode |
| `Ctrl+S` | Scroll mode |
| `Ctrl+X` | Session mode |
| `Ctrl+T` | Tab mode |
| `Alt+R` | Rename tab mode |
| `Ctrl+B` | Tmux mode |

### Lines 185-190: Plugins

```kdl
plugins {
    tab-bar { path "tab-bar"; }
    status-bar { path "status-bar"; }
    strider { path "strider"; }
    compact-bar { path "compact-bar"; }
}
```

- **What it does:** Defines built-in plugins for UI elements
- **`tab-bar`**: Shows tabs at the top
- **`status-bar`**: Shows status information
- **`strider`**: File navigation plugin
- **`compact-bar`**: Minimal UI bar

### Lines 192-205: Session Behavior

```kdl
on_force_close "detach"
simplified_ui true
```

- **`on_force_close "detach"`**: When the terminal closes, detach from the session instead of killing it (your work is preserved)
- **`simplified_ui true`**: Uses simpler characters for UI elements (better compatibility)

### Lines 210-217: Shell and Panes

```kdl
// default_shell "fish"
pane_frames false
```

- **`default_shell`**: Commented out — uses your default `$SHELL`
- **`pane_frames false`**: No borders around panes (cleaner look)

### Lines 226-249: Theme Configuration

```kdl
theme "catppuccin-mocha"
```

- **What it does:** Sets the color theme to Catppuccin Mocha
- **Theme directory:** `~/.config/zellij/themes` (line 315)

### Lines 284-285: Copy Commands (Commented Out)

```kdl
// copy_command "xclip -selection clipboard" // x11
// copy_command "wl-copy"                    // wayland
```

- **What they are:** Commands to copy text to clipboard on X11 or Wayland
- **Why commented:** Using default OSC 52 sequence which works in most modern terminals

## Custom Shortcuts Summary

| Shortcut | Action |
|----------|--------|
| `Ctrl+A` | Pane mode (move between panes) |
| `Ctrl+N` | Resize mode (adjust pane sizes) |
| `Ctrl+S` | Scroll mode (scroll through history) |
| `Ctrl+T` | Tab mode (switch/rename tabs) |
| `Ctrl+X` | Session mode (detach/session manager) |
| `Ctrl+B` | Tmux compatibility mode |
| `Ctrl+G` | Lock mode (prevent accidental input) |
| `Alt+h/j/k/l` | Quick pane navigation (from any mode) |
| `Alt+n` | Quick new pane (from any mode) |

## Design Decisions

1. **`clear-defaults=true`** — No default shortcuts, only custom ones to avoid conflicts
2. **`pane_frames false`** — No borders for a cleaner look
3. **`on_force_close "detach"`** — Sessions survive terminal crashes
4. **`simplified_ui true`** — Better compatibility across terminals
5. **Catppuccin Mocha** — Matches the rest of the dotfiles ecosystem
6. **Unbinds `Ctrl+P/O/Q/H`** — Prevents conflicts with shell and terminal shortcuts
