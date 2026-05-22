## Goal
- Maintain a complete, self-installing Ubuntu dotfiles repository with every config symlinked to one place (the repo) so all changes are tracked in Git.

## Constraints & Preferences
- Ubuntu (fresh or existing install), universal Catppuccin Mocha theme, JetBrainsMono Nerd Font
- Minimal prompt toggle via `tp` command (not `Ctrl+P` to avoid conflicts)
- Repo stripped of macOS-only configs, legacy references, and useless code
- Deep but non-technical-friendly documentation in both `README.md` and `docs/`
- Every config file symlinked from the repo (`~/.config/` + `~/.zshrc` + `~/.ssh/config`) so editing one place commits everything

## Progress
### Done
- **`ai/` shared folder created** — restructured the repo to be AI-agent-agnostic:
  - Moved all `opencode/` contents into `ai/` (opencode.json, tui.json, agent/, command/, skills/, node_modules/)
  - `opencode/` is now a symlink to `ai/` (so `~/.config/opencode/` → repo/opencode/ → repo/ai/ chain works)
  - Created `ai/settings.json` — Gemini CLI settings with MCP servers (context7, mcp-installer, sequential-thinking, memory)
  - Symlinked `~/.gemini/settings.json` → repo/ai/settings.json
  - Linked all three skills (deep-researcher, graphify, ship) in Gemini via `gemini skills link --consent`
  - Updated `.stowrc` to ignore `opencode` and `ai` (stow doesn't handle symlinks)
  - Updated `setup.sh`: added `setup_gemini_config()` function, updated `symlink_dotfiles()` to handle existing symlink updates
  - Updated `.gitignore` paths from `opencode/` to `ai/`
  - Updated all docs (README.md, docs/README.md, docs/opencode/ docs)
- **Treesitter markdown parsers installed** via headless Neovim (`nvim --headless` with `vim.schedule` + `TSInstallSync`) — all 36 languages installed successfully, no more `render-markdown.nvim` crash on `.md` file open
- **16+ bugs from full line-by-line audit of `setup.sh` (all 1043 lines) fixed and pushed:**
  - WezTerm: removed codename-versioned check (missing `resolute`/26.04), uses Fury repo unconditionally
  - Ghostty: same pattern — removed codename-versioned check, tries apt then PPA fallback
  - `grep -oP` → `grep -oE` with explicit `[0-9]` character classes (lines 75, 167)
  - Redundant `$(which cargo)` → `cargo` (line 75)
  - `cargo install television` → `cargo install television --locked`
  - `bat` removed from main apt tools array; pre-check installs `batcat || bat` for cross-Ubuntu-version compat
  - VS Code: hardcoded `arch=amd64` → `$(dpkg --print-architecture)` for ARM compat
  - Brave: same — hardcoded `arch=amd64` → `$(dpkg --print-architecture)`
  - Neovim: `set -u` crash when version string unparseable — added `[[ -z "$major" || -z "$minor" ]]` guard
  - Catppuccin GTK `unzip` with no error handling → wrapped in `if ! unzip ...; then` (both main and manual fallback functions)
  - Qt5 dark mode: removed `icon_theme=Catppuccin` (no such theme exists; Catppuccin has no icon theme)
  - `install_catppuccin_icons()` renamed to `install_catppuccin_cursors()` — was downloading cursor files into `/usr/share/icons/Catppuccin/` (wrong dir), setting `icon-theme` to a cursor theme dir. Fixed: extracts to `/usr/share/icons/`, sets only `cursor-theme` with correct lowercase name
  - `.stowrc`: `--target=~/.config` → `/home/hassanalimali/.config` (stow doesn't expand `~`). Added `--ignore=docs`.
  - Stray `~/.config/docs` symlink removed (from previous buggy stow run)
- **PATH fixed across all shells:**
  - `nushell/env.nu`: added `~/.cargo/bin`, `~/.opencode/bin`, `~/.npm-global/bin`, `~/.local/bin`; removed stale macOS homebrew paths (`/opt/homebrew/bin`, `/opt/homebrew/sbin`)
  - `zshrc/.zshrc`: replaced redundant hardcoded system paths with `$PATH`; added `~/.opencode/bin`, `~/.npm-global/bin`, `~/.local/bin`
  - `~/.bashrc`: already had `~/.opencode/bin` from opencode installer
- **npm prefix configured in `setup.sh` `install_node()`**: sets prefix to `~/.npm-global/` so `npm i -g` works without sudo and binaries are reachable from any shell (avoids NVM's dynamic version-specific path). Creates `~/.npmrc` with `prefix=$HOME/.npm-global` if not already set.
- **Existing npm globals moved** from `~/.nvm/versions/node/v24.15.0/bin/` to `~/.npm-global/bin/`: `gemini`, `yarn`, `coderabbit-cli-mcp`, `coderabbitai-mcp`
- **Markdown treesitter parser** added via `nvim/lua/plugins/treesitter.lua` — extends LazyVim's `ensure_installed` with `"markdown"` and `"markdown_inline"` (fixes `render-markdown.nvim` crash on every `.md` file open)
- **All docs updated**: `README.md`, `docs/README.md`, `docs/stowrc.md` (complete rewrite), `docs/setup-sh.md`, `docs/nushell/env-nu.md`, `docs/zshrc/zshrc.md`
- **All commits pushed to `main`**: latest before ai/ restructure is `5c29d0a` (treesitter parser fix)

### In Progress
- (none)

### Blocked
- (none)

## Key Decisions
- `setup.sh` does **not** change default shell — `chsh` requires interactive password and could lock user out if broken
- Nushell installed via `apt` instead of `cargo install nu` (30+ min compile time)
- Symlinks use absolute paths (`$script_dir`) instead of relative — guaranteed to work regardless of where repo is cloned
- `zshrc` and `ssh` stowed with explicit `--target=$HOME` instead of default `~/.config` — separate `.stowrc` ignore list
- Runtime files (`vendor/`, `node_modules/`, `history.txt`, `AGENTS.md`, `opencode.jsonc`, `.opencode/`, `.gemini/`, `atuin/atuin-receipt.json`, `ai/skills/graphify/`) excluded from Git via `.gitignore`
- `main` branch is the default (master renamed, deleted remotely)
- **npm prefix** set to fixed `~/.npm-global` instead of NVM's dynamic version-specific path — avoids shell-specific PATH issues
- **Ghostty/WezTerm** install strategy changed from codename-versioned checks to "try apt first, fall back to PPA/repo" — works on all Ubuntu versions including 26.04 `resolute`
- **Architecture detection**: all repo URLs now use `$(dpkg --print-architecture)` instead of hardcoded `amd64`
- **Treesitter parsers** must be installed in headless mode using `vim.schedule()` with `TSInstallSync` — lazy-loading means the command isn't available until the plugin's setup runs
- **AI config shared in `ai/`**: the `opencode/` directory is now a symlink to `ai/`. Both opencode (`~/.config/opencode/`) and Gemini CLI (`~/.gemini/settings.json` → `ai/settings.json`) reference the same folder. Skills in `ai/skills/` are linked for both tools. Only `AGENTS.md` and `GEMINI.md` at repo root remain tool-specific (auto-discovered by filename).
- **`ai/skills/` tracking**: `ship/` and `deep-researcher/` skills are tracked in git; `graphify/` is gitignored (runtime-generated files). Gemini skills are linked via `gemini skills link --consent` pointing to `ai/skills/`.

## Next Steps
- (none — all known issues from the audit have been fixed and docs updated)

## Critical Context
- Repo URL: `https://github.com/HassanAliMAli/hassan-dotfiles` — default branch is now `main`
- **New structure**: `opencode/` is a symlink to `ai/`. The `ai/` folder is the single source of truth for all AI-agent config. `~/.config/opencode/` → repo/opencode/ → repo/ai/ (double symlink chain). `~/.gemini/settings.json` → repo/ai/settings.json
- `setup.sh` uses `set -euo pipefail` and `command_exists` guards for full idempotency
- All config dirs are symlinks: `~/.config/{atuin,gh-dash,ghostty,nix,nushell,nvim,opencode,starship,television,wezterm,zellij}` → repo
- `~/.zshrc` → `zshrc/.zshrc`, `~/.ssh/config` → `ssh/config`
- Catppuccin/gtk repo is ARCHIVED (v1.0.3 final). Zips named `catppuccin-mocha-{accent}-standard+default.zip`. Manual/meson build fallback removed; uses direct download from pinned v1.0.3 release.
- Catppuccin doesn't provide an icon theme — only cursor theme (`catppuccin-mocha-lavender-cursors`) and GTK theme.
- npm prefix set to `~/.npm-global/` — all `npm i -g` binaries go to `~/.npm-global/bin/` (no sudo, works in any shell)
- **Requires `source ~/.config/nushell/env.nu` or shell restart** after dotfiles sync to pick up PATH changes (opencode, cargo, npm-global, local bins)
- `require_sudo` does not proactively prompt — first `sudo apt` call triggers the interactive prompt

## Relevant Files
- `setup.sh`: Idempotent installer — 1098 lines, 30+ functions. Includes `setup_gemini_config()` for linking Gemini config to `ai/`.
- `nvim/lua/plugins/treesitter.lua`: Adds markdown and markdown_inline parsers to nvim-treesitter `ensure_installed`
- `ai/`: AI-agent-agnostic shared config folder (was `opencode/`). Contains:
  - `opencode.json` — OpenCode main config
  - `opencode.jsonc` — OpenCode MCP servers (gitignored, machine-specific)
  - `tui.json` — OpenCode TUI keybinds
  - `settings.json` — Gemini CLI settings (MCP servers, auth config)
  - `agent/` — OpenCode custom agents
  - `command/` — OpenCode custom commands
  - `skills/` — Shared skills (opencode + Gemini both link here)
  - `node_modules/`, `package.json`, `package-lock.json` — MCP deps (gitignored)
- `opencode/` → symlink to `ai/` (tracked in git)
- `~/.gemini/settings.json` → symlinked to `ai/settings.json`
- `~/.gemini/skills/` → linked from `ai/skills/`
- `.stowrc`: Targets `/home/hassanalimali/.config`, ignores `zshrc`, `ssh`, `docs`, `opencode`, `ai`, `.stowrc`, `DS_Store`
- `.gitignore`: Excludes runtime data — `.opencode/`, `atuin/atuin-receipt.json`, `ai/skills/graphify/`, `nushell/vendor/`, `ai/node_modules/`
- `ssh/config`: SSH connection settings (renamed from `ssh-config` for stow)
- `nushell/env.nu`: PATH includes `~/.opencode/bin`, `~/.cargo/bin`, `~/.npm-global/bin`, `~/.local/bin`
- `zshrc/.zshrc`: PATH includes same user-bin dirs plus `$GOPATH/bin`, `$PATH`
- `~/.npmrc`: Contains `prefix=/home/hassanalimali/.npm-global` (set by `install_node` function)
- `AGENTS.md` (this file): Auto-discovered by opencode — contains project rules + session context
- `GEMINI.md`: Auto-discovered by Gemini CLI — contains coding rules
