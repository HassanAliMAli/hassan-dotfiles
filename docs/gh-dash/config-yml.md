# gh-dash Configuration — Documentation

**Location:** `gh-dash/config.yml` → `~/.config/gh-dash/config.yml`  
**Purpose:** Configures `gh-dash`, a terminal dashboard for managing GitHub Pull Requests, Issues, and Notifications

## What Is gh-dash?

`gh-dash` is a terminal-based dashboard that shows your GitHub PRs, issues, and notifications in a clean, organized layout. It's like having the GitHub web interface in your terminal.

## Line-by-Line Explanation

### Lines 1-7: Pull Request Sections
Defines the categories (tabs) shown in the PR view:

- **Line 1-3: "My Pull Requests"** — Shows all open PRs created by you (`is:open`)
- **Line 4-5: "Needs My Review"** — Shows open PRs where someone requested your review (`review-requested:@me`)
- **Line 6-7: "Involved"** — Shows open PRs where you're mentioned or commented, but didn't create (`involves:@me -author:@me`)

### Lines 8-14: Issue Sections
Defines the categories for the Issues view:

- **Line 9-10: "My Issues"** — Open issues you created (`author:@me`)
- **Line 11-12: "Assigned"** — Open issues assigned to you (`assignee:@me`)
- **Line 13-14: "Involved"** — Open issues you're involved in but didn't create

### Lines 15-31: Notification Sections
Defines categories for GitHub notifications, filtered by reason:

- **"All"** — Every notification
- **"Created"** — Notifications because you created something (`reason:author`)
- **"Participating"** — Notifications because you commented (`reason:participating`)
- **"Mentioned"** — Notifications where someone @mentioned you
- **"Review Requested"** — Notifications asking you to review a PR
- **"Assigned"** — Notifications because you were assigned to an issue/PR
- **"Subscribed"** — Notifications from repos you're watching
- **"Team Mentioned"** — Notifications where your team was @mentioned

### Lines 32-34: Repository Settings
- **`branchesRefetchIntervalSeconds: 30`**: Refresh branch data every 30 seconds
- **`prsRefetchIntervalSeconds: 60`**: Refresh PR data every 60 seconds

### Lines 35-78: Default Settings
- **`preview.open: false`**: Preview panel is closed by default
- **`preview.width: 70`**: When open, preview takes 70% of the width
- **`prsLimit: 20`**: Show max 20 PRs per section
- **`prApproveComment: LGTM`**: Default comment when approving a PR ("Looks Good To Me")
- **`issuesLimit: 20`**: Show max 20 issues per section
- **`notificationsLimit: 20`**: Show max 20 notifications per section
- **`view: prs`**: Default view when opening gh-dash is PRs (not issues or notifications)

### Lines 44-77: Layout Configuration
Defines column widths for the PR and issue tables:

**PR columns:**
- `updatedAt`: 5 chars wide
- `createdAt`: 5 chars wide
- `repo`: 20 chars wide
- `author`: 15 chars wide
- `authorIcon`: Visible (shows author avatar)
- `assignees`: Hidden (saves space)
- `base`: Hidden (base branch)
- `lines`: 15 chars wide (lines changed)

**Issue columns:**
- `updatedAt`: 5 chars wide
- `createdAt`: 5 chars wide
- `repo`: 15 chars wide
- `creator`: 10 chars wide
- `creatorIcon`: Visible
- `assignees`: Hidden

### Line 78: `refetchIntervalMinutes: 30`
- Refresh all data every 30 minutes

### Lines 79-91: Custom Keybindings

#### Universal (works everywhere):
- **`g`**: Opens `lazygit` in the current repository's directory

#### PRs section:
- **`C`**: Opens a code review workflow:
  1. Creates a new tmux window named "PR-{number}"
  2. Uses `wt` (worktrunk) to switch to the PR branch
  3. Launches `opencode` with a prompt to review the PR

### Lines 92-111: Theme Configuration
Custom color scheme (not Catppuccin — this is a custom palette):

**Text colors:**
- `primary`: `#F7F1FF` (light purple-white)
- `secondary`: `#5AD4E6` (cyan)
- `inverted`: `#F7F1FF` (same as primary)
- `faint`: `#3E4057` (dark gray)
- `warning`: `#FC618D` (pink-red)
- `success`: `#7BD88F` (green)

**Background:**
- `selected`: `#535155` (dark gray for selected row)

**Borders:**
- `primary`: `#948AE3` (purple)
- `secondary`: `#7BD88F` (green)
- `faint`: `#3E4057` (dark gray)

**UI settings:**
- `sectionsShowCount: true`: Shows how many items in each section
- `table.showSeparator: true`: Shows separator lines between rows
- `table.compact: true`: Tighter row spacing

### Lines 112-116: Misc Settings
- **`pager.diff: "diffnav"`**: Uses `diffnav` for viewing diffs (a navigable diff viewer)
- **`confirmQuit: false`**: Quit immediately without confirmation
- **`showAuthorIcons: true`: Shows author avatar icons
- **`smartFilteringAtLaunch: true`: Applies smart filters when starting

## Custom Shortcuts

| Key | Context | Action |
|-----|---------|--------|
| `g` | Universal | Open lazygit in the repo |
| `C` | PRs | Code review via opencode in tmux |
