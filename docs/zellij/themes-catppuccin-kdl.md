# Zellij Catppuccin Theme — Documentation

**Location:** `zellij/themes/catppuccin.kdl` → `~/.config/zellij/themes/catppuccin.kdl`  
**Purpose:** Defines Catppuccin color themes for Zellij (Frappe, Latte, Macchiato, and Mocha variants)

## What Is This File?

This file contains four variations of the Catppuccin color palette, each designed for different lighting conditions and preferences. The active theme (`catppuccin-mocha`) is selected in `config.kdl`.

## Color Format

Each color is defined as RGB values (0-255):

```kdl
fg 205 214 244    // Foreground (text) color
bg 88 91 112      // Background color
red 243 139 168   // Red accent
```

## Theme Variants

### 1. Catppuccin Frappe (Lines 2-14)
- **Style:** Medium-dark, muted tones
- **Best for:** Low-light environments without extreme contrast
- **Background:** `rgb(98, 104, 128)` — Medium gray-blue
- **Foreground:** `rgb(198, 208, 245)` — Soft white-blue

### 2. Catppuccin Latte (Lines 15-27)
- **Style:** Light theme
- **Best for:** Bright environments, daylight
- **Background:** `rgb(172, 176, 190)` — Light gray
- **Foreground:** `rgb(172, 176, 190)` — Same as background (appears to be a configuration issue — foreground should be darker for contrast)
- **Note:** This variant has identical `fg` and `bg` values, which would make text invisible. This is likely a bug in the original config.

### 3. Catppuccin Macchiato (Lines 28-40)
- **Style:** Dark, slightly cooler than Mocha
- **Best for:** Night coding, reduced eye strain
- **Background:** `rgb(91, 96, 120)` — Dark blue-gray
- **Foreground:** `rgb(202, 211, 245)` — Bright white-blue

### 4. Catppuccin Mocha (Lines 41-53) — **ACTIVE**
- **Style:** Darkest variant, highest contrast
- **Best for:** Default theme — maximum readability
- **Background:** `rgb(88, 91, 112)` — Deep purple-gray
- **Foreground:** `rgb(205, 214, 244)` — Bright white-blue

## Color Palette (Mocha)

| Color Name | RGB Values | Hex | Purpose |
|------------|-----------|-----|---------|
| `fg` | `205 214 244` | `#cdd6f4` | Main text |
| `bg` | `88 91 112` | `#585b70` | Background |
| `black` | `24 24 37` | `#181825` | Darkest elements |
| `red` | `243 139 168` | `#f38ba8` | Errors, deletions |
| `green` | `166 227 161` | `#a6e3a1` | Success, additions |
| `yellow` | `249 226 175` | `#f9e2af` | Warnings |
| `blue` | `137 180 250` | `#89b4fa` | Info, links |
| `magenta` | `245 194 231` | `#f5c2e7` | Highlights |
| `cyan` | `137 220 235` | `#89dceb` | Secondary info |
| `white` | `205 214 244` | `#cdd6f4` | Same as fg |
| `orange` | `250 179 135` | `#fab387` | Accent |

## How to Switch Themes

To use a different variant, edit `zellij/config.kdl` and change:

```kdl
theme "catppuccin-mocha"
```

to:

```kdl
theme "catppuccin-frappe"   // Medium-dark
theme "catppuccin-latte"    // Light (has fg/bg bug)
theme "catppuccin-macchiato" // Dark, cool tones
```
