# Nix Configuration — Documentation

**Location:** `nix/nix.conf` → `~/.config/nix/nix.conf`  
**Purpose:** Configures Nix, a declarative package manager with reproducible builds

## What Is Nix?

Nix is a package manager that:
- Installs packages in isolation (no dependency conflicts)
- Allows multiple versions of the same package
- Can roll back to previous states
- Uses declarative configuration

## Line-by-Line Explanation

### Line 1: Experimental Features

```nix
experimental-features = nix-command flakes
```

- **`nix-command`**: Enables the new `nix` CLI (e.g., `nix shell`, `nix run`, `nix develop`)
- **`flakes`**: Enables the flakes feature — a way to define reproducible Nix configurations with a `flake.nix` file
- **Why both:** These features were experimental but are now the recommended way to use Nix

### Line 2: Build Users Group

```nix
build-users-group = nixbld
```

- **What it does:** Specifies the group of users that can perform builds
- **`nixbld`**: The standard Nix build user group
- **Why:** Nix uses sandboxed builds for security and reproducibility — only users in this group can trigger builds

## Common Nix Commands

| Command | Purpose |
|---------|---------|
| `nix shell nixpkgs#package` | Open a shell with a package |
| `nix run nixpkgs#package` | Run a package directly |
| `nix develop` | Enter a development environment |
| `nix build` | Build a package |
| `nix profile install nixpkgs#package` | Install a package permanently |
