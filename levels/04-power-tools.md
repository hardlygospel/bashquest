---
title: "Levels 15–20: Power Tools"
parent: Levels
nav_order: 4
---

# Levels 15–20: Power Tools
{: .no_toc }

<details open markdown="block">
  <summary>Contents</summary>
  {: .text-delta }
- TOC
{:toc}
</details>

---

## Level 15 — xargs & find -exec

> *find locates files. xargs and -exec act on them.*

| Syntax | What it does |
|---|---|
| `find . -name '*.log'` | Find by filename glob |
| `find . -type f` | Files only (`d`=dirs, `l`=symlinks) |
| `find . -size +10M` | Larger than 10 MB |
| `find . -mtime -1` | Modified in the last 1 day |
| `find . -mmin -60` | Modified in the last 60 minutes |
| `find . -exec cmd {} \;` | Run cmd once per found file |
| `find . -exec cmd {} +` | Run cmd with all files batched |
| `find . -print0 \| xargs -0 cmd` | Safe with filenames containing spaces |
| `find . -name '*.log' -delete` | Delete all found files |

**xargs patterns:**

```bash
# Basic — pass all found files to wc at once
find . -name '*.txt' | xargs wc -l

# With placeholder (-I{}) — use filename anywhere
find . -name '*.conf' | xargs -I{} cp {} {}.bak

# Safe for filenames with spaces
find . -name '*.log' -print0 | xargs -0 grep ERROR

# Parallel execution (-P N = N parallel processes)
find . -name '*.png' -print0 | xargs -0 -P 4 convert -resize 50%
```

**find size units:** `c`=bytes, `k`=KB, `M`=MB, `G`=GB. `+` = greater than, `-` = less than.

---

## Level 16 — Disk & Storage

> *A full disk silently kills services. Know these commands cold.*

| Command | What it does |
|---|---|
| `df -h` | Disk free space, all filesystems, human-readable |
| `df -h /var` | Free space for a specific filesystem |
| `du -sh dir/` | Total size of a directory |
| `du -sh *` | Size of all items in current directory |
| `du -sh * \| sort -rh` | Largest items first |
| `find . -size +100M -ls` | Find files over 100 MB |
| `lsblk` | List block devices (disks, partitions) |
| `findmnt` | Show mounted filesystems (tree view) |
| `mount` | Show all mounts |

**Emergency disk full procedure:**

```bash
# 1. Which filesystem is full?
df -h

# 2. Which directory is the culprit?
du -sh /var/* | sort -rh | head -10

# 3. Drill down
du -sh /var/log/* | sort -rh | head -10

# 4. Find the specific large files
find /var/log -size +100M -ls

# 5. Clear old compressed logs (if safe)
find /var/log -name '*.gz' -mtime +30 -delete
```

---

## Level 17 — System Information

> *Establish situational awareness on any machine in 60 seconds.*

| Command | What it shows | Linux/macOS |
|---|---|---|
| `uname -a` | Kernel, hostname, architecture | Both |
| `lscpu` | CPU cores, speed, architecture | Linux |
| `sysctl -n hw.ncpu` | CPU core count | macOS |
| `free -h` | RAM usage (total/used/free/available) | Linux |
| `vm_stat` | Memory statistics | macOS |
| `uptime` | System uptime and load averages | Both |
| `who` | Currently logged-in users | Both |
| `w` | Logged-in users + what they're doing | Both |
| `lsof` | All open files and sockets | Both |
| `lsof -i :80` | What's using port 80 | Both |
| `lsof -p PID` | All files open by a process | Both |
| `hostname` | System hostname | Both |
| `hostname -f` | Fully qualified domain name | Linux |

**Load averages (from `uptime`):**
- Three numbers: 1 min, 5 min, 15 min average
- Rule of thumb: if load > number of CPU cores, the system is under pressure
- A 15-min average rising toward a 5-min average = load is increasing

---

## Level 18 — User Management

> *Linux security is built on users and groups.*

| Command | What it does |
|---|---|
| `useradd -m username` | Create user with home directory |
| `passwd username` | Set user password |
| `usermod -aG group user` | Add user to group (append — never omit `-a`) |
| `usermod -L username` | Lock account (prefix `!` to password hash) |
| `usermod -U username` | Unlock account |
| `userdel -r username` | Delete user and home directory |
| `groups username` | Show user's group memberships |
| `id username` | Show UID, GID, all groups |
| `su - username` | Switch user (full login shell) |
| `sudo command` | Run one command as root |
| `visudo` | Safely edit /etc/sudoers |

{: .warning }
**Always use `usermod -aG`** (append + groups), never `usermod -G` alone. Without `-a`, the command **replaces** all group memberships — potentially locking the user out of everything they had access to.

**`/etc/passwd` format:**

```
username:x:UID:GID:GECOS:home:shell
root:x:0:0:root:/root:/bin/bash
```

Fields: username, password placeholder, UID, GID, comment, home directory, login shell.

---

## Level 19 — SSH & Keys

> *Key-based auth is the industry standard. Passwords are for humans, keys are for machines.*

| Command | What it does |
|---|---|
| `ssh-keygen -t ed25519 -C 'email'` | Generate ED25519 key pair |
| `chmod 600 ~/.ssh/id_ed25519` | Fix private key permissions (SSH requires this) |
| `chmod 700 ~/.ssh` | Fix .ssh directory permissions |
| `ssh-copy-id user@host` | Copy public key to server's authorized_keys |
| `ssh user@host` | Connect using default key |
| `ssh -i ~/.ssh/key user@host` | Connect using specific key |
| `ssh -L 8080:localhost:80 user@host` | Local port forwarding (tunnel) |
| `ssh -R 9090:localhost:80 user@host` | Remote port forwarding |
| `cat ~/.ssh/id_ed25519.pub` | View your public key (safe to share) |

**`~/.ssh/config` example:**

```
Host webserver
    Hostname 192.168.1.50
    User admin
    IdentityFile ~/.ssh/deploy_key
    Port 22

Host bastion
    Hostname bastion.example.com
    User ec2-user
```

After adding this, `ssh webserver` works without typing the full details.

**Key types:**

| Type | Recommendation |
|---|---|
| `ed25519` | **Use this.** Modern, fast, secure. |
| `rsa 4096` | Acceptable. Larger keys, slower operations. |
| `rsa 2048` | Minimum acceptable for RSA. |
| `dsa` | **Deprecated.** Do not use. |
| `ecdsa` | Acceptable but ed25519 is preferred. |

---

## Level 20 — Environment & Shell Config

> *Your shell environment controls how everything works.*

| Command | What it does |
|---|---|
| `echo $PATH` | Show command search path |
| `export PATH=/new/dir:$PATH` | Prepend to PATH for this session |
| `export VAR=value` | Set variable for child processes |
| `alias ll='ls -lah'` | Create a command shortcut |
| `alias` | List all defined aliases |
| `unalias ll` | Remove an alias |
| `source ~/.bashrc` | Apply config changes without relogging |
| `. ~/.bashrc` | Same (dot = source) |
| `export PS1='\u@\h:\w\$ '` | Set shell prompt |

**Config file load order (bash):**

| File | When loaded |
|---|---|
| `~/.bash_profile` or `~/.profile` | Login shells (SSH, TTY login) |
| `~/.bashrc` | Interactive non-login shells (new terminal window) |
| `/etc/environment` | System-wide variables (Debian/Ubuntu) |
| `/etc/profile` | System-wide login shell config |

{: .tip }
Put `source ~/.bashrc` inside `~/.bash_profile` to ensure your aliases and functions are always loaded, whether you're in a login shell or not.

**Useful PS1 escape sequences:**

| Escape | Expands to |
|---|---|
| `\u` | Username |
| `\h` | Short hostname |
| `\H` | Full hostname (FQDN) |
| `\w` | Working directory (full path) |
| `\W` | Working directory (basename only) |
| `\$` | `$` for users, `#` for root |
| `\t` | Current time (HH:MM:SS) |
| `\d` | Date (Day Mon DD) |
