# .gitignore — Documentation

**Location:** Root of the repository  
**Purpose:** Tells Git which files and directories to ignore (not track in version control)

## Line-by-Line Explanation

### Line 1: `.DS_Store`
- **What it is:** A hidden file automatically created by macOS to store custom folder attributes (like icon positions, window size, etc.)
- **Why ignore it:** It's macOS-specific, not useful on Linux, and would create unnecessary noise in the repository every time you open a folder on a Mac

### Line 2: `tmux/plugins/`
- **What it is:** A directory where Tmux Plugin Manager (TPM) downloads and stores plugins
- **Why ignore it:** These are third-party plugins that can be re-downloaded at any time. Tracking them would bloat the repository with thousands of lines of other people's code
- **Note:** The tmux directory itself has been removed from this repo (macOS-only), but this line remains as a safety net

### Line 3: `raycast`
- **What it is:** Raycast is a macOS productivity launcher (like Spotlight but more powerful)
- **Why ignore it:** macOS-only tool, not relevant on Linux

### Line 4: `fzf`
- **What it is:** Likely a local fzf (fuzzy finder) installation or cache directory
- **Why ignore it:** fzf is installed system-wide via apt, not needed as a local copy in the repo

### Line 5: `history.txt`
- **What it is:** A file that would contain shell command history
- **Why ignore it:** Contains personal command history which may include sensitive information (API keys, passwords typed by accident, etc.). Each machine should have its own history

## Why .gitignore Matters

Without a `.gitignore` file, Git would try to track every single file in the directory, including:
- Temporary files
- System-specific files
- Sensitive data
- Large binary files
- Build artifacts

This keeps the repository clean, small, and portable across different machines.
