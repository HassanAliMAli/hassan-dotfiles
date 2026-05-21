# Nushell env.nu — Documentation

**Location:** `nushell/env.nu` → `~/.config/nushell/env.nu`  
**Purpose:** Environment configuration for Nushell, controlling the prompt, PATH, and environment variables

## What Is env.nu?

In Nushell, `env.nu` is loaded before `config.nu`. It sets up the environment: the command prompt, PATH directories, and environment variables that other tools depend on.

## Custom Prompt Functions (Lines 6-56)

### `create_left_prompt` (Lines 6-18)
Builds the left side of the command prompt:

```nushell
def create_left_prompt [] {
    let dir = match (do -i { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }
```
- **What it does:** Shows the current directory, replacing your home path with `~`
- **Example:** `/home/hassan/projects` becomes `~/projects`

```nushell
    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)"
```
- **What it does:** Colors the path green for normal users, red for administrators
- **Why:** Visual warning when running as root (danger zone!)

```nushell
    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
```
- **What it does:** Colors the `/` separators differently from the directory names

### `create_right_prompt` (Lines 20-36)
Builds the right side of the command prompt:

```nushell
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%x %X')
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")
```
- **What it does:** Shows the current date and time in magenta, with green separators (`/` and `:`), and underlined AM/PM

```nushell
    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }
```
- **What it does:** Shows the exit code of the last command if it failed (non-zero)
- **Example:** If a command fails with error code 1, you see `1` on the right side

### `create_minimal_prompt` (Lines 38-44)
A simpler prompt showing only the directory:

```nushell
def create_minimal_prompt [] {
    let dir = match (do -i { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }
    $"(ansi cyan_bold)($dir) (ansi reset)(ansi green_bold)❯(ansi reset) "
}
```
- **What it does:** Shows the directory in cyan, followed by a green `❯` symbol
- **Used by:** The `toggle_prompt` function to switch to minimal mode

## Prompt Toggle (Lines 46-62)

### `$env.PROMPT_MINIMAL = false` (Line 46)
- **What it does:** A flag tracking whether the minimal prompt is active
- **Default:** `false` (full prompt on startup)

### `toggle_prompt` (Lines 48-62)
```nushell
def --env toggle_prompt [] {
    if $env.PROMPT_MINIMAL {
        $env.PROMPT_MINIMAL = false
        $env.PROMPT_COMMAND = {|| starship prompt }
        $env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }
        print -e $"(ansi green)✓ Full prompt enabled(ansi reset)"
    } else {
        $env.PROMPT_MINIMAL = true
        $env.PROMPT_COMMAND = {|| create_minimal_prompt }
        $env.PROMPT_COMMAND_RIGHT = {|| "" }
        print -e $"(ansi yellow)✓ Minimal prompt enabled (directory only)(ansi reset)"
    }
}
```
- **What it does:** Switches between the full Starship prompt and a minimal directory-only prompt
- **How it works:**
  - If minimal is active → switch to full Starship prompt with right-side info
  - If full is active → switch to minimal prompt (no right side)
- **Feedback:** Prints a confirmation message in green (full) or yellow (minimal)

### `alias tp = toggle_prompt` (Line 64)
- **What it does:** Creates a shorthand `tp` command for `toggle_prompt`

## Prompt Assignment (Lines 66-67)

```nushell
$env.PROMPT_COMMAND = {|| starship prompt }
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }
```
- **What it does:** Sets Starship as the left prompt and the custom time/exit-code function as the right prompt
- **Why Starship:** Starship is a cross-shell prompt that shows git status, language versions, and more

## Prompt Indicators (Lines 70-74)

```nushell
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }
```
- **What they do:** Small symbols shown before each input line
- **`> `**: Normal prompt
- **`: `**: Vi insert mode (when you press `i`)
- **`> `**: Vi normal mode (when you press `Esc`)
- **`::: `**: Multi-line input (when a command spans multiple lines)

## PATH Configuration (Lines 94-99)

```nushell
use std "path add"
path add "/opt/homebrew/bin"
path add "/opt/homebrew/sbin"
path add ($env.HOME | path join ".turso")
path add ($env.HOME | path join ".local/share/mise/shims")
```
- **What it does:** Adds directories to the system PATH so programs in those locations can be run from anywhere
- **Directories added:**
  - `/opt/homebrew/bin` — Homebrew packages (macOS)
  - `/opt/homebrew/sbin` — Homebrew system binaries (macOS)
  - `~/.turso` — Turso database CLI
  - `~/.local/share/mise/shims` — Mise version manager shims

## External Tool Initialization (Lines 104-112)

```nushell
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu
zoxide init nushell | save -f ~/.zoxide.nu
mkdir ~/.cache/mise
^mise activate nu | save -f ~/.cache/mise/init.nu
```
- **What it does:** Generates initialization scripts for Starship, Zoxide, and Mise
- **How it works:** Runs each tool's init command and saves the output to a cache file, which is then sourced in `config.nu`

```nushell
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
```
- **What it does:** Sets up Carapace (autocomplete engine) with bridges from other shells

## Environment Variable (Line 114)

```nushell
$env.EDITOR = "nvim"
```
- **What it does:** Sets the default editor to Neovim
- **Why:** Many tools (git, crontab, etc.) use `$EDITOR` to decide which editor to open

## Custom Shortcuts

| Command | Action |
|---------|--------|
| `tp` | Toggle between full Starship prompt and minimal directory-only prompt |
