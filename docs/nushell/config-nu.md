# Nushell config.nu — Documentation

**Location:** `nushell/config.nu` → `~/.config/nushell/config.nu`  
**Purpose:** The main configuration file for Nushell, controlling colors, UI behavior, menus, and keyboard shortcuts

## What Is Nushell?

Nushell (or `nu`) is a modern shell that treats output as structured data (tables, records, lists) instead of plain text. This means you can filter, sort, and manipulate command output like a database.

## Color Themes (Lines 1-140)

### `dark_theme` (Lines 9-74)
Defines the color scheme for the dark mode terminal:
- **Primitives:** Basic syntax highlighting colors (white text, green headers, blue empty values)
- **Data types:** Different colors for integers (white), booleans (light cyan), dates (purple), strings (white), etc.
- **Shapes:** Colors for syntax elements like keywords, operators, variables, file paths
- **Search results:** White text on red background for highlighted matches

### `light_theme` (Lines 76-140)
A lighter color scheme for bright environments. Uses darker shades for better contrast on light backgrounds.

## Main Configuration (Lines 142-290)

### `$env.config = {` (Line 142)
Starts the main configuration block. Everything inside controls how Nushell behaves.

### Display Settings
- **`show_banner: false`** (Line 143): Hides the Nushell startup banner
- **`footer_mode: 25`** (Line 216): Shows a footer bar when there are 25+ results
- **`float_precision: 2`** (Line 217): Shows decimal numbers with 2 decimal places
- **`use_ansi_coloring: true`** (Line 219): Enables colored output
- **`edit_mode: vi`** (Line 221): Uses vi-style keyboard shortcuts (press `Esc` for command mode, `i` for insert mode)

### Table Display (Lines 153-165)
Controls how tabular data looks:
- **`mode: rounded`**: Tables have rounded borders
- **`index_mode: always`**: Always show row numbers
- **`show_empty: true`**: Show placeholder text for empty lists/records
- **`padding: { left: 1, right: 1 }`**: One space of padding on each side

### Error Style (Line 167)
- **`error_style: "fancy"`**: Shows detailed, colorized error messages (vs "plain" for screen readers)

### History (Lines 189-194)
- **`max_size: 100_000`**: Keep up to 100,000 commands in history
- **`sync_on_enter: true`**: Save history immediately when you press Enter
- **`file_format: "plaintext"`**: Store history as plain text (not SQLite)
- **`isolation: false`**: Share history across all Nushell sessions

### Autocomplete (Lines 196-207)
- **`case_sensitive: false`**: "Git" and "git" are treated the same
- **`quick: true`**: Auto-select when only one option remains
- **`partial: true`**: Fill in what's common among all matches
- **`algorithm: "prefix"`**: Match from the beginning of words
- **`external.max_results: 100`**: Show up to 100 external command suggestions

### Cursor Shape (Lines 209-213)
- **`emacs: block`**: Block cursor in emacs mode
- **`vi_insert: block`**: Block cursor when typing
- **`vi_normal: underscore`**: Underscore cursor in command mode (visual indicator of mode)

### Shell Integration (Lines 222-249)
Enables terminal features:
- **`osc2`**: Sets window title to current command
- **`osc7`**: Tells terminal the current directory (helps with new tabs)
- **`osc8`**: Shows clickable links in output
- **`osc133`**: Marks prompt/command boundaries for terminal features
- **`osc633`**: VS Code shell integration support

### Hooks (Lines 272-290)
Actions that run automatically:
- **`pre_prompt`**: Before showing the prompt, runs `direnv` (auto-loads environment variables based on directory)
- **`env_change.PWD`**: Runs when you change directories (empty — no action)

## Menus (Lines 292-378)

Defines four autocomplete menus:

### 1. `completion_menu` (Lines 295-311)
- **Layout:** Columnar (items in columns)
- **Columns:** 4 columns wide
- **Style:** Green text, yellow descriptions, underlined matches

### 2. `ide_completion_menu` (Lines 313-345)
- **Layout:** IDE-style popup (like VS Code's autocomplete)
- **Max width:** 50 characters
- **Max height:** 10 rows
- **Border:** Visible border around the popup

### 3. `history_menu` (Lines 346-359)
- **Layout:** Simple list
- **Page size:** 10 items per page
- **Style:** Green text, reversed selection

### 4. `help_menu` (Lines 360-377)
- **Layout:** Description layout (command + explanation)
- **Columns:** 4 columns
- **Selection rows:** 4 visible options

## Keybindings (Lines 380-894)

### Navigation
| Shortcut | Mode | Action |
|----------|------|--------|
| `Tab` | All | Open completion menu |
| `Ctrl+N` | All | Open IDE completion menu |
| `Ctrl+R` | All | Open history menu |
| `F1` | All | Open help menu |
| `Shift+Tab` | All | Previous completion |
| `Ctrl+X` | Emacs | Next page |
| `Ctrl+Z` | Emacs | Undo / Previous page |

### Arrow Keys & Movement
| Shortcut | Mode | Action |
|----------|------|--------|
| `Up/Down` | All | Navigate menu / history |
| `Left/Right` | All | Move cursor / navigate menu |
| `Ctrl+Left` | All | Jump one word left |
| `Ctrl+Right` | All | Jump one word right / accept history hint |
| `Home` / `Ctrl+A` | All | Go to line start |
| `End` / `Ctrl+E` | All | Go to line end / accept history hint |
| `Ctrl+P` | All | Move up in menu |
| `Ctrl+T` | All | Move down in menu |

### Deletion
| Shortcut | Mode | Action |
|----------|------|--------|
| `Backspace` | Emacs/Vi Insert | Delete character backward |
| `Ctrl+Backspace` | Emacs/Vi Insert | Delete word backward |
| `Delete` | Emacs/Vi Insert | Delete character forward |
| `Ctrl+H` | Emacs | Delete character backward |
| `Ctrl+W` | Emacs/Vi Insert | Delete word backward |
| `Ctrl+K` | Emacs | Delete to end of line |
| `Ctrl+U` | Emacs | Delete from start of line |
| `Alt+Backspace` | Emacs | Delete word backward |
| `Alt+D` | Emacs | Delete word forward |

### Clipboard
| Shortcut | Mode | Action |
|----------|------|--------|
| `Ctrl+Y` | Emacs | Paste |
| `Ctrl+Shift+C` | Emacs | Copy selection |
| `Ctrl+Shift+X` | Emacs | Cut selection |
| `Ctrl+Shift+A` | Emacs | Select all |

### Control
| Shortcut | Mode | Action |
|----------|------|--------|
| `Ctrl+C` | All | Cancel command |
| `Ctrl+D` | All | Quit shell |
| `Ctrl+L` | All | Clear screen |
| `Ctrl+O` | All | Open in external editor |
| `Ctrl+Q` | All | Search history |
| `Escape` | All | Exit menu / cancel |
| `Alt+Backspace` | All | Delete one word backward |

### Word Operations
| Shortcut | Mode | Action |
|----------|------|--------|
| `Alt+F` / `Alt+Right` | Emacs | Move word forward |
| `Alt+B` / `Alt+Left` | Emacs | Move word backward |
| `Alt+U` | Emacs | Uppercase word |
| `Alt+L` | Emacs | Lowercase word |
| `Alt+C` | Emacs | Capitalize character |
| `Alt+D` | Emacs | Cut word to right |
| `Ctrl+T` | Emacs | Swap adjacent characters |

## Custom Commands & Aliases (Lines 897-909)

### `cx` (Line 897-900)
```nushell
def --env cx [arg] { cd $arg; ls -l }
```
- **What it does:** Changes to a directory AND lists its contents in one command
- **Usage:** `cx my-project` → goes to `my-project` and shows files

### Aliases (Lines 902-909)
| Alias | Expands To | Purpose |
|-------|-----------|---------|
| `l` | `ls --all` | List all files (including hidden) |
| `c` | `clear` | Clear terminal screen |
| `ll` | `ls -l` | List files in long format |
| `lt` | `eza --tree --level=2 --long --icons --git` | Show directory tree with icons |
| `v` | `nvim` | Open Neovim |
| `as` | `aerospace` | Run Aerospace (macOS window manager — legacy) |
| `asr` | `atuin scripts run` | Run Atuin scripts |
| `oc` | `opencode` | Launch OpenCode AI assistant |

### `ff` (Lines 911-913)
```nushell
def ff [] { aerospace list-windows --all | fzf ... }
```
- **What it does:** Opens a fuzzy finder to switch between Aerospace windows (macOS-only, legacy)

## Git Aliases (Lines 915-930)

| Alias | Full Command | Purpose |
|-------|-------------|---------|
| `gc` | `git commit -m` | Commit with message |
| `gca` | `git commit -a -m` | Commit all changes with message |
| `gp` | `git push origin HEAD` | Push current branch |
| `gpu` | `git pull origin` | Pull from origin |
| `gst` | `git status` | Show working tree status |
| `glog` | Complex git log format | Show formatted graph log |
| `gdiff` | `git diff` | Show changes |
| `gco` | `git checkout` | Switch branches |
| `gb` | `git branch` | List branches |
| `gba` | `git branch -a` | List all branches (including remote) |
| `gadd` | `git add` | Stage files |
| `ga` | `git add -p` | Stage files interactively (patch mode) |
| `gcoall` | `git checkout -- .` | Discard all changes |
| `gr` | `git remote` | List remotes |
| `gre` | `git reset` | Reset changes |

## Kubernetes Aliases (Lines 932-944)

| Alias | Full Command | Purpose |
|-------|-------------|---------|
| `k` | `kubectl` | Kubernetes CLI |
| `ka` | `kubectl apply -f` | Apply config file |
| `kg` | `kubectl get` | List resources |
| `kd` | `kubectl describe` | Show resource details |
| `kdel` | `kubectl delete` | Delete resources |
| `kl` | `kubectl logs -f` | Follow pod logs |
| `kgpo` | `kubectl get pod` | List pods |
| `kgd` | `kubectl get deployments` | List deployments |
| `kc` | `kubectx` | Switch contexts |
| `kns` | `kubens` | Switch namespaces |
| `ke` | `kubectl exec -it` | Execute command in pod |

## Source Files (Lines 946-953)

These lines load external configurations:
- **Line 946:** `source ~/.zoxide.nu` — Zoxide (smart cd) integration
- **Line 947:** `source ~/.cache/carapace/init.nu` — Carapace (autocomplete) integration
- **Line 948:** `source ~/.local/share/atuin/init.nu` — Atuin (history) integration
- **Line 949:** `use ~/.cache/starship/init.nu` — Starship (prompt) integration
- **Line 950:** `use ~/.cache/mise/init.nu` — Mise (version manager) integration

## Environment Variables (Lines 953-955)

- **`$env.DIRENV_LOG_FORMAT = ""`**: Hides direnv's log messages
- **Line 955:** Sources `wt.nu` (worktrunk integration)
