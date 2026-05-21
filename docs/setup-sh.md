# setup.sh — Documentation

**Location:** Root of the repository  
**Purpose:** A one-command installation script that sets up the entire development environment on Ubuntu

## What This Script Does

This script is **idempotent**, meaning it's safe to run multiple times. If something is already installed, it skips it. It handles:
1. Installing system prerequisites
2. Installing all applications and tools
3. Installing JetBrainsMono Nerd Font (full family) system-wide
4. Installing Catppuccin Mocha theme for GTK, cursors, VSCode, and browsers
5. Applying system-wide dark mode and font settings
6. Customizing GNOME Terminal with Catppuccin Mocha theme
7. Configuring npm to use a fixed prefix (`~/.npm-global`) so global packages work from any shell
8. Symlinking all dotfiles using GNU Stow

## Architecture

### Helper Functions

#### `command_exists()`
- **Purpose:** Checks if a command/program is available on the system
- **How it works:** Runs `command -v <name>` which returns success (0) if the program exists, failure (1) if not
- **Used by:** Every install function to decide whether to skip or install

#### `require_sudo()`
- **Purpose:** Warns the user if sudo access is needed
- **How it works:** Runs `sudo -n true` which succeeds if sudo is available without a password prompt

### Install Functions (in order of execution)

#### 1. `install_prerequisites()`
- **What it installs:** `build-essential`, `curl`, `wget`, `git`, `software-properties-common`, `apt-transport-https`, `ca-certificates`, `gnupg`, `stow`, `fontconfig`, `xdg-utils`
- **Why these:** These are foundational tools needed by everything else. For example, `curl` downloads install scripts, `git` clones repos, `stow` symlinks configs, `gnupg` verifies package signatures

#### 2. `install_curl()`
- **What it does:** Installs `curl` if not present
- **Why explicit:** Even though it's in prerequisites, this ensures it's available as a fallback

#### 3. `install_git()`
- **What it does:** Installs `git` if not present
- **Why:** Needed for version control, cloning repos, and LazyVim

#### 4. `install_zsh()`
- **What it does:** Installs the Zsh shell
- **Why:** Zsh is a more powerful alternative to Bash with better autocomplete, theming, and plugin support

#### 5. `install_nushell()`
- **What it does:** Installs Nushell, a modern shell with structured data pipelines
- **How:** Installs via `apt install nushell` (avoids 30-min cargo compile)
- **Why:** Nushell treats output as structured data (tables, JSON) rather than plain text

#### 6. `install_wezterm()`
- **What it does:** Installs WezTerm, a GPU-accelerated terminal emulator
- **How:** Adds the official WezTerm repository based on Ubuntu version codename, then installs via apt
- **Why:** WezTerm supports ligatures, true color, tabs, and is configured with Catppuccin Mocha

#### 7. `install_ghostty()`
- **What it does:** Installs Ghostty, a fast terminal emulator
- **How:** On Ubuntu 26.04+ it's in default repos; on older versions it adds the PPA
- **Why:** Ghostty is a modern, GPU-accelerated terminal alternative to WezTerm

#### 8. `install_vim()`
- **What it does:** Installs the classic Vim text editor
- **Why:** Vim is universally available and useful for quick edits when Neovim isn't needed

#### 9. `install_neovim()`
- **What it does:** Installs Neovim version 0.11 or newer
- **How:** Checks existing version; if too old or missing, adds the `neovim-ppa/stable` PPA
- **Why:** LazyVim requires Neovim >= 0.11.2 for full functionality

#### 10. `install_lazyvim()`
- **What it does:** Clones the LazyVim starter template to `~/.config/nvim`
- **How:** Backs up existing config if present, clones from GitHub, removes the `.git` folder so you can create your own repo
- **Why:** LazyVim is a pre-configured Neovim setup with plugins, LSP, and Catppuccin theme

#### 11. `install_vscode()`
- **What it does:** Installs Visual Studio Code from Microsoft's official repository
- **How:** Downloads Microsoft's GPG key, adds the repo, installs `code`
- **Why:** VSCode is a popular GUI editor for web development and debugging

#### 12. `install_python()`
- **What it does:** Installs Python 3, pip, and venv
- **Why:** Essential for data analysis, AI tooling, and Python development

#### 13. `install_node()`
- **What it does:** Installs Node.js LTS via NodeSource repository, then configures npm to use a fixed user-writable prefix (`~/.npm-global`) so `npm i -g` works without sudo and binaries are reachable from any shell
- **Why:** Needed for JavaScript/TypeScript development, npm packages, and tools like gemini-cli

#### 14. `install_vlc()`
- **What it does:** Installs VLC media player
- **Why:** Universal media player for video/audio playback

#### 15. `install_brave()`
- **What it does:** Installs Brave browser from its official S3 repository
- **How:** Downloads Brave's GPG key, adds the repo, installs `brave-browser`
- **Why:** Privacy-focused browser with built-in ad blocking

#### 16. `install_gh()`
- **What it does:** Installs GitHub CLI (`gh`) from GitHub's official repository
- **How:** Downloads the keyring, adds the repo, installs `gh`
- **Why:** Allows managing GitHub repos, PRs, and issues from the terminal

#### 17. `install_gemini_cli()`
- **What it does:** Installs Gemini CLI globally via npm
- **Why:** AI assistant CLI tool from Anthropic

#### 18. `install_opencode()`
- **What it does:** Installs OpenCode CLI via the official install script
- **Why:** AI coding assistant configured in this repo

#### 19. `install_graphify()`
- **What it does:** Installs Graphify (PyPI package: `graphifyy`) via `uv`, `pipx`, or `pip`
- **Why:** AI coding assistant skill that creates knowledge graphs of codebases

#### 20. `install_obsidian()`
- **What it does:** Downloads the latest Obsidian AppImage from GitHub releases
- **How:** Queries the GitHub API for the latest release, downloads the AppImage to `~/.local/bin/`, makes it executable
- **Why:** Obsidian is a markdown-based note-taking app popular for knowledge management

#### 21. `install_power_tools()`
- **What it does:** Installs `uv` (fast Python package manager) and `pandoc` (document converter)
- **Why:** `uv` replaces pip/venv for faster Python workflows; `pandoc` converts between Markdown, PDF, DOCX, HTML

#### 22. `install_cli_tools()`
- **What it installs:** `fzf`, `fd-find`, `ripgrep`, `zoxide`, `bat`, `delta`, `eza`, `lazygit`, `btop`
- **Why each:**
  - `fzf`: Fuzzy finder for quick file/command search
  - `fd`: Faster, smarter `find` replacement
  - `ripgrep`: Blazing fast `grep` replacement
  - `zoxide`: Smart `cd` that learns your directories
  - `bat`: `cat` with syntax highlighting
  - `delta`: Syntax-highlighted git diffs
  - `eza`: Modern `ls` with icons and git status
  - `lazygit`: Terminal UI for git operations
  - `btop`: Beautiful system resource monitor

#### 23. `install_nerd_font()`
- **What it does:** Downloads and installs the **full JetBrainsMono Nerd Font family** (all weights: Regular, Bold, Italic, Thin, ExtraLight, Light, Medium, SemiBold, ExtraBold, Black, and their italic variants)
- **How:** Downloads the font archive from GitHub, extracts ALL `.ttf` files to both `/usr/local/share/fonts/JetBrainsMonoNerd` (system-wide) and `~/.local/share/fonts/JetBrainsMonoNerd` (user-local), rebuilds the font cache
- **Why:** Nerd Fonts include programming icons (git, docker, language logos) used by terminals, Neovim, and prompts. Installing the full family ensures every app has access to all font weights

#### 24. `install_catppuccin_gtk()`
- **What it does:** Downloads and installs the Catppuccin Mocha GTK theme system-wide to `/usr/share/themes/Catppuccin-Mocha`
- **How:** Downloads the pre-built theme ZIP from GitHub releases, extracts it, applies it via `gsettings`
- **Fallback:** Tries v1.0.3 release ZIP directly (the repo is archived); warns if both downloads fail
- **Why:** GTK theme affects all GTK applications (file managers, settings dialogs, GNOME apps) so they match the Catppuccin Mocha color scheme

#### 25. `install_catppuccin_cursors()`
- **What it does:** Downloads and installs Catppuccin cursor theme to `/usr/share/icons/catppuccin-mocha-lavender-cursors`
- **How:** Downloads the cursor zip from `catppuccin/cursors` releases, extracts to `/usr/share/icons/`, applies via `gsettings`
- **Why:** Makes mouse cursor match the Catppuccin aesthetic
- **Note:** Catppuccin does not provide a desktop icon theme. For Catppuccin-colored file/folder icons, install Papirus + `papirus-folders` separately.

#### 26. `install_vscode_catppuccin()`
- **What it does:** Installs and activates the Catppuccin theme extension for VSCode
- **How:** Runs `code --install-extension catppuccin.catppuccin-vsc`, then writes `settings.json` to set `"workbench.colorTheme": "Catppuccin Mocha"` and `"workbench.iconTheme": "catppuccin-mocha"`
- **Why:** VSCode is a major editor in this setup — it needs to match the rest of the ecosystem

#### 27. `install_browser_catppuccin()`
- **What it does:** Provides instructions for adding Catppuccin themes to Firefox and Brave
- **How:** Detects Firefox profile directory and points to the `catppuccin/firefox` repo for `userChrome.css`; suggests Chrome Web Store extension for Brave
- **Why:** Browsers are used daily — theming them completes the visual consistency

#### 28. `customize_gnome_terminal()`
- **What it does:** Applies Catppuccin Mocha color scheme and JetBrainsMono Nerd Font to GNOME Terminal
- **How:** Uses `dconf` (Linux desktop settings tool) to write terminal profile settings
- **What it sets:**
  - Profile name: "Catppuccin Mocha"
  - Background: `#1e1e2e` (dark purple)
  - Foreground: `#cdd6f4` (light text)
  - Cursor: `#f5e0dc` (pink)
  - Full 16-color Catppuccin palette
  - Font: JetBrainsMono Nerd Font 15
  - System monospace font: JetBrainsMono Nerd Font 14

#### 29. `apply_system_dark_mode()`
- **What it does:** Applies dark mode and JetBrainsMono font settings across the entire desktop
- **How:** Uses `gsettings` to configure GNOME desktop interface settings, creates Qt5 config, and sets `QT_QPA_PLATFORMTHEME=gtk3` in `~/.profile`
- **What it sets:**
  - GNOME color scheme: `prefer-dark`
  - GTK theme: `Catppuccin-Mocha`
  - Default font: JetBrainsMono Nerd Font 11
  - Monospace font: JetBrainsMono Nerd Font 14
  - Document font: JetBrainsMono Nerd Font 11
  - Qt5 style: `gtk2` with Catppuccin color scheme
  - Qt platform theme: `gtk3` (so Qt apps inherit GTK theme)
- **Why:** Ensures every app — GTK, Qt, and system UI — uses dark mode with the same font family

#### 30. `symlink_dotfiles()`
- **What it does:** Runs `stow .` to symlink all config files to `~/.config/`
- **Why last:** Everything must be installed first so the configs have programs to configure

## Color Coding

The script uses colored output for readability:
- 🔵 `[INFO]` — Blue: Informational messages
- 🟢 `[OK]` — Green: Success confirmations
- 🟡 `[WARN]` — Yellow: Warnings (non-fatal)
- 🔴 `[ERROR]` — Red: Errors

## Safety Features

1. **Idempotency:** Every function checks if the tool/theme/font is already installed before attempting installation (uses marker files, directory checks, version checks, and extension lists)
2. **Error handling:** `set -euo pipefail` stops the script on any error
3. **Fallbacks:** Multiple installation methods (e.g., `uv` → `pipx` → `pip` for Graphify; pre-built ZIP → source build for GTK theme)
4. **Version checks:** Neovim checks if version >= 0.11 before upgrading
5. **Graceful degradation:** If a download fails (e.g., Catppuccin GTK theme), the script warns and continues instead of crashing

## Execution Order

```
prerequisites → curl → git → zsh → nushell → rust → wezterm → ghostty → vim → neovim → lazyvim
→ vscode → python → node → vlc → brave → gh → gemini-cli → opencode → graphify → obsidian
→ power tools → cli tools → starship → zellij → atuin → television → direnv
→ nerd font → catppuccin gtk → catppuccin cursors → vscode catppuccin → browser catppuccin
→ gnome terminal → system dark mode → symlink dotfiles
```

## Post-Install Note

After running the script, **restart your session** (logout/login) for system-wide theme and font changes to take full effect across all applications. Also **reopen your terminal** for PATH changes (npm prefix, cargo bins, opencode) to be picked up by your shell.
