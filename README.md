# Hassan's Dotfiles

> **One command to set up a complete, beautiful Linux development environment.**

This repository contains all the configuration files that make my computer look good, work fast, and feel consistent. If you clone it and run one script, your Ubuntu machine will be set up exactly like mine.

---

## What Are "Dotfiles"?

On Linux and macOS, programs store their settings in hidden files — files whose names start with a dot (`.`). For example:

- `.zshrc` controls how your shell behaves
- `.gitconfig` stores your Git preferences
- Terminal configs decide what colors and fonts you see

These files live in your home directory, scattered across many folders. Collectively, people call them **"dotfiles."**

This repo is my personal collection of dotfiles — organized, version-controlled, and ready to install on any Ubuntu machine.

---

## What You Get

After running the setup, your system will have:

### A Beautiful, Consistent Look
- **Catppuccin Mocha** dark theme applied everywhere — terminal, text editor, file browser, system menus
- **JetBrainsMono Nerd Font** — a clean, readable font with special icons built in
- System-wide dark mode so every app follows the same color scheme

### A Powerful Terminal
- **Ghostty** and **WezTerm** — two modern terminal emulators, both themed and ready
- **Zellij** — split your terminal into multiple panes and tabs, like having many windows inside one
- **Zsh** — a smarter shell with shortcuts, autocomplete, and history search

### A Smart Command Line
- **Starship** — a beautiful prompt that shows you git status, directory, and more
- **Television** — fuzzy search for files, directories, git branches, and more, triggered with `Ctrl+T`
- **Atuin** — replaces your normal history search with a powerful, synced history database (`Ctrl+R`)
- **fzf, fd, ripgrep, eza, bat, btop** — faster, prettier replacements for common commands

### A Configured Text Editor
- **Neovim** with **LazyVim** pre-configured — a powerful editor that works with keyboard shortcuts
- **Catppuccin** colorscheme, auto-formatting, Go language support
- **OpenCode AI** integration — ask an AI about your code right inside the editor

### Developer Tools
- **Git** + **GitHub CLI** — version control and GitHub from the command line
- **kubectl, kubectx, kubens** — Kubernetes management
- **Docker** aliases — shorter commands for common Docker tasks
- **Node.js, Python, Go** — language runtimes and tooling
- **lazygit** — a visual Git interface in your terminal

### Other Apps
- **VSCode** with Catppuccin theme
- **Brave Browser**
- **VLC** media player
- **Obsidian** note-taking app
- **Nix** package manager (for reproducible software installs)

---

## How It Works

### Symlinks with GNU Stow

Instead of copying files to the right places, this repo uses **GNU Stow**. Stow creates **symbolic links** — shortcuts that point from where programs expect their config to where the files actually live in this repo.

This means:
- Edit a file in this repo → the change takes effect immediately
- Keep everything in Git → track every change, roll back if needed
- One `stow` command → all configs in the right place

### The Setup Script

`setup.sh` does everything automatically:

1. Installs all required packages (apps, fonts, tools)
2. Downloads and installs the JetBrainsMono Nerd Font family
3. Downloads and applies the Catppuccin GTK theme, icons, and cursors
4. Configures VSCode with the Catppuccin theme
5. Applies system-wide dark mode and font settings
6. Symlinks all config files with `stow`

The script is **idempotent** — safe to run multiple times. It checks if something is already installed before trying to install it again.

---

## Quick Start

### Prerequisites
- Ubuntu (tested on Jammy 22.04 and Noble 24.04)
- Internet connection
- Sudo access

### One Command

```bash
git clone https://github.com/HassanAliMAli/hassan-dotfiles.git
cd hassan-dotfiles
./setup.sh
```

That's it. The script will:
- Ask for your password (for sudo)
- Install everything
- Print a summary when done

### After the Script Runs

```bash
# Change your default shell to Zsh
chsh -s $(which zsh)

# Open Neovim to download all plugins (first run will take a moment)
nvim

# Log in to GitHub CLI
gh auth login

# Register Graphify with OpenCode
graphify install --platform opencode

# Restart your session (logout and back in) for theme changes to fully apply
```

### Tools Not Installed by the Script

These tools have their configs symlinked but need to be installed separately:

| Tool | Why It's Not Installed | Install It With |
|------|----------------------|-----------------|
| **Starship** | Needs Rust/cargo or curl install | `curl -sS https://starship.rs/install.sh \| sh` |
| **Zellij** | No stable Ubuntu PPA | `cargo install zellij` or see [zellij.dev](https://zellij.dev) |
| **Television** | Still in active development | `cargo install television` or see [GitHub](https://github.com/alexpasmantier/television) |
| **Atuin** | Needs curl install | `curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh \| sh` |
| **direnv** | Not in the install list | `sudo apt install -y direnv` then add `eval "$(direnv hook zsh)"` |

Their configs are already in place — just install the binary and they'll pick up the settings automatically.

---

## What Each Folder Does

| Folder | What It Configures | Plain English |
|--------|-------------------|---------------|
| `atuin/` | Shell history | Remembers every command you've ever typed, searchable with `Ctrl+R` |
| `gh-dash/` | GitHub dashboard | See your PRs and issues in a clean terminal view |
| `ghostty/` | Ghostty terminal | Colors, fonts, and a cool space shader for the background |
| `nix/` | Nix package manager | Enables modern Nix features like flakes |
| `nushell/` | Nushell shell | An alternative shell with structured data and vi mode |
| `nvim/` | Neovim editor | Your text editor — colors, plugins, AI integration |
| `opencode/` | OpenCode AI | The AI assistant that lives in your terminal |
| `ssh/` | SSH connections | Shortcuts and settings for connecting to remote servers |
| `starship/` | Command prompt | The little line before your cursor — themed and informative |
| `television/` | Fuzzy finder | Search anything — files, branches, repos — with `Ctrl+T` |
| `wezterm/` | WezTerm terminal | Another terminal emulator, themed and minimal |
| `zellij/` | Terminal multiplexer | Split, resize, and manage panes/tabs inside one window |
| `zshrc/` | Zsh shell | Your main shell — aliases, shortcuts, and tools |

---

## Keyboard Shortcuts

Every custom shortcut across all tools is documented in [KEYBINDINGS.md](KEYBINDINGS.md).

Here are the most useful ones:

### Everyday Commands
| Type This | What Happens |
|-----------|-------------|
| `tp` | Switch between full prompt and minimal (just directory) |
| `cx folder` | Go into a folder and list its contents |
| `fcd` | Fuzzy-search folders and jump into one |
| `fv` | Fuzzy-search files and open in Neovim |
| `rr` | Open the ranger file manager |

### Quick Navigation
| Type This | What Happens |
|-----------|-------------|
| `..` | Go up one folder |
| `...` | Go up two folders |
| `....` | Go up three folders |

### Git Shortcuts
| Type This | What Happens |
|-----------|-------------|
| `gst` | `git status` |
| `gc "message"` | `git commit -m "message"` |
| `gp` | `git push` |
| `ga` | `git add -p` (interactive add) |
| `glog` | Beautiful colored git graph |

### Terminal Shortcuts (Zellij)
| Press | What Happens |
|-------|-------------|
| `Ctrl+G` | Lock your terminal (prevents accidental typing) |
| `Ctrl+A` then `h/j/k/l` | Move between panes |
| `Ctrl+N` then `h/j/k/l` | Resize panes |
| `Ctrl+T` then `n` | New tab |
| `Ctrl+S` then `s` | Search in scrollback |
| `Alt+H/J/K/L` | Move focus between panes (no mode needed) |
| `Alt+N` | New pane (no mode needed) |

### Fuzzy Search (Television)
| Press | What Happens |
|-------|-------------|
| `Ctrl+T` | Search files, branches, repos — context-aware |
| `Ctrl+R` | Search your command history |
| `Ctrl+O` | Toggle preview panel |
| `Ctrl+Y` | Copy selected item to clipboard |

### AI Assistant (OpenCode)
| Press | What Happens |
|-------|-------------|
| `Ctrl+O` then `q` | Exit |
| `Ctrl+O` then `e` | Open editor |
| `Ctrl+O` then `m` | Change AI model |
| `Ctrl+O` then `l` | List sessions |
| `Ctrl+O` then `u` / `r` | Undo / Redo |

> **Full list:** See [KEYBINDINGS.md](KEYBINDINGS.md) — every shortcut for every tool, organized and cross-referenced.

---

## Detailed Documentation

Every single config file has a line-by-line explanation in the `docs/` folder. If you ever wonder "what does this line do?" — the answer is there.

- `docs/README.md` — Overview and navigation
- `docs/zshrc/` — Shell config explained
- `docs/nvim/` — Editor config explained
- `docs/zellij/` — Terminal multiplexer explained
- ...and one for every other tool

---

## Design Decisions

### Why Catppuccin Mocha?
It's a warm, high-contrast dark theme that's easy on the eyes. Using the same theme everywhere means your brain doesn't need to adjust when switching between terminal, editor, and file manager.

### Why JetBrainsMono Nerd Font?
- Monospace — every character is the same width, so code aligns properly
- Nerd Font variant — includes thousands of icons (git, docker, kubernetes, etc.)
- Excellent readability — clear distinction between similar characters (`0` vs `O`, `1` vs `l`)

### Why Zsh as the Main Shell?
- Mature, stable, and well-supported
- Great plugin ecosystem (autosuggestions, syntax highlighting)
- Vi mode built in for keyboard-centric editing

### Why No Prefix Key in Zellij?
Most multiplexer tutorials use a prefix key (like `Ctrl+B` in tmux). This config removes defaults and uses direct mode-switching keys instead. `Alt+` shortcuts work from normal mode with no prefix needed.

### Why `tp` Instead of `Ctrl+P` for Prompt Toggle?
`Ctrl+P` is already used by Television (previous entry) and Nushell (menu up). Using a command (`tp`) avoids stealing a key that other tools need.

---

## Removing or Resetting

### Undo the Symlinks
```bash
cd hassan-dotfiles
stow -D .
```
This removes all the symbolic links but leaves the actual config files intact.

### Remove Everything
```bash
# Remove the repo
rm -rf ~/hassan-dotfiles

# Remove installed apps (optional)
sudo apt remove wezterm ghostty zellij starship atuin television
```

---

## Contributing

This is a personal dotfiles repo, but if you spot a bug or have a suggestion, feel free to open an issue or pull request.

---

## License

Personal configuration files. Use at your own risk.
