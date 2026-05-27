#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Ubuntu Dotfiles Setup Script
# Idempotent — safe to run on fresh or existing installs
# =============================================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
log_ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# =============================================================================
# Helpers
# =============================================================================

command_exists() { command -v "$1" &>/dev/null; }

require_sudo() {
    if ! sudo -n true 2>/dev/null; then
        log_info "Sudo required. You may be prompted for your password."
    fi
}

# =============================================================================
# 1. Prerequisites
# =============================================================================

install_prerequisites() {
    log_info "Installing prerequisites..."
    sudo apt update -y
    sudo apt install -y \
        build-essential \
        curl \
        wget \
        git \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        gnupg \
        stow \
        fontconfig \
        xdg-utils
    log_ok "Prerequisites installed"
}

# =============================================================================
# 2. Zsh
# =============================================================================

install_zsh() {
    if command_exists zsh; then
        log_ok "Zsh already installed ($(zsh --version))"
        return
    fi
    log_info "Installing Zsh..."
    sudo apt install -y zsh
    log_ok "Zsh installed"
}

# =============================================================================
# 3. Rust (needed before cargo-based installs)
# =============================================================================

install_rust() {
    if command_exists cargo; then
        log_ok "Rust already installed (cargo $(cargo --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "present"))"
        return
    fi
    log_info "Installing Rust via rustup (needed for Zellij, Television, etc.)..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    # Source cargo for the rest of this script
    if [[ -f "$HOME/.cargo/env" ]]; then
        source "$HOME/.cargo/env"
    fi
    log_ok "Rust installed"
}

# =============================================================================
# 4. Nushell (via apt to avoid 30-min cargo compile)
# =============================================================================

install_nushell() {
    if command_exists nu; then
        log_ok "Nushell already installed ($(nu --version))"
        return
    fi
    log_info "Installing Nushell via apt..."
    sudo apt install -y nushell
    log_ok "Nushell installed"
}

# =============================================================================
# 4. WezTerm
# =============================================================================

install_wezterm() {
    if command_exists wezterm; then
        log_ok "WezTerm already installed ($(wezterm --version))"
        return
    fi
    log_info "Installing WezTerm..."

    sudo apt install -y lsb-release software-properties-common apt-transport-https
    local wezterm_gpg="/usr/share/keyrings/wezterm-fury.gpg"
    curl -fsSL https://apt.fury.io/wez/gpg.key | \
        sudo gpg --yes --dearmor -o "$wezterm_gpg"
    sudo chmod 644 "$wezterm_gpg"
    echo "deb [signed-by=$wezterm_gpg] https://apt.fury.io/wez/ * *" | \
        sudo tee /etc/apt/sources.list.d/wezterm.list
    sudo apt update -y
    sudo apt install -y wezterm
    log_ok "WezTerm installed"
}

# =============================================================================
# 5. Ghostty
# =============================================================================

install_ghostty() {
    if command_exists ghostty; then
        log_ok "Ghostty already installed"
        return
    fi
    log_info "Installing Ghostty..."

    # Ghostty is in the Ubuntu repos starting with oracular (24.10).
    # On older releases, install from the PPA.
    sudo apt install -y ghostty 2>/dev/null || {
        sudo apt install -y software-properties-common
        sudo add-apt-repository -y ppa:ghostty/stable
        sudo apt update -y
        sudo apt install -y ghostty
    }
    log_ok "Ghostty installed"
}

# =============================================================================
# 6. Vim
# =============================================================================

install_vim() {
    if command_exists vim; then
        log_ok "Vim already installed"
        return
    fi
    log_info "Installing Vim..."
    sudo apt install -y vim
    log_ok "Vim installed"
}

# =============================================================================
# 7. Neovim (latest for LazyVim)
# =============================================================================

install_neovim() {
    if command_exists nvim; then
        local nvim_version
        nvim_version=$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
        if [[ "$nvim_version" != "unknown" ]]; then
            local major minor
            major=$(echo "$nvim_version" | cut -d. -f1)
            minor=$(echo "$nvim_version" | cut -d. -f2)
            if [[ -z "$major" || -z "$minor" ]] || (( major > 0 || minor >= 11 )); then
                log_ok "Neovim already installed ($nvim_version — meets LazyVim requirement >= 0.11.2)"
                return
            fi
        fi
        log_warn "Neovim version too old for LazyVim. Upgrading..."
    fi
    log_info "Installing Neovim (latest stable via PPA)..."
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo apt update -y
    sudo apt install -y neovim
    log_ok "Neovim installed"
}

install_lazyvim() {
    local nvim_config_dir="$HOME/.config/nvim"
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # If this repo already has a LazyVim config (init.lua exists), just symlink it
    if [[ -f "$script_dir/nvim/init.lua" ]]; then
        log_ok "LazyVim config exists in this repo. Symlinking via stow."
        return
    fi

    # Fresh install: clone the LazyVim starter
    if [[ -d "$nvim_config_dir" && -f "$nvim_config_dir/init.lua" ]]; then
        log_ok "LazyVim config already exists at $nvim_config_dir"
        return
    fi
    log_info "Setting up LazyVim..."
    if [[ -L "$nvim_config_dir" ]]; then
        rm "$nvim_config_dir"
    elif [[ -d "$nvim_config_dir" ]]; then
        mv "$nvim_config_dir" "${nvim_config_dir}.bak.$(date +%s)"
    fi
    git clone https://github.com/LazyVim/starter "$nvim_config_dir"
    rm -rf "$nvim_config_dir/.git"
    log_ok "LazyVim starter installed. Run nvim to initialize plugins."
}

# =============================================================================
# 8. Curl (already a prerequisite, but explicit)
# =============================================================================

install_curl() {
    if command_exists curl; then
        log_ok "Curl already installed"
        return
    fi
    log_info "Installing Curl..."
    sudo apt install -y curl
    log_ok "Curl installed"
}

# =============================================================================
# 9. VSCode
# =============================================================================

install_vscode() {
    if command_exists code; then
        log_ok "VSCode already installed"
        return
    fi
    log_info "Installing VSCode..."
    sudo mkdir -p /etc/apt/keyrings
    local keyring="/etc/apt/keyrings/packages.microsoft.gpg"
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | \
        gpg --dearmor | sudo tee "$keyring" > /dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=$keyring] https://packages.microsoft.com/repos/code stable main" | \
        sudo tee /etc/apt/sources.list.d/vscode.list
    sudo apt update -y
    sudo apt install -y code
    log_ok "VSCode installed"
}

# =============================================================================
# 10. Python
# =============================================================================

install_python() {
    if command_exists python3; then
        log_ok "Python3 already installed ($(python3 --version))"
        return
    fi
    log_info "Installing Python3..."
    sudo apt install -y python3 python3-pip python3-venv
    log_ok "Python3 installed"
}

# =============================================================================
# 11. Node.js (via NodeSource LTS)
# =============================================================================

install_node() {
    if command_exists node; then
        log_ok "Node.js already installed ($(node --version))"
        return
    fi
    log_info "Installing Node.js LTS via NodeSource..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs

    # Configure npm to use a fixed user-writable prefix so global installs
    # (gemini, yarn, etc.) don't require sudo and work from any shell.
    # NVM stores globals under its version-specific path (unreachable from
    # Nushell). A fixed prefix avoids this entirely.
    local npm_prefix="$HOME/.npm-global"
    if ! grep -q "^prefix=" "$HOME/.npmrc" 2>/dev/null; then
        echo "prefix=$npm_prefix" >> "$HOME/.npmrc"
    fi
    mkdir -p "$npm_prefix/bin" "$npm_prefix/lib"

    log_ok "Node.js installed ($(node --version))"
}

# =============================================================================
# 12. VLC
# =============================================================================

install_vlc() {
    if command_exists vlc; then
        log_ok "VLC already installed"
        return
    fi
    log_info "Installing VLC..."
    sudo apt install -y vlc
    log_ok "VLC installed"
}

# =============================================================================
# 13. Brave Browser
# =============================================================================

install_brave() {
    if command_exists brave-browser; then
        log_ok "Brave already installed"
        return
    fi
    log_info "Installing Brave Browser..."
    # Remove any existing Brave sources first to avoid duplicate warnings
    sudo rm -f /etc/apt/sources.list.d/brave-browser-release.sources 2>/dev/null
    sudo rm -f /etc/apt/sources.list.d/brave-browser-release.list 2>/dev/null
    local keyring="/usr/share/keyrings/brave-browser-archive-keyring.gpg"
    sudo curl -fsSLo "$keyring" https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=$keyring arch=$(dpkg --print-architecture)] https://brave-browser-apt-release.s3.brave.com/ stable main" | \
        sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update -y
    sudo apt install -y brave-browser
    log_ok "Brave installed"
}

# =============================================================================
# 14. Git
# =============================================================================

install_git() {
    if command_exists git; then
        log_ok "Git already installed ($(git --version))"
        return
    fi
    log_info "Installing Git..."
    sudo apt install -y git
    log_ok "Git installed"
}

# =============================================================================
# 15. GitHub CLI
# =============================================================================

install_gh() {
    if command_exists gh; then
        log_ok "GitHub CLI already installed ($(gh --version))"
        return
    fi
    log_info "Installing GitHub CLI..."
    (type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
        && sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O"$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
        && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
        && sudo mkdir -p -m 755 /etc/apt/sources.list.d \
        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
            sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
        && sudo apt update -y \
        && sudo apt install -y gh
    log_ok "GitHub CLI installed"
}

# =============================================================================
# 16. Gemini CLI
# =============================================================================

install_gemini_cli() {
    if command_exists gemini; then
        log_ok "Gemini CLI already installed"
        return
    fi
    if ! command_exists npm; then
        log_warn "npm not found. Install Node.js first."
        return
    fi
    log_info "Installing Gemini CLI..."
    npm i -g @google/gemini-cli
    log_ok "Gemini CLI installed"
}

setup_gemini_config() {
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local gemini_root="$HOME/.gemini"
    local repo_gemini="$script_dir/ai/gemini"
    
    log_info "Configuring Gemini CLI from ai/gemini..."
    mkdir -p "$gemini_root"

    # Files/Folders to link from repo to ~/.gemini
    # We link specific items to avoid overwriting local state like history/creds
    local items=("GEMINI.md" "settings.json" "agents" "skills")

    for item in "${items[@]}"; do
        local target="$gemini_root/$item"
        local source="$repo_gemini/$item"
        
        if [[ -e "$source" ]]; then
            if [[ -L "$target" ]]; then
                ln -sf "$source" "$target"
            elif [[ -e "$target" ]]; then
                mv "$target" "$target.bak.$(date +%s)"
                ln -sf "$source" "$target"
            else
                ln -sf "$source" "$target"
            fi
        fi
    done

    log_ok "Gemini CLI config linked to ai/gemini"
}

# =============================================================================
# 17. OpenCode CLI
# =============================================================================

install_opencode() {
    if command_exists opencode; then
        log_ok "OpenCode CLI already installed"
        return
    fi
    log_info "Installing OpenCode CLI..."
    curl -fsSL https://opencode.ai/install | bash
    log_ok "OpenCode CLI installed"
}

# =============================================================================
# 18. Graphify
# =============================================================================

install_graphify() {
    if command_exists graphify; then
        log_ok "Graphify already installed"
        return
    fi
    if ! command_exists python3; then
        log_warn "Python3 not found. Install Python first."
        return
    fi
    log_info "Installing Graphify..."
    if command_exists uv; then
        uv tool install graphifyy
    elif command_exists pipx; then
        pipx install graphifyy
    else
        pip3 install --user graphifyy
    fi
    log_ok "Graphify installed"
}

install_obsidian() {
    if command_exists obsidian; then
        log_ok "Obsidian already installed"
        return
    fi
    log_info "Installing Obsidian..."
    local install_dir="$HOME/.local/bin"
    mkdir -p "$install_dir"
    local appimage="$install_dir/Obsidian.AppImage"
    if [[ -f "$appimage" ]]; then
        log_ok "Obsidian AppImage already exists"
        return
    fi
    local latest_url
    latest_url=$(curl -fsSL https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | \
        grep -o '"browser_download_url":.*obsidian.*\.AppImage' | head -1 | cut -d'"' -f4)
    if [[ -z "$latest_url" ]]; then
        log_warn "Could not find Obsidian AppImage URL. Install manually."
        return
    fi
    curl -fsSL "$latest_url" -o "$appimage"
    chmod +x "$appimage"
    log_ok "Obsidian installed to $appimage"
}

install_cli_tools() {
    log_info "Installing essential CLI tools..."

    # Handle bat separately — package is `batcat` on older Ubuntu, `bat` on 24.04+
    if ! command_exists bat && ! command_exists batcat; then
        sudo apt install -y batcat 2>/dev/null || sudo apt install -y bat
    fi

    local tools=(
        fzf
        fd-find
        ripgrep
        zoxide
        delta
        eza
        lazygit
        btop
    )
    local missing=()
    for tool in "${tools[@]}"; do
        local cmd="$tool"
        if [[ "$tool" == "fd-find" ]]; then cmd="fdfind"; fi
        if ! command_exists "$cmd"; then
            missing+=("$tool")
        fi
    done
    if [[ ${#missing[@]} -eq 0 ]]; then
        log_ok "All CLI tools already installed"
        return
    fi
    sudo apt install -y "${missing[@]}"
    # Create symlinks for tools with different apt names
    if command_exists fdfind && ! command_exists fd; then
        sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
    fi
    if command_exists batcat && ! command_exists bat; then
        sudo ln -sf "$(which batcat)" /usr/local/bin/bat
    fi
    log_ok "CLI tools installed: ${missing[*]}"
}

install_starship() {
    if command_exists starship; then
        log_ok "Starship already installed ($(starship --version))"
        return
    fi
    log_info "Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh
    log_ok "Starship installed"
}

install_zellij() {
    if command_exists zellij; then
        log_ok "Zellij already installed ($(zellij --version))"
        return
    fi
    log_info "Installing Zellij..."
    if command_exists cargo; then
        cargo install --locked zellij
    else
        log_warn "Cargo not found. Installing Zellij via curl..."
        curl -L https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | \
            sudo tar xz -C /usr/local/bin zellij
    fi
    log_ok "Zellij installed"
}

install_atuin() {
    if command_exists atuin; then
        log_ok "Atuin already installed ($(atuin --version))"
        return
    fi
    log_info "Installing Atuin..."
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
    log_ok "Atuin installed"
}

install_television() {
    if command_exists tv; then
        log_ok "Television already installed"
        return
    fi
    log_info "Installing Television..."
    if command_exists cargo; then
        cargo install television --locked
    else
        log_warn "Cargo not found. Install Television manually from https://github.com/alexpasmantier/television"
        return
    fi
    log_ok "Television installed"
}

install_direnv() {
    if command_exists direnv; then
        log_ok "direnv already installed"
        return
    fi
    log_info "Installing direnv..."
    sudo apt install -y direnv
    log_ok "direnv installed"
}

install_power_tools() {
    if ! command_exists uv; then
        log_info "Installing uv..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
        log_ok "uv installed"
    else
        log_ok "uv already installed"
    fi

    if ! command_exists pandoc; then
        log_info "Installing Pandoc..."
        sudo apt install -y pandoc
        log_ok "Pandoc installed"
    else
        log_ok "Pandoc already installed"
    fi
}

customize_gnome_terminal() {
    if ! command_exists gsettings; then
        log_warn "gsettings not found. Skipping GNOME Terminal customization."
        return
    fi
    log_info "Applying Catppuccin Mocha to GNOME Terminal..."
    sudo apt install -y dconf-cli 2>/dev/null || true

    local profile_id
    profile_id=$(dconf read /org/gnome/terminal/legacy/profiles:/default 2>/dev/null)
    if [[ -z "$profile_id" ]]; then
        profile_id=$(dconf list /org/gnome/terminal/legacy/profiles:/ | head -1 | tr -d '/')
    fi
    if [[ -z "$profile_id" ]]; then
        log_warn "No GNOME Terminal profile found. Skipping customization."
        return
    fi

    local path="/org/gnome/terminal/legacy/profiles:/:${profile_id}/"

    dconf write "${path}visible-name" "'Catppuccin Mocha'"
    dconf write "${path}use-theme-colors" "false"
    dconf write "${path}foreground-color" "'#cdd6f4'"
    dconf write "${path}background-color" "'#1e1e2e'"
    dconf write "${path}cursor-colors-set" "true"
    dconf write "${path}cursor-foreground-color" "'#1e1e2e'"
    dconf write "${path}cursor-background-color" "'#f5e0dc'"
    dconf write "${path}palette" "['#45475a', '#f38ba8', '#a6e3a1', '#f9e2af', '#89b4fa', '#f5c2e7', '#94e2d5', '#bac2de', '#585b70', '#f38ba8', '#a6e3a1', '#f9e2af', '#89b4fa', '#f5c2e7', '#94e2d5', '#a6adc8']"
    dconf write "${path}bold-is-bright" "true"
    dconf write "${path}font" "'JetBrainsMono Nerd Font 15'"
    dconf write "${path}use-system-font" "false"

    log_info "Setting system monospace font..."
    gsettings set org.gnome.desktop.interface monospace-font-name "JetBrainsMono Nerd Font 14"

    log_ok "GNOME Terminal customized with Catppuccin Mocha"
}

# =============================================================================
# 19. JetBrainsMono Nerd Font (full family, system-wide)
# =============================================================================

install_nerd_font() {
    local font_dir="/usr/local/share/fonts/JetBrainsMonoNerd"
    local marker="$font_dir/.installed"
    if [[ -f "$marker" ]]; then
        log_ok "JetBrainsMono Nerd Font family already installed system-wide"
        return
    fi
    log_info "Installing JetBrainsMono Nerd Font (full family) system-wide..."
    sudo mkdir -p "$font_dir"
    local font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.tar.xz"
    local temp_dir
    temp_dir=$(mktemp -d)
    curl -fsSL "$font_url" -o "$temp_dir/fonts.tar.xz"
    tar -xf "$temp_dir/fonts.tar.xz" -C "$temp_dir"

    # Copy ALL ttf files from the archive (Regular, Bold, Italic, all weights)
    local found=0
    for f in "$temp_dir"/ttf/*.ttf "$temp_dir"/*.ttf; do
        if [[ -f "$f" ]]; then
            sudo cp "$f" "$font_dir/"
            found=$((found + 1))
        fi
    done

    rm -rf "$temp_dir"
    sudo touch "$marker"
    fc-cache -fv
    log_ok "JetBrainsMono Nerd Font installed ($found files system-wide)"
}

# =============================================================================
# 20. Catppuccin GTK Theme (system-wide for all GTK apps)
# =============================================================================

install_catppuccin_gtk() {
    local theme_dir="/usr/share/themes/Catppuccin-Mocha"
    if [[ -d "$theme_dir" ]]; then
        log_ok "Catppuccin GTK theme already installed"
        return
    fi
    log_info "Installing Catppuccin Mocha GTK theme system-wide..."

    if ! command_exists unzip; then
        sudo apt install -y unzip
    fi
    if ! command_exists bsdtar; then
        sudo apt install -y bsdtar 2>/dev/null || true
    fi

    local temp_dir
    temp_dir=$(mktemp -d)
    curl -fsSL "https://github.com/catppuccin/gtk/releases/latest/download/catppuccin-mocha-lavender-standard+default.zip" \
        -o "$temp_dir/theme.zip" 2>/dev/null || \
    curl -fsSL "https://github.com/catppuccin/gtk/releases/latest/download/catppuccin-mocha-blue-standard+default.zip" \
        -o "$temp_dir/theme.zip" 2>/dev/null || {
        log_warn "Could not download Catppuccin GTK theme. Trying manual install..."
        rm -rf "$temp_dir"
        install_catppuccin_gtk_manual
        return
    }

    if ! unzip -q "$temp_dir/theme.zip" -d "$temp_dir"; then
        log_warn "Could not extract Catppuccin GTK theme. Trying manual install..."
        rm -rf "$temp_dir"
        install_catppuccin_gtk_manual
        return
    fi
    # Find the extracted theme directory
    local extracted
    extracted=$(find "$temp_dir" -maxdepth 2 -name "gtk-4.0" -type d | head -1 | xargs dirname)
    if [[ -d "$extracted" ]]; then
        sudo cp -r "$extracted" "$theme_dir"
    else
        # Fallback: copy everything that looks like a theme
        local candidate
        candidate=$(find "$temp_dir" -maxdepth 2 -name "index.theme" -type f | head -1 | xargs dirname)
        if [[ -d "$candidate" ]]; then
            sudo cp -r "$candidate" "$theme_dir"
        fi
    fi
    rm -rf "$temp_dir"

    # Apply the theme system-wide
    if command_exists gsettings; then
        gsettings set org.gnome.desktop.interface gtk-theme "Catppuccin-Mocha" 2>/dev/null || true
        gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" 2>/dev/null || true
    fi

    log_ok "Catppuccin Mocha GTK theme installed and applied"
}

install_catppuccin_gtk_manual() {
    log_warn "The catppuccin/gtk repository has been archived."
    log_info "Trying direct download with explicit URL..."
    local theme_dir="/usr/share/themes/Catppuccin-Mocha"
    if [[ -d "$theme_dir" ]]; then
        log_ok "Catppuccin GTK theme already exists"
        return
    fi

    if ! command_exists unzip; then
        sudo apt install -y unzip
    fi

    local temp_dir
    temp_dir=$(mktemp -d)
    # Try with the known release zip URLs directly
    curl -fsSL "https://github.com/catppuccin/gtk/releases/download/v1.0.3/catppuccin-mocha-lavender-standard+default.zip" \
        -o "$temp_dir/theme.zip" 2>/dev/null || \
    curl -fsSL "https://github.com/catppuccin/gtk/releases/download/v1.0.3/catppuccin-mocha-blue-standard+default.zip" \
        -o "$temp_dir/theme.zip" 2>/dev/null || {
        log_warn "Could not download Catppuccin GTK theme."
        log_info "Install manually: download from https://github.com/catppuccin/gtk/releases/tag/v1.0.3"
        rm -rf "$temp_dir"
        return
    }

    if ! unzip -q "$temp_dir/theme.zip" -d "$temp_dir"; then
        log_warn "Could not extract Catppuccin GTK theme."
        log_info "Install manually: download from https://github.com/catppuccin/gtk/releases/tag/v1.0.3"
        rm -rf "$temp_dir"
        return
    fi
    local extracted
    extracted=$(find "$temp_dir" -maxdepth 2 -name "gtk-4.0" -type d | head -1 | xargs dirname)
    if [[ -d "$extracted" ]]; then
        sudo cp -r "$extracted" "$theme_dir"
    else
        local candidate
        candidate=$(find "$temp_dir" -maxdepth 2 -name "index.theme" -type f | head -1 | xargs dirname)
        if [[ -d "$candidate" ]]; then
            sudo cp -r "$candidate" "$theme_dir"
        fi
    fi
    rm -rf "$temp_dir"

    if command_exists gsettings; then
        gsettings set org.gnome.desktop.interface gtk-theme "Catppuccin-Mocha" 2>/dev/null || true
        gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" 2>/dev/null || true
    fi

    log_ok "Catppuccin Mocha GTK theme installed (manual)"
}

# =============================================================================
# 21. Catppuccin Cursor Theme (system-wide)
#
# Note: Catppuccin does not provide a desktop icon theme.
# For Catppuccin-colored file/folder icons, install Papirus + papirus-folders.
# =============================================================================

install_catppuccin_cursors() {
    local cursor_dir="/usr/share/icons/catppuccin-mocha-lavender-cursors"
    if [[ -d "$cursor_dir" ]]; then
        log_ok "Catppuccin cursor theme already installed"
        return
    fi
    log_info "Installing Catppuccin Mocha Lavender cursor theme..."

    local temp_dir
    temp_dir=$(mktemp -d)
    if ! curl -fsSL "https://github.com/catppuccin/cursors/releases/latest/download/catppuccin-mocha-lavender-cursors.zip" \
        -o "$temp_dir/cursors.zip"; then
        log_warn "Could not download Catppuccin cursors. Skipping."
        log_info "Install manually from https://github.com/catppuccin/cursors/releases"
        rm -rf "$temp_dir"
        return
    fi

    sudo unzip -q "$temp_dir/cursors.zip" -d /usr/share/icons/
    rm -rf "$temp_dir"

    if command_exists gsettings; then
        gsettings set org.gnome.desktop.interface cursor-theme "catppuccin-mocha-lavender-cursors" 2>/dev/null || true
    fi

    log_ok "Catppuccin cursor theme installed"
}

# =============================================================================
# 22. VSCode Catppuccin Theme
# =============================================================================

install_vscode_catppuccin() {
    if ! command_exists code; then
        log_warn "VSCode not installed. Skipping VSCode theme."
        return
    fi
    log_info "Installing Catppuccin theme for VSCode..."
    # Check if already installed
    if code --list-extensions 2>/dev/null | grep -q "catppuccin.catppuccin-vsc"; then
        log_ok "Catppuccin VSCode theme already installed"
        return
    fi
    code --install-extension catppuccin.catppuccin-vsc 2>/dev/null || {
        log_warn "Could not install Catppuccin VSCode theme. Install manually."
        return
    }

    # Set as active theme
    local vscode_dir="$HOME/.config/Code/User"
    mkdir -p "$vscode_dir"
    local settings="$vscode_dir/settings.json"
    if [[ -f "$settings" ]]; then
        # Add theme settings if not present
        if ! grep -q "workbench.colorCustomizations" "$settings" 2>/dev/null; then
            # Use python3 or jq to safely modify JSON
            if command_exists python3; then
                python3 -c "
import json, sys
with open('$settings', 'r') as f:
    try:
        data = json.load(f)
    except:
        data = {}
data['workbench.colorTheme'] = 'Catppuccin Mocha'
data['workbench.iconTheme'] = 'catppuccin-mocha'
with open('$settings', 'w') as f:
    json.dump(data, f, indent=2)
" 2>/dev/null
            fi
        fi
    else
        cat > "$settings" << 'EOF'
{
  "workbench.colorTheme": "Catppuccin Mocha",
  "workbench.iconTheme": "catppuccin-mocha"
}
EOF
    fi

    log_ok "Catppuccin VSCode theme installed and activated"
}

# =============================================================================
# 23. Firefox/Brave Catppuccin Theme
# =============================================================================

install_browser_catppuccin() {
    log_info "Installing Catppuccin themes for browsers..."

    # Firefox userChrome.css for Catppuccin
    local firefox_dir="$HOME/.mozilla/firefox"
    if [[ -d "$firefox_dir" ]]; then
        local profile
        profile=$(find "$firefox_dir" -maxdepth 1 -name "*.default*" -type d | head -1)
        if [[ -n "$profile" ]]; then
            local chrome_dir="$profile/chrome"
            mkdir -p "$chrome_dir"
            log_ok "Firefox profile found. Add Catppuccin userChrome.css manually from https://github.com/catppuccin/firefox"
        fi
    fi

    # Brave/Chrome: install Catppuccin extension
    if command_exists brave-browser; then
        log_info "To add Catppuccin to Brave, install: https://chrome.google.com/webstore/detail/catppuccin-mocha-theme"
    fi

    log_ok "Browser theme instructions provided"
}

# =============================================================================
# 24. System-wide GTK/Qt dark mode settings
# =============================================================================

apply_system_dark_mode() {
    log_info "Applying system-wide dark mode..."

    if command_exists gsettings; then
        gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" 2>/dev/null || true
        gsettings set org.gnome.desktop.interface gtk-theme "Catppuccin-Mocha" 2>/dev/null || true
        gsettings set org.gnome.desktop.interface font-name "JetBrainsMono Nerd Font 11" 2>/dev/null || true
        gsettings set org.gnome.desktop.interface monospace-font-name "JetBrainsMono Nerd Font 14" 2>/dev/null || true
        gsettings set org.gnome.desktop.interface document-font-name "JetBrainsMono Nerd Font 11" 2>/dev/null || true
        log_ok "GNOME dark mode and fonts applied"
    fi

    # Qt5/Qt6 dark mode
    if [[ -f "$HOME/.config/qt5ct/qt5ct.conf" ]] || command_exists qt5ct; then
        mkdir -p "$HOME/.config/qt5ct"
        cat > "$HOME/.config/qt5ct/qt5ct.conf" << 'EOF'
[Appearance]
style=gtk2
color_scheme=catppuccin_mocha
# No Catppuccin icon theme exists; Qt5 falls back to the system default.
EOF
        log_ok "Qt5 dark mode configured"
    fi

    # Set QT_QPA_PLATFORMTHEME for Qt apps to use GTK theme
    if ! grep -q "QT_QPA_PLATFORMTHEME" "$HOME/.profile" 2>/dev/null; then
        echo 'export QT_QPA_PLATFORMTHEME=gtk3' >> "$HOME/.profile"
        log_ok "Qt platform theme set to gtk3"
    fi

    log_ok "System-wide dark mode applied"
}

# =============================================================================
# 25. Symlink Dotfiles
# =============================================================================

symlink_dotfiles() {
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    log_info "Symlinking dotfiles from $script_dir..."
    cd "$script_dir"

    # Clean up broken symlinks first
    local broken_links=(
        "$HOME/.config/tools"
        "$HOME/.config/terminals"
        "$HOME/.config/shells"
        "$HOME/.config/nvim"
        "$HOME/.config/starship.toml"
        "$HOME/.tmux.conf"
        "$HOME/.editorconfig"
    )
    for link in "${broken_links[@]}"; do
        if [[ -L "$link" && ! -e "$link" ]]; then
            rm -f "$link"
        fi
    done

    # Main configs to ~/.config (all folders except zshrc and ssh, per .stowrc)
    stow --adopt -R . 2>/dev/null || true

    # Force symlink any real directories that stow couldn't adopt
    for dir in atuin gh-dash ghostty nix nushell nvim starship television wezterm zellij; do
        local target="$HOME/.config/$dir"
        local source="$script_dir/$dir"
        if [[ -L "$target" ]]; then
            # Update existing symlink
            ln -sf "$source" "$target"
        elif [[ -d "$target" && ! -L "$target" ]]; then
            # Move unique runtime files aside, symlink, move back
            local tmpdir
            tmpdir=$(mktemp -d)
            # Copy files that aren't in the repo
            if [[ -d "$source" ]]; then
                for f in "$target"/*; do
                    local base
                    base=$(basename "$f")
                    if [[ ! -e "$source/$base" ]]; then
                        cp -a "$f" "$tmpdir/" 2>/dev/null || true
                    fi
                done
            fi
            rm -rf "$target"
            ln -sf "$source" "$target"
            # Restore unique files
            for f in "$tmpdir"/*; do
                cp -a "$f" "$target/" 2>/dev/null || true
            done
            rm -rf "$tmpdir"
        elif [[ ! -e "$target" && -d "$source" ]]; then
            ln -sf "$source" "$target"
        fi
    done

    # OpenCode config (nested in ai/ folder)
    local opencode_target="$HOME/.config/opencode"
    local opencode_source="$script_dir/ai/opencode"
    if [[ -d "$opencode_source" ]]; then
        if [[ -L "$opencode_target" ]]; then
            ln -sf "$opencode_source" "$opencode_target"
        elif [[ -d "$opencode_target" ]]; then
            mv "$opencode_target" "${opencode_target}.bak.$(date +%s)"
            ln -sf "$opencode_source" "$opencode_target"
        else
            ln -sf "$opencode_source" "$opencode_target"
        fi
    fi

    # Zsh config to home directory (~/.zshrc)
    if [[ -f "$script_dir/zshrc/.zshrc" ]]; then
        if [[ -L "$HOME/.zshrc" ]]; then
            ln -sf "$script_dir/zshrc/.zshrc" "$HOME/.zshrc"
        elif [[ -f "$HOME/.zshrc" ]]; then
            mv "$HOME/.zshrc" "$HOME/.zshrc.bak.$(date +%s)"
            ln -sf "$script_dir/zshrc/.zshrc" "$HOME/.zshrc"
        else
            ln -sf "$script_dir/zshrc/.zshrc" "$HOME/.zshrc"
        fi
    fi

    # SSH config to ~/.ssh/config
    if [[ -f "$script_dir/ssh/config" ]]; then
        mkdir -p "$HOME/.ssh"
        if [[ -L "$HOME/.ssh/config" ]]; then
            ln -sf "$script_dir/ssh/config" "$HOME/.ssh/config"
        elif [[ -f "$HOME/.ssh/config" ]]; then
            mv "$HOME/.ssh/config" "$HOME/.ssh/config.bak.$(date +%s)"
            ln -sf "$script_dir/ssh/config" "$HOME/.ssh/config"
        else
            ln -sf "$script_dir/ssh/config" "$HOME/.ssh/config"
        fi
    fi

    log_ok "All dotfiles symlinked"
}

# =============================================================================
# Main
# =============================================================================

main() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  Ubuntu Dotfiles Setup                 ${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""

    require_sudo

    install_prerequisites
    install_curl
    install_git
    install_zsh
    install_nushell
    install_rust
    install_wezterm
    install_ghostty
    install_vim
    install_neovim
    install_lazyvim
    install_vscode
    install_python
    install_node
    install_vlc
    install_brave
    install_gh
    install_gemini_cli
    install_opencode
    install_graphify
    install_obsidian
    install_power_tools
    install_cli_tools
    install_starship
    install_zellij
    install_atuin
    install_television
    install_direnv
    install_nerd_font
    install_catppuccin_gtk
    install_catppuccin_cursors
    install_vscode_catppuccin
    install_browser_catppuccin
    customize_gnome_terminal
    apply_system_dark_mode
    symlink_dotfiles
    setup_gemini_config

    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  Setup Complete!                       ${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    log_info "Required next steps (script cannot do these automatically):"
    log_info "  1. chsh -s \$(which zsh)          — Change default shell to Zsh"
    log_info "  2. nvim                            — Download LazyVim plugins (takes a few mins)"
    log_info "  3. gh auth login                   — Authenticate GitHub CLI"
    log_info "  4. graphify install --platform opencode — Register Graphify"
    echo ""
    log_info "Want Nushell instead? Your shell must be in /etc/shells:"
    log_info "  echo \$(which nu) | sudo tee -a /etc/shells"
    log_info "  chsh -s \$(which nu)"
    echo ""
    log_info "Other things to do after setup:"
    log_info "  - Restart your session (logout/login) for themes to fully apply"
    log_info "  - Run 'direnv allow' in any project that has a .envrc file"
    log_info "  - Reopen your terminal for PATH changes to take effect"
    echo ""
}

main "$@"
