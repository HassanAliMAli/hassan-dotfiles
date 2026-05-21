# Dotfiles Project Documentation

Welcome to the comprehensive documentation for Hassan's dotfiles. This project contains all the configuration files that customize the look, feel, and behavior of a Linux development environment.

## What Are Dotfiles?

"Dotfiles" are configuration files on Unix-like systems (like Linux and macOS) whose names start with a dot (e.g., `.zshrc`, `.gitconfig`). These files control how your terminal, text editors, shells, and other tools behave.

## Project Structure

```
hassan-dotfiles/
├── .gitignore          # Files Git should ignore
├── .stowrc             # Rules for the stow symlink tool
├── README.md           # Quick start guide
├── setup.sh            # One-command installation script
├── atuin/              # Shell history manager config
├── gh-dash/            # GitHub dashboard config
├── ghostty/            # Ghostty terminal config
├── nix/                # Nix package manager config
├── nushell/            # Nushell shell config
├── nvim/               # Neovim text editor config (LazyVim)
├── opencode/           # OpenCode AI assistant config
├── ssh/                # SSH connection config
├── starship/           # Cross-shell prompt theme
├── television/         # Fuzzy finder tool config
├── wezterm/            # WezTerm terminal config
├── zellij/             # Terminal multiplexer config
└── zshrc/              # Zsh shell config
```

## How It Works

This project uses **GNU Stow**, a symlink manager. When you run `stow .` in this directory, it creates symbolic links (shortcuts) from each config file to the correct location on your system. For example, `nushell/config.nu` gets linked to `~/.config/nushell/config.nu`.

The `.stowrc` file configures Stow's behavior: it targets `~/.config` and ignores `zshrc/`, `ssh/`, and `docs/` (these are symlinked separately by the setup script).

## Quick Start

```bash
# Clone the repository
git clone https://github.com/HassanAliMAli/hassan-dotfiles.git
cd hassan-dotfiles

# Run the setup script (installs everything + symlinks configs)
./setup.sh
```

## Design Philosophy

- **Catppuccin Mocha** theme across all tools for visual consistency
- **JetBrainsMono Nerd Font** for icons and readability
- **Idempotent setup** — safe to run multiple times
- **Minimal prompt** option toggleable with `tp` command

## Custom Shortcuts Summary

See the complete [KEYBINDINGS.md](../KEYBINDINGS.md) at the repo root for every shortcut across all tools.

### Shell (Zsh & Nushell)
| Shortcut | Action |
|----------|--------|
| `tp` | Toggle between full and minimal prompt |
| `jj` | Enter command mode (vi mode in Zsh) |
| `Ctrl+R` | Search command history (Atuin) |
| `Ctrl+T` | Open file fuzzy finder (Television) |

### WezTerm
| Shortcut | Action |
|----------|--------|
| `Ctrl+Q` | Toggle fullscreen |
| `Ctrl+'` | Clear scrollback buffer |
| `Ctrl+Click` | Open link under cursor |

### Zellij (Terminal Multiplexer)
| Shortcut | Action |
|----------|--------|
| `Ctrl+G` | Lock session |
| `Ctrl+A` | Pane mode (move, split, close panes) |
| `Ctrl+N` | Resize mode |
| `Ctrl+S` | Scroll mode |
| `Ctrl+T` | Tab mode |
| `Ctrl+X` | Session mode (detach, session manager) |
| `Alt+H/J/K/L` | Move focus between panes |
| `Alt+N` | New pane |

### OpenCode AI Assistant
| Shortcut | Action |
|----------|--------|
| `Ctrl+O` + `q` | Exit |
| `Ctrl+O` + `e` | Open editor |
| `Ctrl+O` + `t` | List themes |
| `Ctrl+O` + `b` | Toggle sidebar |
| `Ctrl+O` + `m` | Change model |
| `Ctrl+O` + `a` | Cycle agents |
| `Ctrl+O` + `l` | List sessions |
| `Ctrl+O` + `u` | Undo |
| `Ctrl+O` + `r` | Redo |

### Television (Fuzzy Finder)
| Shortcut | Action |
|----------|--------|
| `Ctrl+T` | Smart autocomplete trigger |
| `Ctrl+R` | Command history / Toggle remote control |
| `Ctrl+J` / `Ctrl+N` | Select next entry |
| `Ctrl+K` / `Ctrl+P` | Select previous entry |
| `Ctrl+O` | Toggle preview panel |
| `Ctrl+X` | Toggle action picker |
| `Ctrl+Y` | Copy to clipboard |
| `Ctrl+S` | Cycle sources |
| `Ctrl+D` | Scroll preview down |
| `Ctrl+U` | Scroll preview up |
| `F9` | Toggle help |
| `F10` | Toggle status bar |
| `Tab` | Toggle multi-selection |
| `Enter` | Confirm selection |

## File-by-File Documentation

Each configuration file has its own detailed documentation page in the corresponding subdirectory under `docs/`:

### Root Files
- [`.gitignore`](gitignore.md) — Files Git should ignore
- [`.stowrc`](stowrc.md) — Rules for the stow symlink tool
- [`setup.sh`](setup-sh.md) — One-command installation script

### Tool Configurations
- [`atuin/config.toml`](atuin/config-toml.md) — Shell history manager
- [`gh-dash/config.yml`](gh-dash/config-yml.md) — GitHub PR/Issue dashboard
- [`ghostty/config`](ghostty/config.md) — Ghostty terminal emulator
- [`nix/`](nix/) — Nix package manager configuration
- [`nushell/config.nu`](nushell/config-nu.md) — Nushell main config (colors, menus, keybindings)
- [`nushell/env.nu`](nushell/env-nu.md) — Nushell environment config (prompt, PATH)
- [`nvim/init.lua`](nvim/init-lua.md) — Neovim editor (LazyVim, Catppuccin, OpenCode)
- [`opencode/opencode.json`](opencode/opencode-json.md) — OpenCode AI main config
- [`opencode/tui.json`](opencode/tui-json.md) — OpenCode AI terminal UI keybindings
- [`ssh/config`](ssh/config.md) — SSH connection shortcuts and settings
- [`starship/starship.toml`](starship/starship-toml.md) — Cross-shell prompt theme
- [`television/config.toml`](television/config-toml.md) — Fuzzy finder tool
- [`wezterm/wezterm.lua`](wezterm/wezterm-lua.md) — WezTerm terminal emulator
- [`zellij/config.kdl`](zellij/config-kdl.md) — Terminal multiplexer
- [`zellij/themes/catppuccin.kdl`](zellij/themes-catppuccin-kdl.md) — Zellij color themes
- [`zshrc/.zshrc`](zshrc/zshrc.md) — Zsh shell configuration
