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
# 3. Nushell
# =============================================================================

install_nushell() {
    if command_exists nu; then
        log_ok "Nushell already installed ($(nu --version))"
        return
    fi
    log_info "Installing Nushell..."
    if command_exists cargo; then
        cargo install nu
    else
        log_warn "Cargo not found. Installing Nushell via apt (may be older version)..."
        sudo apt install -y nushell
    fi
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

    local codename
    codename=$(. /etc/os-release && echo "$VERSION_CODENAME")

    if [[ "$codename" == "noble" || "$codename" == "jammy" || "$codename" == "oracular" ]]; then
        sudo apt install -y lsb-release software-properties-common apt-transport-https
        local wezterm_gpg="/usr/share/keyrings/wezterm.gpg"
        wget -qO- https://raw.githubusercontent.com/wez/wezterm/main/keys/wezterm.gpg.key | \
            sudo gpg --dearmor -o "$wezterm_gpg"
        echo "deb [signed-by=$wezterm_gpg] https://raw.githubusercontent.com/wez/wezterm/main/ $codename main" | \
            sudo tee /etc/apt/sources.list.d/wezterm.list
        sudo apt update -y
        sudo apt install -y wezterm
    else
        log_warn "Unsupported Ubuntu version for WezTerm PPA. Installing from apt..."
        sudo apt install -y wezterm 2>/dev/null || \
            log_error "WezTerm installation failed. Try manual install from https://wezfurlong.org/wezterm/install/linux"
    fi
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

    local codename
    codename=$(. /etc/os-release && echo "$VERSION_CODENAME")

    if [[ "$codename" == "oracular" || "$codename" == "plucky" ]]; then
        sudo apt install -y ghostty
    else
        sudo apt install -y software-properties-common
        sudo add-apt-repository -y ppa:ghostty/stable
        sudo apt update -y
        sudo apt install -y ghostty
    fi
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
        nvim_version=$(nvim --version | head -1 | grep -oP '\d+\.\d+\.\d+' || echo "unknown")
        if [[ "$nvim_version" != "unknown" ]]; then
            local major minor
            major=$(echo "$nvim_version" | cut -d. -f1)
            minor=$(echo "$nvim_version" | cut -d. -f2)
            if (( major > 0 || minor >= 11 )); then
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
    if [[ -d "$nvim_config_dir" && -f "$nvim_config_dir/init.lua" ]]; then
        log_ok "LazyVim config already exists at $nvim_config_dir"
        return
    fi
    log_info "Setting up LazyVim..."
    if [[ -d "$nvim_config_dir" ]]; then
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
    local keyring="/etc/apt/keyrings/packages.microsoft.gpg"
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | \
        gpg --dearmor | sudo tee "$keyring" > /dev/null
    echo "deb [arch=amd64 signed-by=$keyring] https://packages.microsoft.com/repos/code stable main" | \
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
    local keyring="/usr/share/keyrings/brave-browser-archive-keyring.gpg"
    sudo curl -fsSLo "$keyring" https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=$keyring arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | \
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
    npm i -g @anthropic-ai/gemini-cli
    log_ok "Gemini CLI installed"
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
        grep -oP '"browser_download_url":.*obsidian.*\.AppImage' | head -1 | cut -d'"' -f4)
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
    local tools=(
        fzf
        fd-find
        ripgrep
        zoxide
        bat
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
    log_ok "CLI tools installed: ${missing[*]}"
}

# =============================================================================
# 19. Nerd Font (for icons in terminals/LazyVim)
# =============================================================================

install_nerd_font() {
    local font_dir="$HOME/.local/share/fonts"
    local font_file="$font_dir/JetBrainsMonoNerdFont-Regular.ttf"
    if [[ -f "$font_file" ]]; then
        log_ok "Nerd Font already installed"
        return
    fi
    log_info "Installing JetBrainsMono Nerd Font..."
    mkdir -p "$font_dir"
    local font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.tar.xz"
    local temp_dir
    temp_dir=$(mktemp -d)
    curl -fsSL "$font_url" -o "$temp_dir/fonts.tar.xz"
    tar -xf "$temp_dir/fonts.tar.xz" -C "$temp_dir"
    cp "$temp_dir"/JetBrainsMonoNerdFont-Regular.ttf "$font_dir/" 2>/dev/null || \
        cp "$temp_dir"/ttf/JetBrainsMonoNerdFont-Regular.ttf "$font_dir/" 2>/dev/null || \
        log_warn "Could not find Nerd Font file in archive. Install manually."
    rm -rf "$temp_dir"
    fc-cache -fv
    log_ok "Nerd Font installed"
}

# =============================================================================
# 20. Symlink Dotfiles
# =============================================================================

symlink_dotfiles() {
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    log_info "Symlinking dotfiles from $script_dir..."
    cd "$script_dir"
    stow .
    log_ok "Dotfiles symlinked"
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
    install_cli_tools
    install_nerd_font
    symlink_dotfiles

    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  Setup Complete!                       ${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    log_info "Run 'gh auth login' to authenticate GitHub CLI"
    log_info "Run 'nvim' to initialize LazyVim plugins"
    log_info "Run 'graphify install --platform opencode' to register Graphify"
    log_info "Consider changing your default shell: chsh -s \$(which zsh)"
    echo ""
}

main "$@"
