# Zsh Configuration — Documentation

**Location:** `zshrc/.zshrc` → `~/.zshrc`  
**Purpose:** Configures Zsh, the default shell on macOS, including plugins, aliases, and the prompt

## What Is Zsh?

Zsh (Z Shell) is an extended version of Bash with additional features like:
- Better autocomplete
- Spell correction
- Shared history across sessions
- Plugin support (oh-my-zsh, etc.)

## Line-by-Line Explanation

### Lines 1-9: Completion Setup

```zsh
setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit
source <(kubectl completion zsh)
complete -C '/usr/local/bin/aws_completer' aws
```

- **`prompt_subst`**: Allow variable substitution in the prompt (needed for dynamic prompts)
- **`matcher-list`**: Make autocomplete case-insensitive (`git` and `GIT` are the same)
- **`bashcompinit`**: Enable Bash completion scripts in Zsh
- **`compinit`**: Initialize Zsh's completion system
- **`kubectl completion`**: Load Kubernetes command completion
- **`aws_completer`**: Load AWS CLI command completion

### Lines 11-17: Autosuggestions

```zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^w' autosuggest-execute
bindkey '^e' autosuggest-accept
bindkey '^u' autosuggest-toggle
bindkey '^L' vi-forward-word
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search
```

- **`zsh-autosuggestions`**: Shows grayed-out suggestions based on history
- **`Ctrl+W`**: Execute the suggestion
- **`Ctrl+E`**: Accept the suggestion (continue typing)
- **`Ctrl+U`**: Toggle suggestions on/off
- **`Ctrl+L`**: Move forward one word (vi-style)
- **`Ctrl+K`**: Previous line or search
- **`Ctrl+J`**: Next line or search

### Lines 19-31: Starship Prompt & Toggle

```zsh
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

toggle_prompt() {
    if [[ "$STARSHIP_CONFIG" == *minimal* ]]; then
        export STARSHIP_CONFIG=~/.config/starship/starship.toml
        echo -e "\033[0;32m✓ Full prompt enabled\033[0m"
    else
        export STARSHIP_CONFIG=~/.config/starship/starship-minimal.toml
        echo -e "\033[0;33m✓ Minimal prompt enabled (directory only)\033[0m"
    fi
}
alias tp=toggle_prompt
```

- **`starship init zsh`**: Initialize the Starship prompt
- **`STARSHIP_CONFIG`**: Points to the full Starship config
- **`toggle_prompt()`**: Switches between full and minimal prompts
- **`tp`**: Shorthand alias for `toggle_prompt`

### Lines 33-40: Environment & Basic Aliases

```zsh
export LANG=en_US.UTF-8
export EDITOR=/opt/homebrew/bin/nvim
alias la=tree
alias cat=bat
```

- **`LANG`**: Set UTF-8 encoding for proper character display
- **`EDITOR`**: Default editor is Neovim
- **`la`**: List directory as a tree
- **`cat`**: Replace `cat` with `bat` (syntax-highlighted cat alternative)

### Lines 41-56: Git Aliases

| Alias | Command | Purpose |
|-------|---------|---------|
| `gc` | `git commit -m` | Commit with message |
| `gca` | `git commit -a -m` | Commit all changes |
| `gp` | `git push origin HEAD` | Push current branch |
| `gpu` | `git pull origin` | Pull from origin |
| `gst` | `git status` | Show status |
| `glog` | Complex format | Graph log with colors |
| `gdiff` | `git diff` | Show changes |
| `gco` | `git checkout` | Switch branches |
| `gb` | `git branch` | List branches |
| `gba` | `git branch -a` | List all branches |
| `gadd` | `git add` | Stage files |
| `ga` | `git add -p` | Stage interactively |
| `gcoall` | `git checkout -- .` | Discard all changes |
| `gr` | `git remote` | List remotes |
| `gre` | `git reset` | Reset changes |

### Lines 58-63: Docker Aliases

| Alias | Command | Purpose |
|-------|---------|---------|
| `dco` | `docker compose` | Docker Compose |
| `dps` | `docker ps` | Running containers |
| `dpa` | `docker ps -a` | All containers |
| `dl` | `docker ps -l -q` | Latest container ID |
| `dx` | `docker exec -it` | Execute in container |

### Lines 65-70: Directory Navigation

| Alias | Command | Purpose |
|-------|---------|---------|
| `..` | `cd ..` | Go up one level |
| `...` | `cd ../..` | Go up two levels |
| `....` | `cd ../../..` | Go up three levels |
| `.....` | `cd ../../../..` | Go up four levels |
| `......` | `cd ../../../../..` | Go up five levels |

### Lines 72-83: Go, Vim, Nmap, PATH

```zsh
export GOPATH=~/go
alias v="nvim"
alias nm="nmap -sC -sV -oN nmap"
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:~/vimpkg/bin:${GOPATH}/bin:~/.cargo/bin
alias cl='clear'
```

- **`GOPATH`**: Go workspace directory
- **`v`**: Open Neovim
- **`nm`**: Nmap scan with default options (save to `nmap` file)
- **`PATH`**: Add Go, Cargo, and custom bin directories

### Lines 85-100: Kubernetes Aliases

| Alias | Command | Purpose |
|-------|---------|---------|
| `k` | `kubectl` | Kubernetes CLI |
| `ka` | `kubectl apply -f` | Apply config |
| `kg` | `kubectl get` | List resources |
| `kd` | `kubectl describe` | Show details |
| `kdel` | `kubectl delete` | Delete resources |
| `kl` | `kubectl logs -f` | Follow logs |
| `kgpo` | `kubectl get pod` | List pods |
| `kgd` | `kubectl get deployments` | List deployments |
| `kc` | `kubectx` | Switch contexts |
| `kns` | `kubens` | Switch namespaces |
| `ke` | `kubectl exec -it` | Execute in pod |
| `kcns` | `kubectl config set-context --current --namespace` | Set namespace |

### Lines 102-106: HTTP & Vi Mode

```zsh
alias http="xh"
bindkey jj vi-cmd-mode
```

- **`http`**: Replace `http` with `xh` (a better HTTP client)
- **`jj`**: Exit insert mode in vi mode (same as Neovim)

### Lines 108-111: Eza (Better ls)

| Alias | Command | Purpose |
|-------|---------|---------|
| `l` | `eza -l --icons --git -a` | Long list with icons and git status |
| `lt` | `eza --tree --level=2 --long --icons --git` | Tree view with details |
| `ltree` | `eza --tree --level=2 --icons --git` | Tree view without details |

### Lines 113-120: Security Tools

| Alias | Command | Purpose |
|-------|---------|---------|
| `gobust` | `gobuster dir ...` | Directory brute-forcing |
| `dirsearch` | `python dirsearch.py ...` | Web directory scanner |
| `massdns` | `massdns ...` | DNS enumeration |
| `server` | `python -m http.server 4445` | Simple HTTP server |
| `tunnel` | `ngrok http 4445` | Expose local server |
| `fuzz` | `ffuf ...` | Web fuzzing |
| `gr` | `gf` | Pattern grep for security |

### Lines 122-124: FZF (Fuzzy Finder)

```zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
```

- **`FZF_DEFAULT_COMMAND`**: Use `fd` (faster find) with hidden files and symlinks
- **`fzf.zsh`**: Load FZF shell integration

### Lines 128-146: Nix & Ranger

```zsh
export NIX_CONF_DIR=$HOME/.config/nix
export PATH=/run/current-system/sw/bin:$PATH

function ranger { ... }
alias rr='ranger'
```

- **`NIX_CONF_DIR`**: Nix configuration directory
- **`ranger` function**: Wraps ranger file manager to change directory after exiting
- **`rr`**: Shorthand for ranger

### Lines 149-153: Navigation Functions

| Function | Purpose |
|----------|---------|
| `cx` | Change directory and list contents |
| `fcd` | Fuzzy-find a directory and cd into it |
| `f` | Fuzzy-find a file and copy its path to clipboard |
| `fv` | Fuzzy-find a file and open in Neovim |

### Lines 155-165: Nix, XDG, Zoxide, Atuin, Direnv

```zsh
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
export XDG_CONFIG_HOME=~/.config
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"
eval "$(direnv hook zsh)"
```

- **Nix daemon**: Load Nix if installed
- **`XDG_CONFIG_HOME`**: Standard config directory location
- **`zoxide`**: Smart `cd` that remembers frequently used directories
- **`atuin`**: Shell history with sync and search
- **`direnv`**: Auto-load environment variables based on directory

## Custom Shortcuts Summary

| Shortcut | Action |
|----------|--------|
| `tp` | Toggle between full and minimal Starship prompt |
| `Ctrl+W` | Execute autosuggestion |
| `Ctrl+E` | Accept autosuggestion |
| `Ctrl+U` | Toggle autosuggestions |
| `jj` | Exit to vi command mode |
