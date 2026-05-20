# Dotfiles Keybindings Reference

## Terminal Emulators

### Wezterm

| Key | Action |
|-----|--------|
| `Ctrl+q` | Toggle Fullscreen |
| `Ctrl+'` | Clear Scrollback |
| `Ctrl+Click` | Open Link at Mouse Cursor |

### Ghostty

| Key | Setting |
|-----|---------|
| `Option as Alt` | Enabled |

---

## Shells

### Zsh (`.zshrc`)

| Key | Action |
|-----|--------|
| `Ctrl+w` | Execute autosuggestion |
| `Ctrl+e` | Accept autosuggestion |
| `Ctrl+u` | Toggle autosuggestion |
| `Ctrl+L` | Forward word (vi mode) |
| `Ctrl+k` | Up line or search |
| `Ctrl+j` | Down line or search |
| `jj` | Switch to vi command mode |

### Nushell (`config.nu`)

| Key | Action |
|-----|--------|
| `Alt+Backspace` | Delete one word backward |
| `Tab` | Completion menu |
| `Ctrl+n` | IDE completion menu |
| `Ctrl+r` | History menu |
| `F1` | Help menu |
| `Ctrl+c` | Cancel command |
| `Ctrl+d` | Quit shell |
| `Ctrl+l` | Clear screen |
| `Ctrl+q` | Search history |
| `Ctrl+o` | Open command editor |
| `Alt+Left/Right` | Move one word |
| `Ctrl+a/e` | Move to line start/end |
| `Ctrl+b/f` | Move left/right (emacs) |
| `Ctrl+h` | Backspace |
| `Ctrl+w` | Delete word backward |
| `Ctrl+u/k` | Cut to start/end |
| `Ctrl+z` | Undo |
| `Ctrl+y` | Paste |
| `Ctrl+Shift+c/x/a` | Copy/Cut/Select all |

---

## Terminal Multiplexers

### Tmux (`tmux.conf`)

| Key | Action |
|-----|--------|
| `Prefix: Ctrl+a` | Default prefix |
| `Prefix+o` | Session switcher (sessionx) |
| `Prefix+p` | Floax (floating tmux) |

### Zellij (`config.kdl`)

| Mode | Key | Action |
|------|-----|--------|
| Normal | `Ctrl+g` | Lock mode |
| Pane | `Ctrl+a` | Enter pane mode |
| Pane | `h/j/k/l` | Move focus |
| Pane | `n` | New pane |
| Pane | `x` | Close pane |
| Pane | `z` | Toggle fullscreen |
| Tab | `Ctrl+t` | Enter tab mode |
| Tab | `1-9` | Go to tab |
| Scroll | `Ctrl+s` | Enter scroll mode |
| Resize | `Ctrl+n` | Enter resize mode |
| Resize | `h/j/k/l` | Resize pane |
| Session | `Ctrl+x` | Enter session mode |
| Session | `d` | Detach |
| Shared | `Alt+n` | New pane |
| Shared | `Alt+h/j/k/l` | Move/resize |

---

## System-Wide (macOS)

### Karabiner Elements

| Key | Action |
|-----|--------|
| `Right Cmd+h/j/k/l` | Arrow keys |
| `Left Ctrl+h/j/k/l` | Arrow keys (Vim) |
| `Caps Lock` | Left Control |
| `Backslash` | Delete |
| `Delete` | Right Shift |
| `Delete Forward` | Right Option |
| `Up/Down Arrow` | Volume +/- |
| `Left/Right Arrow` | Volume +/- (swap) |

### Hammerspoon

| Key | Action |
|-----|--------|
| `Cmd+Alt+C` | Toggle clock (AClock) |
| `Cmd+Alt+A` | Launch Arc |
| `Alt+R` | Reload Hammerspoon config |

---

## Summary by Category

| Category | Tools |
|----------|-------|
| Terminal Emulators | Wezterm, Ghostty |
| Shells | Zsh, Nushell |
| Multiplexers | Tmux, Zellij |
| System-Wide | Karabiner, Hammerspoon |