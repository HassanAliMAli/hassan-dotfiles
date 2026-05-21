# WezTerm Configuration — Documentation

**Location:** `wezterm/wezterm.lua` → `~/.config/wezterm/wezterm.lua`  
**Purpose:** Configures WezTerm, a GPU-accelerated terminal emulator with extensive Lua-based customization

## What Is WezTerm?

WezTerm is a terminal emulator written in Rust. It's configured using Lua (a scripting language), which allows for powerful customization including custom keybindings, color schemes, and window behavior.

## Line-by-Line Explanation

### Line 1: `local wezterm = require 'wezterm'`
- **What it does:** Loads the WezTerm library so we can access its built-in functions and constants
- **Plain English:** "Import WezTerm's toolbox so we can use its features"

### Line 2: `return {`
- **What it does:** Starts returning a configuration table (a Lua dictionary of settings)
- **Plain English:** "Here are all my settings for WezTerm"

### Line 3: `adjust_window_size_when_changing_font_size = false,`
- **What it does:** Prevents the window from resizing when you change the font size
- **Why:** Without this, increasing font size would make the window grow, potentially pushing other windows around. Keeping it fixed maintains your window layout

### Line 4: `-- color_scheme = 'termnial.sexy',`
- **What it does:** This line is commented out (disabled) with `--`
- **What it was:** An alternative color scheme from terminal.sexy (a website for creating terminal themes)
- **Why disabled:** Replaced by Catppuccin Mocha on line 5

### Line 5: `color_scheme = 'Catppuccin Mocha',`
- **What it does:** Sets the terminal color theme to Catppuccin Mocha
- **Visual effect:** Dark purple background with pastel-colored text — the same theme used across all tools in this dotfiles repo
- **Why:** Visual consistency across all terminals, editors, and prompts

### Line 6: `enable_tab_bar = false,`
- **What it does:** Hides the tab bar at the top of the window
- **Why:** WezTerm has its own tab system, but this user prefers to use Zellij (a terminal multiplexer) for tab management instead. Having two tab systems would be redundant

### Line 7: `font_size = 16.0,`
- **What it does:** Sets the text size to 16 points
- **Why 16:** A comfortable reading size — large enough to be clear, small enough to fit plenty of content on screen

### Line 8: `font = wezterm.font('JetBrains Mono'),`
- **What it does:** Sets the font family to JetBrains Mono
- **Why JetBrains Mono:** A font designed specifically for code — it has:
  - Ligatures (combines `!=` into `≠`, `=>` into `⇒`, etc.)
  - Clear distinction between similar characters (`0` vs `O`, `1` vs `l` vs `I`)
  - The Nerd Font variant includes icons for git, docker, languages, etc.

### Lines 10-18: Background Image & Opacity (Mostly Commented Out)
These lines show different opacity experiments:
- **Lines 10-14:** A background image with color adjustments (commented out)
- **Line 15:** Opacity at 92% (commented out)
- **Line 16:** `window_background_opacity = 1.0,` — **Fully opaque** (active)
- **Line 17:** Opacity at 78% (commented out)
- **Line 18:** Opacity at 20% (commented out)

The user settled on 100% opacity (no transparency) for maximum readability.

### Line 19: `window_decorations = 'RESIZE',`
- **What it does:** Only shows the resize border around the window — no title bar, no minimize/maximize/close buttons
- **Why:** Minimal appearance. The window can still be resized by dragging its edges, and closed via keyboard shortcuts or the window manager

### Lines 20-31: Keyboard Shortcuts (`keys`)

#### Lines 21-25: `Ctrl+Q` → Toggle Fullscreen
```lua
{
    key = 'q',
    mods = 'CTRL',
    action = wezterm.action.ToggleFullScreen,
},
```
- **What it does:** Pressing `Ctrl+Q` toggles between fullscreen and windowed mode
- **Why:** Quick way to focus on the terminal without distractions

#### Lines 26-30: `Ctrl+'` → Clear Scrollback
```lua
{
    key = '\'',
    mods = 'CTRL',
    action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
},
```
- **What it does:** Pressing `Ctrl+'` (Control + single quote) clears all previous output from the terminal buffer
- **Why:** Cleans up the terminal when there's too much old output cluttering the screen

### Lines 32-39: Mouse Bindings (`mouse_bindings`)

#### Lines 33-38: `Ctrl+Click` → Open Link
```lua
{
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = wezterm.action.OpenLinkAtMouseCursor,
},
```
- **What it does:** When you `Ctrl+Click` on a URL in the terminal, it opens in your default browser
- **Why:** Convenient way to open links without copying and pasting them

### Line 40: `}`
- Closes the configuration table

## Custom Shortcuts Summary

| Shortcut | Action |
|----------|--------|
| `Ctrl+Q` | Toggle fullscreen mode |
| `Ctrl+'` | Clear all terminal scrollback |
| `Ctrl+Left Click` | Open URL under cursor in browser |

## Design Decisions

1. **No tab bar** — Zellij handles tabs instead
2. **Full opacity** — Maximum readability, no transparency
3. **Minimal window decorations** — Only resize border, no title bar
4. **Catppuccin Mocha** — Matches the rest of the dotfiles ecosystem
5. **JetBrains Mono at 16pt** — Optimized for code readability
