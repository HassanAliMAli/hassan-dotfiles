# SSH Configuration — Documentation

**Location:** `ssh/config` → `~/.ssh/config`  
**Purpose:** Configures SSH client behavior for connecting to remote servers

## What Is the SSH Config File?

The SSH config file (`~/.ssh/config`) lets you define shortcuts and settings for SSH connections. Instead of typing `ssh -i ~/.ssh/key.pem user@192.168.1.100 -p 2222`, you can just type `ssh myserver`.

## Line-by-Line Explanation

### Global Settings (Lines 1-12)

```ssh
Host *
    AddKeysToAgent yes
    IdentitiesOnly yes
    ServerAliveInterval 60
    ServerAliveCountMax 3
    TCPKeepAlive yes
    ConnectTimeout 10
    ControlMaster auto
    ControlPath ~/.ssh/controlmasters/%r@%h:%p
    ControlPersist 600
```

- **`Host *`**: These settings apply to ALL SSH connections
- **`AddKeysToAgent yes`**: Automatically add SSH keys to the ssh-agent when used
- **`IdentitiesOnly yes`**: Only use the keys explicitly specified (don't try all keys in `~/.ssh/`)
- **`ServerAliveInterval 60`**: Send a keep-alive packet every 60 seconds
- **`ServerAliveCountMax 3`**: Disconnect after 3 failed keep-alive attempts (3 × 60 = 180 seconds)
- **`TCPKeepAlive yes`**: Use TCP-level keep-alive as well
- **`ConnectTimeout 10`**: Give up connecting after 10 seconds
- **`ControlMaster auto`**: Reuse existing SSH connections to the same server (faster subsequent connections)
- **`ControlPath`**: Where to store the connection socket file
  - `%r` = remote username
  - `%h` = remote hostname
  - `%p` = remote port
- **`ControlPersist 600`**: Keep the master connection alive for 600 seconds (10 minutes) after the last client disconnects

### Server-Specific Configurations

Each `Host` block defines settings for a specific server or group of servers.

#### Example Structure

```ssh
Host myserver
    HostName 192.168.1.100
    User admin
    Port 2222
    IdentityFile ~/.ssh/myserver_key
```

- **`Host`**: The alias you type (`ssh myserver`)
- **`HostName`**: The actual server address (IP or domain)
- **`User`**: The username to log in as
- **`Port`**: The SSH port (default is 22)
- **`IdentityFile`**: The SSH private key to use

## Common Patterns

### Wildcard Hosts

```ssh
Host *.example.com
    User deploy
    IdentityFile ~/.ssh/deploy_key
```

- **What it does:** Any server matching `*.example.com` uses the `deploy` user and key

### Jump Hosts (Bastion)

```ssh
Host internal-server
    HostName 10.0.0.50
    User admin
    ProxyJump bastion.example.com
```

- **What it does:** Connects to `internal-server` through a bastion host
- **Why:** Access private servers that aren't directly reachable from the internet

### Port Forwarding

```ssh
Host db-server
    HostName db.example.com
    User admin
    LocalForward 5432 localhost:5432
```

- **What it does:** Forwards port 5432 on your local machine to port 5432 on the remote server
- **Why:** Access a remote database as if it were running locally

## Security Best Practices

1. **`IdentitiesOnly yes`**: Prevents SSH from offering all your keys to every server
2. **`ControlPersist`**: Limits how long master connections stay open
3. **`ConnectTimeout`**: Prevents hanging on unreachable servers
4. **Specific keys per host**: Each server gets its own key file

## Useful Commands

| Command | Purpose |
|---------|---------|
| `ssh myserver` | Connect using the alias |
| `ssh -F ~/.ssh/config` | Use a specific config file |
| `ssh -G myserver` | Show the resolved config for a host |
| `ssh -O check myserver` | Check if a master connection exists |
| `ssh -O exit myserver` | Close a master connection |
