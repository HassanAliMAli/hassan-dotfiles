# Ghostty Configuration — Documentation

**Location:** `ghostty/config` → `~/.config/ghostty/config`  
**Purpose:** Configures Ghostty, a fast, GPU-accelerated terminal emulator

## What Is Ghostty?

Ghostty is a modern terminal emulator built for speed. It uses GPU acceleration for rendering, supports true color, ligatures, and has a minimal configuration format.

## Line-by-Line Explanation

### Line 1: `font-size = 19`
- **What it does:** Sets the text size to 19 points
- **Why 19:** Larger than WezTerm's 16 — Ghostty may render fonts differently, so a slightly larger size ensures readability

### Line 2: `background-blur-radius = 20`
- **What it does:** Applies a blur effect to the terminal background with a radius of 20 pixels
- **Visual effect:** Creates a frosted glass / translucent look where you can vaguely see what's behind the terminal window
- **Why:** Aesthetic preference — adds depth and modern feel to the terminal

### Line 3: `mouse-hide-while-typing = true`
- **What it does:** Hides the mouse cursor while you're typing
- **Why:** Prevents the cursor from blocking your view of the text you're typing. The cursor reappears when you move the mouse

### Line 4: `window-decoration = false`
- **What it does:** Removes the standard window title bar and borders provided by the operating system
- **Visual effect:** The terminal window has no title bar, no minimize/maximize/close buttons — just the terminal content
- **Why:** Cleaner, more minimal appearance. You can still close the window with keyboard shortcuts or your window manager

## Missing Configurations (Not Set)

Ghostty has many other options that are NOT configured here, meaning they use defaults:
- **Font family:** Uses system default (likely the Nerd Font installed by setup.sh)
- **Theme/Colors:** Uses default theme (not Catppuccin — Ghostty may need additional config for that)
- **Opacity:** Fully opaque (no transparency beyond the blur effect)
- **Tab bar:** Default behavior

## Comparison with WezTerm

| Feature | Ghostty | WezTerm |
|---------|---------|---------|
| Font size | 19 | 16 |
| Theme | Default | Catppuccin Mocha |
| Background blur | Yes (20px) | No |
| Window decorations | None | Resize only |
| Tab bar | Default | Disabled |
