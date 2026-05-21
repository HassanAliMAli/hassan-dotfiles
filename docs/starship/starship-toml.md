# Starship Configuration — Documentation

**Location:** `starship/starship.toml` → `~/.config/starship/starship.toml`  
**Purpose:** Configures Starship, a cross-shell prompt that shows contextual information (git status, language versions, cloud providers)

## What Is Starship?

Starship is a minimal, fast, and customizable prompt that works with any shell (Zsh, Bash, Nushell, Fish). It automatically detects what you're working with and shows relevant info.

## Line-by-Line Explanation

### Lines 1-6: Prompt Structure

```toml
add_newline = false
format = """$directory$character"""
palette = "catppuccin_mocha"
right_format = """$all"""
command_timeout = 1000
```

- **`add_newline = false`**: Don't add an extra blank line before the prompt
- **`format`**: The left prompt shows only the current directory (`$directory`) and the prompt symbol (`$character`)
- **`palette`**: Uses the Catppuccin Mocha color palette defined below
- **`right_format`**: Everything else (git, languages, cloud tools) goes on the right side of the terminal
- **`command_timeout = 1000`**: Wait up to 1000ms (1 second) for slow commands (like git status in large repos) before giving up

### Lines 9-11: Character (Prompt Symbol)

```toml
[character]
vicmd_symbol = "[N] >>>"
success_symbol = '[➜](bold green)'
```

- **`vicmd_symbol`**: When in vi command mode (after pressing `Esc`), shows `[N] >>>`
- **`success_symbol`**: When the last command succeeded, shows a green `➜` arrow

### Lines 13-14: Directory Substitutions

```toml
[directory.substitutions]
'~/tests/starship-custom' = 'work-project'
```

- **What it does:** Replaces long directory paths with shorter names
- **Example:** If you're in `~/tests/starship-custom`, the prompt shows `work-project` instead
- **Why:** Keeps the prompt clean when working in deeply nested directories

### Lines 16-17: Git Branch

```toml
[git_branch]
format = '[$symbol$branch(:$remote_branch)]($style)'
```

- **What it shows:** The current git branch name, and the remote branch if different
- **Example:** `main` or `main:origin/feature`

### Lines 19-23: AWS

```toml
[aws]
format = '[$symbol(profile: "$profile" )(\(region: $region\) )]($style)'
disabled = false
style = 'bold blue'
symbol = " "
```

- **What it shows:** Current AWS profile and region
- **Example:** ` (profile: my-profile) (region: us-east-1)`
- **Why:** Critical for avoiding mistakes — you always know which AWS account you're working with

### Lines 25-26: Go

```toml
[golang]
format = '[ ](bold cyan)'
```

- **What it shows:** The Go language icon when a Go project is detected
- **Why:** Quick visual indicator that you're in a Go project

### Lines 28-33: Kubernetes

```toml
[kubernetes]
symbol = '☸ '
disabled = true
detect_files = ['Dockerfile']
format = '[$symbol$context( \($namespace\))]($style) '
contexts = []
```

- **What it shows:** Current Kubernetes context and namespace
- **`disabled = true`**: Turned off by default (can be enabled when needed)
- **`detect_files`**: Activates when a `Dockerfile` is present
- **Example:** `☸ my-cluster (default)`

### Lines 35-36: Docker

```toml
[docker_context]
disabled = true
```

- **What it does:** Shows the current Docker context
- **`disabled = true`**: Turned off to keep the prompt clean

### Lines 38-64: Catppuccin Mocha Color Palette

Defines all 24 colors of the Catppuccin Mocha theme:

| Color Name | Hex Code | Visual |
|------------|----------|--------|
| `rosewater` | `#f5e0dc` | Warm pink |
| `flamingo` | `#f2cdcd` | Soft pink |
| `pink` | `#f5c2e7` | Bright pink |
| `mauve` | `#cba6f7` | Purple |
| `red` | `#f38ba8` | Coral red |
| `maroon` | `#eba0ac` | Soft red |
| `peach` | `#fab387` | Orange |
| `yellow` | `#f9e2af` | Warm yellow |
| `green` | `#a6e3a1` | Mint green |
| `teal` | `#94e2d5` | Cyan-green |
| `sky` | `#89dceb` | Light blue |
| `sapphire` | `#74c7ec` | Deep blue |
| `blue` | `#89b4fa` | Bright blue |
| `lavender` | `#b4befe` | Light purple |
| `text` | `#cdd6f4` | Main text color |
| `subtext1` | `#bac2de` | Secondary text |
| `subtext0` | `#a6adc8` | Tertiary text |
| `overlay2` | `#9399b2` | Border color |
| `overlay1` | `#7f849c` | Darker border |
| `overlay0` | `#6c7086` | Even darker |
| `surface2` | `#585b70` | Surface highlight |
| `surface1` | `#45475a` | Surface |
| `surface0` | `#313244` | Darker surface |
| `base` | `#1e1e2e` | Background |
| `mantle` | `#181825` | Darker background |
| `crust` | `#11111b` | Darkest |

## Prompt Layout

```
~/projects/my-app                                                         (profile: prod) ☸ cluster (default) 
➜ _
```

- **Left side:** Directory + prompt symbol
- **Right side:** AWS profile, Kubernetes context, Go indicator, and any other detected tools
