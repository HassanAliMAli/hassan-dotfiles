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

These steps are required to finish the setup. The script installs everything but cannot do these automatically:

```bash
# 1. Change your default shell to Zsh
chsh -s $(which zsh)

# 2. Open Neovim to download all plugins (first run will take a moment)
nvim

# 3. Log in to GitHub CLI
gh auth login

# 4. Register Graphify with OpenCode
graphify install --platform opencode

# 5. Restart your session (logout and back in) for theme changes to fully apply
```

### Switching to Nushell as Default Shell

If you prefer Nushell over Zsh, you need two steps (the script can't do this because it requires sudo and could lock you out if something goes wrong):

```bash
# Add nushell to the list of allowed shells
echo $(which nu) | sudo tee -a /etc/shells

# Change your default shell
chsh -s $(which nu)
```

Then **log out and log back in** for the change to take effect.

---

## Important Things to Know

### The Script Does Not Change Your Default Shell
It installs Zsh and Nushell but leaves your current shell unchanged. You must run `chsh -s $(which zsh)` yourself. This is intentional — if the script changes your shell and something breaks, you could lose terminal access.

### Theme Changes Need a Logout
GTK themes, fonts, and system-wide dark mode are set in config files, but running apps won't pick them up until you restart. **Log out and log back in** to see the full Catppuccin Mocha theme everywhere.

### Neovim Needs One Manual Run
The script sets up the LazyVim config, but the first time you open `nvim`, it downloads all plugins. This takes a few minutes. Don't close the window while it's installing.

### Symlinks Mean Edit Once, Apply Everywhere
All config files are symlinks pointing to this repo. When you edit a file inside `hassan-dotfiles/`, the change is live immediately — no need to copy or run anything. Just edit, save, and it's applied.

### Running the Script Again Is Safe
The script is **idempotent**. Every install function checks if the tool already exists before installing. Run it 100 times — it will only skip, never break or duplicate anything.

### Some Tools Need Manual Install
These have their configs symlinked but the script can't install them automatically (no stable package source). Install them yourself and they'll pick up the settings:

| Tool | What It Does | Install It With |
|------|-------------|-----------------|
| **Starship** | Beautiful command prompt | `curl -sS https://starship.rs/install.sh \| sh` |
| **Zellij** | Terminal panes and tabs | `cargo install zellij` or see [zellij.dev](https://zellij.dev) |
| **Television** | Fuzzy finder (`Ctrl+T`) | `cargo install television` or see [GitHub](https://github.com/alexpasmantier/television) |
| **Atuin** | Supercharged history (`Ctrl+R`) | `curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh \| sh` |
| **direnv** | Auto-load env vars per project | `sudo apt install -y direnv` then run `direnv allow` in projects |

### direnv Needs Approval Per Project
After installing direnv, it won't load any `.envrc` file until you explicitly approve it. When you enter a project directory with a `.envrc`, you'll see a warning. Run `direnv allow` to trust it.

### Ghostty and WezTerm Are Both Installed
You have two terminal emulators. Pick one as your default. Both are themed with Catppuccin Mocha and use JetBrainsMono Nerd Font.

### Obsidian Is an AppImage
It installs to `~/.local/bin/Obsidian.AppImage`. To add it to your app menu, create a `.desktop` file or run it directly from the terminal with `Obsidian.AppImage`.

### SSH Config Is Managed Here
`~/.ssh/config` is a symlink to this repo. If you need to add personal SSH keys or host entries, edit `ssh/config` in this repo and commit the change. Your SSH keys (`id_rsa`, `id_ed25519`, etc.) are **not** in this repo — they stay in `~/.ssh/` and are never tracked by Git.

### Nushell Runtime Files Are Ignored by Git
`nushell/vendor/` and `nushell/history.txt` are in `.gitignore`. These are generated by Nushell at runtime and contain your command history and autoloaded scripts. They're unique to your machine.

### OpenCode Runtime Files Are Ignored by Git
`opencode/node_modules/`, `opencode/package.json`, `opencode/AGENTS.md`, and `opencode/opencode.jsonc` are in `.gitignore`. These are installed by OpenCode itself and are machine-specific.

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
