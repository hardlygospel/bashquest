---
title: "Levels 1–4: Beginner"
parent: Levels
nav_order: 1
---

# Levels 1–4: Beginner
{: .no_toc }

<details open markdown="block">
  <summary>Contents</summary>
  {: .text-delta }
- TOC
{:toc}
</details>

---

## Level 1: Navigation & Basics

> *Commands you will type every single day.*

| Command | What it does | Why it matters |
|---|---|---|
| `ls` | List directory contents | See what's in a folder |
| `ls -l` | Long listing with permissions, owner, size | Inspect file details |
| `ls -a` | Show hidden files (dotfiles) | Config files are hidden by default |
| `pwd` | Print Working Directory | Know exactly where you are |
| `cd dir` | Change into a directory | Navigate the filesystem |
| `cd ~` or `cd` | Go to home directory | Quick return to your personal space |
| `mkdir name` | Create a directory | Build your workspace |
| `rmdir name` | Remove an empty directory | Clean up empty dirs |

**Key concept:** The Linux filesystem is a tree rooted at `/`. Your home directory is `/home/username` (or `/Users/username` on macOS). `~` is a shell shortcut for it.

---

## Level 2: File Operations

> *Create, read, copy, move, delete: and archive.*

| Command | What it does | Why it matters |
|---|---|---|
| `cat file` | Print file contents | Read small files instantly |
| `head -n N file` | Show first N lines | Preview large files |
| `tail -n N file` | Show last N lines | Check recent log entries |
| `touch file` | Create empty file / update timestamp | Create files without opening an editor |
| `cp src dst` | Copy a file | Backup before editing |
| `mv src dst` | Move or rename | Rename is just a move to the same directory |
| `rm file` | Delete a file (permanent, no undo) | Clean up: no recycle bin |
| `rm -r dir` | Delete directory and all contents | Remove non-empty directories |
| `tar -czf out.tar.gz dir/` | Create compressed archive | Bundle files for transfer or backup |
| `tar -tzf file.tar.gz` | List archive contents | Preview without extracting |
| `tar -xzf file.tar.gz` | Extract archive | Unpack in current directory |
| `tar -xzf file.tar.gz -C /target/` | Extract to specific directory | Control where files land |

**tar flags:**

| Flag | Meaning |
|---|---|
| `c` | Create archive |
| `x` | Extract archive |
| `t` | List contents |
| `z` | gzip compression |
| `j` | bzip2 compression |
| `J` | xz compression |
| `f` | Next argument is the filename |

{: .warning }
`rm` is permanent. Linux has no recycle bin. Double-check before running `rm -rf`.

---

## Level 3: Text & Search

> *Find what you need in files and directories.*

| Command | What it does | Why it matters |
|---|---|---|
| `grep pattern file` | Search for pattern in file | Filter log files, find config values |
| `grep -i pattern file` | Case-insensitive search | When you're not sure of capitalisation |
| `grep -v pattern file` | Invert: show lines that do NOT match | Exclude noise from output |
| `grep -r pattern .` | Recursive search | Search all files in a directory tree |
| `find . -name '*.txt'` | Find files by name pattern | Locate files when you don't know where they are |
| `find . -type d` | Find directories only | Browse just the directory structure |
| `wc -l file` | Count lines | How many records in a file? |
| `sort file` | Sort lines alphabetically | Order data for reading or for `uniq` |
| `uniq file` | Remove adjacent duplicates | Must sort first: uniq only removes consecutive duplicates |
| `cmd1 \| cmd2` | Pipe: send output of cmd1 to cmd2 | Chain tools together: the Unix superpower |

**Pipe example:**

```bash
grep ERROR app.log | sort | uniq -c | sort -rn
```

This finds ERROR lines, sorts them, counts each unique one, then sorts by frequency: showing the most common errors first.

---

## Level 4: Permissions & Users

> *Every file has an owner. Every access is controlled.*

### Permission String

```
-rwxr-xr--
│├┤├─┤├─┤
│││ │  │
│││ │  └── Others: r-- = read only (4)
│││ └───── Group:  r-x = read + execute (5)
│└┤──────── Owner:  rwx = read + write + execute (7)
└────────── File type: - = file, d = directory, l = symlink
```

| Command | What it does |
|---|---|
| `whoami` | Print current username |
| `id` | Print UID, GID, and all group memberships |
| `ls -l` | Show file permissions in long format |
| `chmod 755 file` | Set permissions numerically (rwxr-xr-x) |
| `chmod +x file` | Add execute permission for all |
| `chmod 600 file` | Owner read/write only (private keys) |
| `chown user:group file` | Change file owner and group |

**Octal permission values:**

| Value | Permission |
|---|---|
| `4` | Read (r) |
| `2` | Write (w) |
| `1` | Execute (x) |
| `7` | rwx (4+2+1) |
| `6` | rw- (4+2) |
| `5` | r-x (4+1) |
| `4` | r-- (4) |
| `0` | --- (none) |

{: .tip }
Private SSH keys must be `chmod 600`. SSH will refuse to use a key that's group- or world-readable.
