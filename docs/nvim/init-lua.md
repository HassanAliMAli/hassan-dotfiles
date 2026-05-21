# Neovim Configuration — Documentation

**Location:** `nvim/` → `~/.config/nvim/`  
**Purpose:** Configures Neovim, a modern modal text editor, using LazyVim as a base distribution

## What Is Neovim?

Neovim is a highly extensible text editor that uses modal editing:
- **Normal mode:** Navigate and manipulate text
- **Insert mode:** Type text
- **Visual mode:** Select text
- **Command mode:** Run commands

This configuration uses **LazyVim**, a pre-configured Neovim distribution that provides sensible defaults and a plugin management system.

## Directory Structure

```
nvim/
├── init.lua           # Entry point — bootstraps LazyVim
├── lua/
│   ├── config/        # Core configuration
│   │   ├── options.lua   # Editor options
│   │   ├── keymaps.lua   # Custom keybindings
│   │   ├── lazy.lua      # Plugin manager bootstrap
│   │   └── autocmds.lua  # Auto-commands
│   └── plugins/       # Plugin configurations
│       ├── colorscheme.lua  # Catppuccin Mocha theme
│       ├── opencode.lua     # OpenCode AI integration
│       ├── go.lua           # Go language support
│       ├── conform.lua      # Code formatter
│       └── surround.lua     # Auto-surround text objects
└── lazy-lock.json     # Plugin version lock file
```

## File-by-File Explanation

### `init.lua` (Entry Point)

```lua
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
```

- **What it does:** The only file Neovim reads directly. It loads the `lazy.lua` bootstrap file, which in turn loads LazyVim and all plugins
- **Why so minimal:** LazyVim handles all the heavy lifting

### `lua/config/options.lua` (Editor Options)

```lua
vim.opt.wrap = true
vim.g.codeium_os = "Darwin"
vim.g.codeium_arch = "arm64"
vim.opt.foldmethod = "manual"
```

- **`wrap = true`**: Lines wrap to the next line instead of scrolling horizontally
- **`codeium_os/arch`**: Tells Codeium (AI autocomplete) the platform (macOS ARM)
- **`foldmethod = "manual"`**: Code folding is done manually (not automatic), giving you control over what sections are collapsed

### `lua/config/keymaps.lua` (Custom Keybindings)

```lua
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = false })
vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = false })
```

- **What it does:** In insert mode, typing `jj` or `jk` exits to normal mode
- **Why:** Faster than reaching for the `Esc` key — your fingers stay on the home row
- **Common pattern:** This is a popular vim technique called "home row escape"

### `lua/plugins/colorscheme.lua` (Catppuccin Mocha Theme)

```lua
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
      integrations = {
        telescope = true,
        lazy = true,
        treesitter = true,
        notify = true,
        mini = true,
        lsp_trouble = true,
        which_key = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
```

- **`priority = 1000`**: Load this plugin first (before others) so the theme is ready immediately
- **`flavour = "mocha"`**: The darkest Catppuccin variant
- **`transparent_background = true`**: No background color — shows the terminal's background instead
- **`integrations`**: Apply the theme to other plugins:
  - `telescope`: File finder
  - `lazy`: Plugin manager UI
  - `treesitter`: Syntax highlighting
  - `notify`: Notification popups
  - `mini`: Mini plugins
  - `lsp_trouble`: Error list
  - `which_key`: Keybinding hints
  - `native_lsp`: Language server diagnostics (undercurl = wavy underlines for errors/warnings)

### `lua/plugins/opencode.lua` (OpenCode AI Integration)

```lua
return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    { "folke/snacks.nvim", opts = { input = { enabled = true } } },
  },
  config = function()
    -- ... keymaps below
  end,
}
```

Integrates the OpenCode AI assistant directly into Neovim.

#### OpenCode Keybindings

| Shortcut | Mode | Action |
|----------|------|--------|
| `<leader>ot` | Normal | Toggle embedded OpenCode panel |
| `<leader>oa` | Normal | Ask about code at cursor |
| `<leader>oa` | Visual | Ask about selected text |
| `<leader>o+` | Normal | Add entire buffer to prompt |
| `<leader>o+` | Visual | Add selection to prompt |
| `<leader>oe` | Normal | Explain code at cursor |
| `<leader>on` | Normal | New OpenCode session |
| `Shift+Ctrl+U` | Normal | Scroll messages up half page |
| `Shift+Ctrl+D` | Normal | Scroll messages down half page |
| `<leader>os` | Normal/Visual | Select prompt type |

### Other Plugin Files

| File | Purpose |
|------|---------|
| `go.lua` | Go language support (LSP, debugger, test runner) |
| `conform.lua` | Code formatting (auto-formats on save) |
| `surround.lua` | Auto-surround text objects (add/change/delete quotes, brackets, etc.) |

## Custom Shortcuts Summary

### Editor-Wide
| Shortcut | Mode | Action |
|----------|------|--------|
| `jj` | Insert | Exit to normal mode |
| `jk` | Insert | Exit to normal mode |

### OpenCode AI
| Shortcut | Mode | Action |
|----------|------|--------|
| `<leader>ot` | Normal | Toggle OpenCode panel |
| `<leader>oa` | Normal | Ask about cursor |
| `<leader>oa` | Visual | Ask about selection |
| `<leader>oe` | Normal | Explain code |
| `<leader>on` | Normal | New session |

## Design Decisions

1. **LazyVim base** — Pre-configured distribution with sensible defaults, no need to configure everything from scratch
2. **Catppuccin Mocha** — Matches the rest of the dotfiles ecosystem
3. **Transparent background** — Lets the terminal's background show through
4. **`jj`/`jk` escape** — Home row escape for faster mode switching
5. **OpenCode integration** — AI assistant directly in the editor
6. **Manual folding** — User controls what gets collapsed, not automatic
