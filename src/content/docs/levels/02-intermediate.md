---
title: "Levels 5–8: Intermediate"
description: "Process Management, Text Processing, Networking, Shell Scripting Basics."
---

## Level 5: Process Management

> *Linux runs hundreds of processes at once. You need to control them.*

| Command | What it does |
|---|---|
| `ps aux` | List ALL running processes (all users) |
| `ps aux \| grep nginx` | Find a process by name |
| `kill PID` | Send SIGTERM (polite stop) to process |
| `kill -9 PID` | Send SIGKILL (force stop, cannot be ignored) |
| `jobs` | List background jobs in current shell |
| `bg` | Resume a stopped job in the background |
| `fg` | Bring background job to foreground |
| `command &` | Start a command directly in the background |
| `top` | Live process viewer (q to quit) |
| `lsof -i :80` | Show what process is using port 80 |

**`ps aux` columns:**

| Column | Meaning |
|---|---|
| `USER` | Owner of the process |
| `PID` | Process ID |
| `%CPU` | CPU usage |
| `%MEM` | Memory usage |
| `STAT` | State: R=running, S=sleeping, Z=zombie, T=stopped |
| `COMMAND` | The command that was run |

:::caution
`kill -9` cannot be caught or ignored by the process: it terminates immediately with no cleanup. Use it only when a normal `kill` has failed.
:::

---

## Level 6: Text Processing

> *Transform data at machine speed without a GUI.*

| Command | What it does | Example |
|---|---|---|
| `cut -d: -f1 file` | Extract field 1, delimiter : | `cut -d: -f1 /etc/passwd` |
| `awk '{print $1}' file` | Print first field of each line | Column extraction |
| `awk '$2 > 50' file` | Filter rows by condition | Numeric comparisons |
| `awk 'END{print sum}' file` | Run code after all lines | Totals and summaries |
| `sed 's/old/new/g' file` | Replace all occurrences | Find and replace |
| `sed '/pattern/d' file` | Delete lines matching pattern | Strip noise |
| `sed -n '2,5p' file` | Print lines 2–5 only | Extract a range |
| `head -n 10 file` | First 10 lines | Preview |
| `tail -n 10 file` | Last 10 lines | Recent entries |
| `tr 'a-z' 'A-Z'` | Translate/convert characters | Case conversion |

**awk built-in variables:**

| Variable | Meaning |
|---|---|
| `$0` | Entire line |
| `$1`, `$2`... | Fields 1, 2... |
| `$NF` | Last field |
| `NR` | Current line number |
| `NF` | Number of fields on current line |
| `FS` | Field separator (default: whitespace) |

---

## Level 7: Networking

> *Linux is the internet. Know how to interact with it.*

| Command | What it does |
|---|---|
| `ping -c 4 host` | Test connectivity, 4 packets |
| `curl url` | HTTP GET request, print response |
| `curl -o file url` | Download URL to file |
| `curl -X POST -H 'Content-Type: application/json' -d '{...}' url` | POST JSON |
| `wget url` | Download file (saves automatically) |
| `ssh user@host` | Connect to remote server |
| `ssh -i ~/.ssh/key user@host` | Connect with specific key |
| `scp file user@host:/path/` | Copy file to remote server |
| `ss -tlnp` | Show listening TCP ports with process names |
| `netstat -tlnp` | Same (older tool, still widely available) |

**curl common flags:**

| Flag | Meaning |
|---|---|
| `-o file` | Save output to file |
| `-O` | Save with remote filename |
| `-L` | Follow redirects |
| `-s` | Silent mode (no progress) |
| `-I` | HEAD request only (headers) |
| `-u user:pass` | Basic authentication |
| `-k` | Skip SSL certificate verification |

---

## Level 8: Shell Scripting Basics

> *Automate everything. Scripts are commands in a file.*

### Script Structure

```bash
#!/bin/bash
# Every script starts with a shebang: tells the OS which interpreter to use

NAME="BashQuest"
echo "Hello from $NAME"
```

| Concept | Syntax | Example |
|---|---|---|
| Variable | `NAME=value` | `NAME=Tony` |
| Use variable | `$NAME` or `${NAME}` | `echo $NAME` |
| Command output | `$(command)` | `NOW=$(date)` |
| If statement | `if [ cond ]; then ... fi` | `if [ -f file.txt ]; then` |
| For loop | `for i in list; do ... done` | `for i in 1 2 3; do echo $i; done` |
| While loop | `while condition; do ... done` | `while true; do sleep 1; done` |
| Function | `name() { ... }` | `greet() { echo "Hi $1"; }` |

**File test operators:**

| Test | True when |
|---|---|
| `-f file` | File exists |
| `-d dir` | Directory exists |
| `-e path` | File or directory exists |
| `-z "$var"` | Variable is empty |
| `-n "$var"` | Variable is not empty |

:::tip
Always quote variables in tests: `[ -f "$FILE" ]` not `[ -f $FILE ]`. An unquoted variable with spaces breaks the test.
:::
