---
title: "Levels 21–28: Expert"
description: "Cron, logs, package management, compression, Bash string processing, arrays, functions & errors, systemd."
---

## Level 21: Cron & Scheduling

> *Automate everything. If you do it twice, cron it.*

**Crontab format:**

```
MIN  HOUR  DAY  MONTH  WEEKDAY  command
 *    *     *     *       *      /usr/local/bin/script.sh
```

| Field | Range | Special |
|---|---|---|
| Minute | 0–59 | |
| Hour | 0–23 | |
| Day of month | 1–31 | |
| Month | 1–12 (or Jan–Dec) | |
| Day of week | 0–7 (0 and 7 = Sunday) | |

**Special values:**

| Syntax | Meaning |
|---|---|
| `*` | Every value |
| `*/15` | Every 15 (step) |
| `1-5` | Range: 1 through 5 |
| `1,3,5` | List: 1, 3, and 5 |

**Common patterns:**

```bash
# Every minute
* * * * * /usr/local/bin/healthcheck.sh

# Every day at 2am
0 2 * * * /usr/local/bin/backup.sh

# Every 15 minutes
*/15 * * * * /usr/local/bin/sync.sh

# 9am weekdays (Mon–Fri)
0 9 * * 1-5 /usr/local/bin/report.sh

# First day of every month at midnight
0 0 1 * * /usr/local/bin/monthly.sh
```

**crontab commands:**

| Command | Action |
|---|---|
| `crontab -l` | List current crontab |
| `crontab -e` | Edit crontab |
| `crontab -r` | **Remove ALL cron jobs (no confirmation)** |
| `crontab -u user -l` | List another user's crontab (root) |

**`at`: one-time scheduled tasks:**

```bash
echo '/usr/local/bin/restart.sh' | at 23:00
echo '/usr/local/bin/script.sh' | at 2:30 AM tomorrow
atq           # List pending at jobs
atrm 3        # Remove at job #3
```

---

## Level 22: Logs & Monitoring

> *When something breaks at 3am, logs are your flashlight.*

| Command | What it does |
|---|---|
| `tail -f /var/log/syslog` | Follow log file live |
| `tail -f app.log \| grep --line-buffered ERROR` | Follow with live filter |
| `journalctl` | All systemd journal entries |
| `journalctl -f` | Follow journal live |
| `journalctl -u nginx` | Logs for specific service |
| `journalctl -fu nginx` | Follow specific service live |
| `journalctl --since '1 hour ago'` | Time-filtered logs |
| `journalctl --since '2024-01-15 08:00' --until '2024-01-15 09:00'` | Time window |
| `journalctl -b` | Logs from current boot only |
| `journalctl -b -1` | Logs from previous boot |
| `journalctl -n 50` | Last 50 lines |
| `journalctl -p err` | Error priority and above |
| `logger 'message'` | Write to system log from script |
| `logger -t mytag 'message'` | Write with tag |

:::tip
Always use `grep --line-buffered` when piping from `tail -f`. Without it, grep holds output in its buffer and filtered lines may not appear immediately.
:::

---

## Level 23: Package Management

> *Same concepts, different commands: know your distro.*

**Debian / Ubuntu (apt):**

```bash
sudo apt update                    # Refresh package index
sudo apt upgrade                   # Upgrade installed packages
sudo apt full-upgrade              # Upgrade + handle dependency changes
sudo apt install -y packagename    # Install (-y = no prompts)
sudo apt remove packagename        # Remove (keep config files)
sudo apt purge packagename         # Remove + delete config files
sudo apt autoremove                # Remove orphaned dependencies
apt search keyword                 # Search available packages
apt show packagename               # Show package details
dpkg -l | grep packagename         # List installed package
```

**RHEL / Fedora / CentOS (dnf/yum):**

```bash
sudo dnf update                    # Update all packages
sudo dnf install -y packagename    # Install
sudo dnf remove packagename        # Remove
dnf search keyword                 # Search
dnf info packagename               # Show details
rpm -qa | grep packagename         # List installed
```

**macOS (Homebrew):**

```bash
brew update                        # Update Homebrew itself
brew upgrade                       # Upgrade all packages
brew install packagename           # Install
brew uninstall packagename         # Remove
brew search keyword                # Search
brew info packagename              # Show details
brew list                          # List installed
```

---

## Level 24: Compression Deep Dive

> *Different formats for different needs. Know the trade-offs.*

| Format | Speed | Ratio | Best for |
|---|---|---|---|
| `gzip` (.gz) | Fast | Good | Log rotation, web serving, general use |
| `bzip2` (.bz2) | Moderate | Better | Source code archives |
| `xz` (.xz) | Slow | Best | Long-term storage, kernel releases |
| `zip` (.zip) | Fast | Moderate | Windows compatibility |

| Command | What it does |
|---|---|
| `gzip file` | Compress (replaces original) |
| `gzip -k file` | Compress, keep original |
| `gunzip file.gz` | Decompress |
| `zcat file.gz` | Read compressed file (stdout) |
| `zgrep pattern file.gz` | grep inside compressed file |
| `bzip2 file` | Compress with bzip2 |
| `bunzip2 file.bz2` | Decompress bzip2 |
| `bzcat file.bz2` | Read bzip2 compressed |
| `xz file` | Compress with xz |
| `xz -9 file` | Maximum compression (slowest) |
| `unxz file.xz` | Decompress xz |
| `xzcat file.xz` | Read xz compressed |
| `zip -r out.zip dir/` | Create zip archive |
| `unzip out.zip` | Extract zip |
| `unzip -l out.zip` | List zip contents |

**tar + compression combined:**

```bash
tar -czf archive.tar.gz  dir/    # gzip   (.tar.gz  / .tgz)
tar -cjf archive.tar.bz2 dir/   # bzip2  (.tar.bz2)
tar -cJf archive.tar.xz  dir/   # xz     (.tar.xz)
tar -xzf archive.tar.gz         # extract gzip
tar -xJf archive.tar.xz         # extract xz
tar -tzf archive.tar.gz         # list contents
```

---

## Level 25: Bash String Processing

> *Built-in shell operations: no subprocess, no external commands.*

| Syntax | Result | Example |
|---|---|---|
| `${#var}` | String length | `${#NAME}` → `9` |
| `${var:0:4}` | Substring from offset 0, length 4 | `${NAME:0:4}` → `Bash` |
| `${var: -3}` | Last 3 characters (note the space) | `${NAME: -4}` → `uest` |
| `${var%pattern}` | Strip shortest suffix match | `${FILE%.gz}` → `file.tar` |
| `${var%%pattern}` | Strip longest suffix match | `${FILE%%.tar*}` → `file` |
| `${var#pattern}` | Strip shortest prefix match | `${PATH#*/}` |
| `${var##pattern}` | Strip longest prefix match | `${PATH##*/}` → filename |
| `${var/find/replace}` | Replace first occurrence | `${TEXT/cat/dog}` |
| `${var//find/replace}` | Replace all occurrences | `${TEXT//cat/dog}` |
| `${var^^}` | Uppercase all (bash 4+) | `${name^^}` → `NAME` |
| `${var,,}` | Lowercase all (bash 4+) | `${NAME,,}` → `name` |
| `${var:-default}` | Use default if var is unset/empty | `${PORT:-8080}` |
| `${var:=default}` | Assign default if unset/empty | `${DIR:=/tmp}` |

:::note
macOS ships Bash 3.2 which does not support `${var^^}` or `${var,,}`. Use `echo "$var" | tr 'a-z' 'A-Z'` instead.
:::

**`printf` formatting:**

```bash
printf '%-20s %5d\n' "Alice" 95     # Left-aligned name, right-aligned number
printf '%.2f\n' 3.14159             # 2 decimal places: 3.14
printf '%05d\n' 42                  # Zero-padded: 00042
printf '%s\n' "${array[@]}"         # One element per line
```

---

## Level 26: Arrays in Bash

> *Store multiple values. Iterate safely. No string-splitting bugs.*

**Indexed arrays:**

```bash
# Create
SERVERS=(web01 web02 db01)

# Access
echo ${SERVERS[0]}        # web01 (zero-indexed)
echo ${SERVERS[-1]}       # db01  (last element, bash 4.2+)
echo ${SERVERS[@]}        # all elements
echo ${#SERVERS[@]}       # element count: 3

# Append
SERVERS+=(db02)

# Loop: always quote "${arr[@]}"
for s in "${SERVERS[@]}"; do
    echo "Checking $s..."
done

# Slice
echo ${SERVERS[@]:1:2}    # elements 1 and 2: web02 db01
```

**Associative arrays (bash 4+):**

```bash
declare -A PORTS=([http]=80 [https]=443 [ssh]=22)

echo ${PORTS[http]}       # 80
echo ${!PORTS[@]}         # all keys: http https ssh
echo ${PORTS[@]}          # all values: 80 443 22

for key in "${!PORTS[@]}"; do
    echo "$key → ${PORTS[$key]}"
done
```

:::note
macOS Bash 3.2 does not support `declare -A` (associative arrays) or negative indices. Install Bash 5 via Homebrew for full support: `brew install bash`.
:::

---

## Level 27: Functions & Error Handling

> *Production scripts don't silently fail.*

**The safety header: put this at the top of every production script:**

```bash
#!/bin/bash
set -euo pipefail
```

| Option | Effect |
|---|---|
| `set -e` | Exit immediately on any non-zero exit code |
| `set -u` | Treat unset variables as an error |
| `set -o pipefail` | Fail if any command in a pipe fails |

**Functions:**

```bash
# Define
greet() {
    local name="$1"           # local variables don't leak
    echo "Hello, $name!"
}

# Call
greet Tony

# Return values (via exit code)
is_root() {
    [ "$(id -u)" -eq 0 ] && return 0 || return 1
}

if is_root; then
    echo "Running as root"
fi
```

**Exit codes:**

```bash
# $? = exit code of last command
ls /nonexistent 2>/dev/null
echo $?      # 2 (non-zero = failure)

# Always check immediately: $? changes after every command
cp src.txt dst.txt
if [ $? -ne 0 ]; then
    echo "Copy failed" >&2
    exit 1
fi
```

**trap: guaranteed cleanup:**

```bash
TMPDIR=$(mktemp -d)

cleanup() {
    rm -rf "$TMPDIR"
    echo "Cleaned up."
}

trap cleanup EXIT       # Runs on any exit
trap cleanup INT TERM   # Also runs on Ctrl+C / kill

# Do work in $TMPDIR...
```

`trap ... EXIT` fires on: normal completion, `set -e` error, SIGTERM, Ctrl+C. The cleanup always runs.

---

## Level 28: Systemd & Services

> *systemd manages everything that runs in the background on modern Linux.*

| Command | What it does |
|---|---|
| `systemctl status nginx` | Show service status, PID, memory, recent logs |
| `sudo systemctl start nginx` | Start service now |
| `sudo systemctl stop nginx` | Stop service now |
| `sudo systemctl restart nginx` | Stop then start (brief downtime) |
| `sudo systemctl reload nginx` | Re-read config without restart (if supported) |
| `sudo systemctl enable nginx` | Enable autostart on boot |
| `sudo systemctl disable nginx` | Disable autostart on boot |
| `sudo systemctl enable --now nginx` | Enable AND start in one command |
| `sudo systemctl disable --now nginx` | Disable AND stop in one command |
| `systemctl list-units --type=service` | List all service units |
| `systemctl --state=failed` | Show only failed units |
| `journalctl -u nginx` | Logs for this service |
| `journalctl -fu nginx` | Follow logs live |
| `sudo systemctl daemon-reload` | Reload unit files after editing |

**Minimal unit file** (`/etc/systemd/system/myapp.service`):

```ini
[Unit]
Description=My Application
After=network.target

[Service]
Type=simple
User=myapp
ExecStart=/usr/local/bin/myapp --config /etc/myapp/config.yml
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

After creating or editing a unit file:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now myapp
journalctl -fu myapp    # Watch it start
```

**Service states:**

| State | Meaning |
|---|---|
| `active (running)` | Running normally |
| `active (exited)` | Ran once and exited cleanly (oneshot) |
| `inactive (dead)` | Not running |
| `failed` | Exited with error or crashed |
| `activating` | In the process of starting |
