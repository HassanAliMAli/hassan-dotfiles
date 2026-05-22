# OpenCode Configuration — Documentation

**Location:** `ai/opencode.json` (also accessible at `opencode/opencode.json` via symlink) → `~/.config/opencode/opencode.json`  
**Purpose:** Main configuration file for the OpenCode AI assistant. Lives in the shared `ai/` folder so the same `.stowrc`-style symlink chain works for both OpenCode and Gemini CLI.

## Line-by-Line Explanation

### Lines 1-2: Schema

```json
{
  "$schema": "https://opencode.ai/config.json",
```

- **What it does:** Links to the JSON schema for validation and editor autocomplete
- **Why:** Your editor knows what fields are valid and can suggest options

### Line 3: Default Model

```json
"model": "opencode/kimi-k2.5",
```

- **What it does:** Sets the default AI model to use
- **`opencode/kimi-k2.5`**: The Kimi K2.5 model via OpenCode's provider
- **Why this model:** Balanced between speed, quality, and cost

### Line 4: Auto-Update

```json
"autoupdate": true,
```

- **What it does:** Automatically updates OpenCode to the latest version when available
- **Why:** Always have the latest features and bug fixes without manual updates

## Available Configuration Options

While this file is minimal, OpenCode supports many more options:

| Option | Type | Purpose |
|--------|------|---------|
| `model` | string | Default AI model |
| `autoupdate` | boolean | Auto-update on startup |
| `theme` | string | Default UI theme |
| `layout` | string | UI layout preset |
| `commands` | object | Custom slash commands |
| `agents` | object | Custom agent configurations |
| `mcp` | object | MCP server settings |
