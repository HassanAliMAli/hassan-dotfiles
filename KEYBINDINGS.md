# KEYBINDINGS — Complete Reference

> Every custom shortcut defined across this dotfiles repository. Organized by tool.

---

## Shell (Zsh)

### Autosuggestions
| Shortcut | Action |
|----------|--------|
| `Ctrl+W` | Execute the autosuggestion |
| `Ctrl+E` | Accept the autosuggestion |
| `Ctrl+U` | Toggle autosuggestions on/off |
| `Ctrl+L` | Jump forward one word (vi-style) |
| `Ctrl+K` | Previous line or search |
| `Ctrl+J` | Next line or search |

### Vi Mode
| Shortcut | Action |
|----------|--------|
| `jj` | Exit insert mode → command mode |

### Custom Commands
| Command | Action |
|---------|--------|
| `tp` | Toggle between full Starship prompt and minimal (directory-only) prompt |
| `cx <dir>` | Change directory and list contents |
| `fcd` | Fuzzy-find a directory and cd into it |
| `f` | Fuzzy-find a file and copy its path to clipboard |
| `fv` | Fuzzy-find a file and open in Neovim |

---

## Shell (Nushell)

### Vi Mode (edit_mode: vi)
| Shortcut | Mode | Action |
|----------|------|--------|
| `jj` / `jk` | Insert | Exit to normal mode (defined in keymaps) |
| `Esc` | All | Exit menu / cancel |
| `Ctrl+C` | All | Cancel command |
| `Ctrl+D` | All | Quit shell |
| `Ctrl+L` | All | Clear screen |

### Menus
| Shortcut | Action |
|----------|--------|
| `Tab` | Open completion menu |
| `Ctrl+N` | Open IDE completion menu |
| `Ctrl+R` | Open history menu |
| `F1` | Open help menu |
| `Shift+Tab` | Previous completion |
| `Ctrl+X` | Next page (emacs mode) |
| `Ctrl+Z` | Undo / previous page (emacs mode) |

### Navigation
| Shortcut | Action |
|----------|--------|
| `Up` / `Down` | Navigate menu / history |
| `Left` / `Right` | Move cursor / navigate menu |
| `Ctrl+Left` | Jump one word left |
| `Ctrl+Right` | Jump one word right / accept history hint |
| `Home` / `Ctrl+A` | Go to line start |
| `End` / `Ctrl+E` | Go to line end / accept history hint |
| `Ctrl+P` | Move up in menu |
| `Ctrl+T` | Move down in menu |

### Deletion
| Shortcut | Action |
|----------|--------|
| `Backspace` | Delete character backward |
| `Ctrl+Backspace` | Delete word backward |
| `Delete` | Delete character forward |
| `Ctrl+H` | Delete character backward |
| `Ctrl+W` | Delete word backward |
| `Ctrl+K` | Delete to end of line |
| `Ctrl+U` | Delete from start of line |
| `Alt+Backspace` | Delete one word backward |
| `Alt+D` | Delete word forward |

### Clipboard
| Shortcut | Action |
|----------|--------|
| `Ctrl+Y` | Paste |
| `Ctrl+Shift+C` | Copy selection |
| `Ctrl+Shift+X` | Cut selection |
| `Ctrl+Shift+A` | Select all |

### Word Operations (Emacs mode)
| Shortcut | Action |
|----------|--------|
| `Alt+F` / `Alt+Right` | Move word forward |
| `Alt+B` / `Alt+Left` | Move word backward |
| `Alt+U` | Uppercase word |
| `Alt+L` | Lowercase word |
| `Alt+C` | Capitalize character |
| `Ctrl+T` | Swap adjacent characters |

### Aliases
| Alias | Expands To |
|-------|-----------|
| `l` | `ls --all` |
| `c` | `clear` |
| `ll` | `ls -l` |
| `lt` | `eza --tree --level=2 --long --icons --git` |
| `v` | `nvim` |
| `as` | `aerospace` |
| `asr` | `atuin scripts run` |
| `oc` | `opencode` |

---

## WezTerm (Terminal Emulator)

| Shortcut | Action |
|----------|--------|
| `Ctrl+Q` | Toggle fullscreen |
| `Ctrl+'` | Clear scrollback buffer |
| `Ctrl+Left Click` | Open URL under cursor in browser |

---

## Zellij (Terminal Multiplexer)

> **Leader-free design** — `clear-defaults=true` means only the bindings below exist. No prefix key needed.

### Mode Entry (from any mode)
| Shortcut | Enter Mode |
|----------|-----------|
| `Ctrl+G` | Locked |
| `Ctrl+A` | Pane |
| `Ctrl+N` | Resize |
| `Ctrl+S` | Scroll |
| `Ctrl+T` | Tab |
| `Ctrl+X` | Session |
| `Ctrl+B` | Tmux compatibility |
| `Alt+R` | Rename Tab |
| `Enter` / `Esc` | Normal (from any sub-mode) |

### Normal Mode
| Shortcut | Action |
|----------|--------|
| `Ctrl+G` | Lock session |
| `Alt+N` | New pane |
| `Alt+H` / `Alt+Left` | Move focus left |
| `Alt+L` / `Alt+Right` | Move focus right |
| `Alt+J` / `Alt+Down` | Move focus down |
| `Alt+K` / `Alt+Up` | Move focus up |
| `Alt+=` / `Alt++` | Resize increase |
| `Alt+-` | Resize decrease |
| `Alt+[` | Previous swap layout |
| `Alt+]` | Next swap layout |

### Pane Mode (`Ctrl+A`)
| Shortcut | Action |
|----------|--------|
| `Ctrl+A` | Exit to normal |
| `H` / `Left` | Move focus left |
| `L` / `Right` | Move focus right |
| `J` / `Down` | Move focus down |
| `K` / `Up` | Move focus up |
| `P` | Cycle focus through panes |
| `N` | New pane (default position) |
| `D` | New pane below |
| `X` | Close focused pane |
| `Z` | Toggle fullscreen |
| `F` | Toggle pane frames |
| `W` | Toggle floating panes |
| `E` | Toggle pane embed/floating |
| `R` | Rename pane |

### Resize Mode (`Ctrl+N`)
| Shortcut | Action |
|----------|--------|
| `Ctrl+N` | Exit to normal |
| `H` / `Left` | Increase left |
| `J` / `Down` | Increase down |
| `K` / `Up` | Increase up |
| `L` / `Right` | Increase right |
| `Shift+H` | Decrease left |
| `Shift+J` | Decrease down |
| `Shift+K` | Decrease up |
| `Shift+L` | Decrease right |
| `=` / `+` | Increase evenly |
| `-` | Decrease evenly |

### Tab Mode (`Ctrl+T`)
| Shortcut | Action |
|----------|--------|
| `Ctrl+T` | Exit to normal |
| `R` | Rename tab |
| `H` / `Left` / `Up` / `K` | Previous tab |
| `L` / `Right` / `Down` / `J` | Next tab |
| `N` | New tab |
| `X` | Close tab |
| `S` | Toggle sync tab |
| `B` | Break pane out |
| `]` | Break pane right |
| `[` | Break pane left |
| `1`–`9` | Go to tab number |
| `A` | Toggle last/active tab |

### Scroll Mode (`Ctrl+S`)
| Shortcut | Action |
|----------|--------|
| `Ctrl+S` | Exit to normal |
| `E` | Edit scrollback |
| `S` | Enter search |
| `G` | Scroll to bottom |
| `J` / `Down` | Scroll down |
| `K` / `Up` | Scroll up |
| `Ctrl+F` / `PageDown` / `Right` / `L` | Page down |
| `Ctrl+B` / `PageUp` / `Left` / `H` | Page up |
| `D` | Half page down |
| `U` | Half page up |

### Search Mode
| Shortcut | Action |
|----------|--------|
| `Ctrl+/` | Exit search |
| `N` | Next result (down) |
| `P` | Previous result (up) |
| `C` | Toggle case sensitivity |
| `W` | Toggle wrap |
| `O` | Toggle whole word |

### Session Mode (`Ctrl+X`)
| Shortcut | Action |
|----------|--------|
| `D` | Detach |
| `W` | Session manager (floating) |

### Tmux Mode (`Ctrl+B`)
| Shortcut | Action |
|----------|--------|
| `[` | Enter scroll mode |
| `"` | New pane below |
| `%` | New pane right |
| `Z` | Toggle fullscreen |
| `C` | New tab |
| `,` | Rename tab |
| `P` / `N` | Previous/next tab |
| `H/J/K/L` / Arrows | Move focus |
| `O` | Focus next pane |
| `D` | Detach |
| `Space` | Next layout |
| `X` | Close pane |

### Unbound (freed for other tools)
| Shortcut | Freed For |
|----------|-----------|
| `Ctrl+P` | Nushell menu up / Television previous |
| `Ctrl+O` | OpenCode AI leader key |
| `Ctrl+Q` | WezTerm fullscreen |
| `Ctrl+H` | Nushell delete char backward |

---

## Television (Fuzzy Finder)

### Application
| Shortcut | Action |
|----------|--------|
| `Esc` | Quit |
| `Ctrl+C` | Quit |

### Navigation
| Shortcut | Action |
|----------|--------|
| `Down` / `Ctrl+N` / `Ctrl+J` | Select next entry |
| `Up` / `Ctrl+P` / `Ctrl+K` | Select previous entry |
| `Ctrl+Up` | Previous history entry |
| `Ctrl+Down` | Next history entry |

### Selection
| Shortcut | Action |
|----------|--------|
| `Tab` | Toggle selection down |
| `Shift+Tab` | Toggle selection up |
| `Enter` | Confirm selection |

### Preview
| Shortcut | Action |
|----------|--------|
| `Ctrl+D` | Scroll preview half page down |
| `Ctrl+U` | Scroll preview half page up |
| `Ctrl+F` | Cycle previews |
| `Ctrl+O` | Toggle preview panel |

### Data
| Shortcut | Action |
|----------|--------|
| `Ctrl+Y` | Copy entry to clipboard |
| `Ctrl+S` | Cycle sources |

### UI
| Shortcut | Action |
|----------|--------|
| `Ctrl+R` | Toggle remote control (channel selector) |
| `Ctrl+X` | Toggle action picker |
| `F9` | Toggle help |
| `F10` | Toggle status bar |
| `Ctrl+T` | Toggle layout |

### Input Editing
| Shortcut | Action |
|----------|--------|
| `Backspace` | Delete previous char |
| `Ctrl+W` | Delete previous word |
| `Delete` | Delete next char |
| `Left` / `Right` | Move cursor |

### Shell Integration Triggers
| Type After | Press `Ctrl+T` → Opens |
|------------|----------------------|
| `alias`, `unalias` | Alias channel |
| `export`, `unset` | Environment variables |
| `cd`, `ls`, `rmdir`, `z` | Directories |
| `cat`, `vim`, `cp`, `mv`, `rm`, `tar`, `zip`, etc. | Files |
| `git add`, `git restore` | Git diff |
| `git checkout`, `git merge`, `git push`, `git pull` | Git branches |
| `git log`, `git show` | Git log |
| `docker run` | Docker images |
| `nvim`, `code`, `git clone` | Git repos |

### Shell Integration
| Shortcut | Action |
|----------|--------|
| `Ctrl+T` | Smart autocomplete (context-aware channel) |
| `Ctrl+R` | Command history search |

---

## OpenCode AI (TUI)

> **Leader key: `Ctrl+O`** — Press `Ctrl+O` then the next key.

### Application
| Shortcut | Action |
|----------|--------|
| `Ctrl+C` | Exit |
| `<leader>Q` | Exit |

### View Toggles
| Shortcut | Action |
|----------|--------|
| `<leader>E` | Open editor |
| `<leader>T` | List themes |
| `<leader>B` | Toggle sidebar |
| `<leader>S` | Status view |

### Session
| Shortcut | Action |
|----------|--------|
| `<leader>X` | Export session |
| `<leader>L` | List sessions |
| `<leader>G` | Session timeline |
| `<leader>C` | Compact session |
| `<leader>→` | Next child session |
| `<leader>←` | Previous child session |
| `<leader>↑` | Go to parent session |
| `Esc` | Interrupt session |

### Messages
| Shortcut | Action |
|----------|--------|
| `PageUp` / `Ctrl+U` | Page up |
| `PageDown` / `Ctrl+D` | Page down |
| `Ctrl+Alt+Y` | Line up |
| `Ctrl+Alt+E` | Line down |
| `Ctrl+Alt+U` | Half page up |
| `Ctrl+Alt+D` | Half page down |
| `Ctrl+G` / `Home` | First message |
| `Ctrl+Alt+G` / `End` | Last message |
| `<leader>N` | Next message |
| `<leader>P` | Previous message |
| `<leader>Y` | Copy message |
| `<leader>U` | Undo |
| `<leader>R` | Redo |
| `<leader>H` | Toggle conceal / tips |

### Models & Agents
| Shortcut | Action |
|----------|--------|
| `<leader>M` | List models |
| `F2` | Cycle recent models |
| `Shift+F2` | Cycle recent models (reverse) |
| `Ctrl+T` | Cycle variants |
| `Ctrl+P` | Command list |
| `<leader>A` | List agents |
| `Tab` | Cycle agents |
| `Shift+Tab` | Cycle agents (reverse) |

### Input Editing
| Shortcut | Action |
|----------|--------|
| `Enter` | Submit |
| `Shift+Enter` / `Ctrl+J` | New line |
| `Ctrl+C` | Clear input |
| `Ctrl+V` | Paste |
| `Ctrl+A` / `Home` | Line start |
| `Ctrl+E` / `End` | Line end |
| `Ctrl+K` | Delete to line end |
| `Ctrl+U` | Delete to line start |
| `Ctrl+Shift+D` | Delete entire line |
| `Ctrl+-` / `Super+Z` | Undo |
| `Ctrl+.` / `Super+Shift+Z` | Redo |
| `Alt+F` / `Ctrl+Right` | Word forward |
| `Alt+B` / `Ctrl+Left` | Word backward |
| `Ctrl+W` / `Ctrl+Backspace` | Delete word backward |
| `Alt+D` | Delete word forward |
| `Up` / `Down` | History previous/next |

---

## Neovim (LazyVim + Custom)

### Custom Keymaps
| Shortcut | Mode | Action |
|----------|------|--------|
| `jj` | Insert | Exit to normal mode |
| `jk` | Insert | Exit to normal mode |

### OpenCode.nvim Plugin
| Shortcut | Mode | Action |
|----------|------|--------|
| `<leader>ot` | Normal | Toggle embedded OpenCode panel |
| `<leader>oa` | Normal | Ask AI about code at cursor |
| `<leader>oa` | Visual | Ask AI about selection |
| `<leader>o+` | Normal | Add entire buffer to prompt |
| `<leader>o+` | Visual | Add selection to prompt |
| `<leader>oe` | Normal | Explain code at cursor |
| `<leader>on` | Normal | New OpenCode session |
| `Shift+Ctrl+U` | Normal | Scroll messages half page up |
| `Shift+Ctrl+D` | Normal | Scroll messages half page down |
| `<leader>os` | Normal/Visual | Select prompt type |

> LazyVim provides many more default keymaps. See `:help lazyvim` inside Neovim.

---

## gh-dash (GitHub Dashboard)

### Custom Keybindings
| Shortcut | Context | Action |
|----------|---------|--------|
| `g` | Universal | Open lazygit in the repo directory |
| `C` | PRs | Code review — opens a tmux window with OpenCode reviewing the PR |

---

## Atuin (Shell History)

| Setting | Value |
|---------|-------|
| `enter_accept` | `true` — pressing Enter immediately executes the selected command |
| `style` | `compact` |
| `Ctrl+R` | Triggered by shell integration to open Atuin history search |

> Atuin's internal keybindings use its own TUI. Press `Ctrl+R` in your shell to enter it.

---

## Quick Cross-Reference: Conflicts Avoided

| Shortcut | Reserved By | Unbound In |
|----------|------------|------------|
| `Ctrl+P` | Nushell menu up, Television previous | Zellij |
| `Ctrl+O` | OpenCode leader key | Zellij |
| `Ctrl+Q` | WezTerm fullscreen | Zellij |
| `Ctrl+H` | Nushell delete char | Zellij |
| `Ctrl+R` | Atuin history, Television remote control | — |
| `Ctrl+T` | Television smart autocomplete, Zellij tab mode | — |
| `jj` | Vi-mode escape (Zsh, Nushell, Neovim) | — |
