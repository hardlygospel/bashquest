---
title: Home
nav_order: 1
permalink: /
---

# BashQuest 🐧
{: .no_toc }

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blueviolet?style=flat-square)](https://www.gnu.org/licenses/gpl-3.0)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS-brightgreen?style=flat-square&logo=linux)](https://github.com/hardlygospel/bashquest)
[![Shell](https://img.shields.io/badge/Shell-Bash-4EAA25?style=flat-square&logo=gnubash&logoColor=white)](https://github.com/hardlygospel/bashquest)
[![Levels](https://img.shields.io/badge/Levels-28-blue?style=flat-square)](./levels/)

An interactive terminal game that teaches Linux and Bash from the ground up. Each challenge explains **how** a command works and **why** you'd use it: not just the syntax.

---

## What Is BashQuest?

BashQuest is a single Bash script that turns your terminal into a Linux training ground. You create an account, log in, and work through 28 progressive levels: from basic navigation all the way to systemd services and shell scripting best practices.

Every challenge:
- Describes what you need to do in plain English
- Explains **why** the command exists and when you'd reach for it
- Accepts your answer, validates it, and gives immediate feedback
- Has a **hint** available if you're stuck

---

## Quick Start

```bash
# Download
curl -o bashquest.sh https://raw.githubusercontent.com/hardlygospel/bashquest/main/bashquest.sh

# Make executable
chmod +x bashquest.sh

# Run
bash bashquest.sh
```

No dependencies. No installation. Pure Bash.

---

## Features

| Feature | Detail |
|---|---|
| **28 levels** | Beginner → expert, each with 5–8 challenges |
| **Pseudo login** | Register/login with hashed passwords, saved per user |
| **Lives & XP** | 3 lives, earn XP per correct answer, save progress |
| **Leaderboard** | Ranked across all players on the machine |
| **Hints** | Type `hint` for a clue on any challenge |
| **Skip** | Type `skip` to pass a challenge (costs 1 life) |
| **Level select** | Replay any unlocked level |
| **Command reference** | In-game cheat sheet covering all 28 level topics |
| **Colorful TUI** | ANSI colour, ASCII banners, status bar |
| **Cross-platform** | Linux and macOS (bash 3.2+) |
| **ROOT** | A mentor character who reacts to every answer, hint, and streak |
| **Streaks & achievements** | Track your best streak and earn badges for hint-free, skip-free, lives-untouched runs |
| **Tier milestones** | A checkpoint screen at the end of each of the five tiers |
| **Graduation certificate** | Beat all 28 levels and get a certificate, written to disk, that's yours to keep |

---

## Level Overview

28 levels across five tiers (Beginner, Intermediate, Pipes & Patterns, Power Tools, Expert). Clear a tier and ROOT checks in with a milestone screen before the next one starts. See [levels](./levels/) for the full tier breakdown.

| # | Level | Commands |
|---|---|---|
| 1 | Navigation & Basics | `ls` `cd` `pwd` `mkdir` `rmdir` |
| 2 | File Operations | `cat` `touch` `cp` `mv` `rm` `tar` |
| 3 | Text & Search | `grep` `find` `wc` `sort` `uniq` |
| 4 | Permissions | `chmod` `chown` `whoami` `id` |
| 5 | Processes | `ps` `kill` `jobs` `bg` `fg` |
| 6 | Text Processing | `awk` `sed` `cut` `tr` `head` `tail` |
| 7 | Networking | `curl` `wget` `ping` `ssh` `ss` |
| 8 | Shell Scripting | variables, loops, if/else, functions |
| 9 | Advanced Piping | `\|` chains, `tee`, `sort\|uniq -c` |
| 10 | I/O Redirection | `>` `>>` `<` `2>` `2>&1` `/dev/null` |
| 11 | Regular Expressions | `^` `$` `.` `*` `+` `?` `[]` `\|` |
| 12 | Advanced grep | `-n` `-l` `-c` `-A/B/C` `-o` `--include` |
| 13 | Advanced sed | `s///g` `-i` address ranges, `/d` |
| 14 | Advanced awk | `NR` `NF` `BEGIN` `END` `printf` |
| 15 | xargs & find | `-exec` `xargs -I{}` `-size` `-mtime` |
| 16 | Disk & Storage | `df` `du` `lsblk` `findmnt` |
| 17 | System Info | `uname` `lscpu` `free` `uptime` `lsof` |
| 18 | User Management | `useradd` `usermod -aG` `passwd` `su` |
| 19 | SSH & Keys | `ssh-keygen` `ssh-copy-id` `-i` `-L` |
| 20 | Environment | `PATH` `export` `alias` `source` `PS1` |
| 21 | Cron & Scheduling | `crontab` syntax, `at` |
| 22 | Logs & Monitoring | `tail -f` `journalctl` `logger` |
| 23 | Package Management | `apt` `dnf` `brew` |
| 24 | Compression | `gzip` `bzip2` `xz` `zip` `zcat` |
| 25 | String Processing | `${#v}` `${v:0:n}` `${v//f/r}` `printf` |
| 26 | Arrays | indexed arrays, loops, associative |
| 27 | Functions & Errors | `set -euo pipefail` `trap` `$?` |
| 28 | Systemd | `systemctl` `journalctl -fu` unit files |

---

## License

GPL-3.0: Copyright © 2026 Tony Hosaroygard
