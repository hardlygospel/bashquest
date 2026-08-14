---
title: "Levels 9–14: Pipes & Patterns"
parent: Levels
nav_order: 3
---

# Levels 9–14: Pipes & Patterns
{: .no_toc }

<details open markdown="block">
  <summary>Contents</summary>
  {: .text-delta }
- TOC
{:toc}
</details>

---

## Level 9: Advanced Piping

> *Small tools doing one thing well, chained together.*

The pipe `|` is the core of Unix philosophy. The stdout of one command becomes the stdin of the next. Data flows left to right.

```bash
# Classic log analysis pipeline
grep ERROR app.log | sort | uniq -c | sort -rn | head -10
```

This finds ERROR lines → sorts them → counts each unique one → sorts by count (descending) → shows the top 10 most common errors.

| Command/Operator | What it does |
|---|---|
| `cmd1 \| cmd2` | Pipe stdout of cmd1 to stdin of cmd2 |
| `tee file` | Write to file AND pass data through unchanged |
| `sort \| uniq` | Deduplicate (must sort first) |
| `uniq -c` | Count consecutive duplicates |
| `sort -rn` | Sort numerically, reverse (largest first) |
| `cmd \| less` | Pipe long output to a pager |
| `cmd \| wc -l` | Count output lines |

**`tee`: split the stream:**

```bash
# Display errors on screen AND save to file simultaneously
grep ERROR app.log | tee errors.txt | wc -l
```

`tee` is named after a plumbing T-junction. Output goes two ways.

---

## Level 10: I/O Redirection

> *Control where data goes. stdin, stdout, stderr.*

Every process has three streams:

| Stream | FD | Default destination |
|---|---|---|
| stdin | 0 | Keyboard |
| stdout | 1 | Terminal |
| stderr | 2 | Terminal |

| Syntax | What it does |
|---|---|
| `cmd > file` | Redirect stdout to file (overwrite) |
| `cmd >> file` | Append stdout to file |
| `cmd < file` | Feed file as stdin |
| `cmd 2> file` | Redirect stderr to file |
| `cmd > file 2>&1` | Redirect both stdout and stderr to file |
| `cmd &> file` | Bash shorthand for `> file 2>&1` |
| `cmd > /dev/null 2>&1` | Discard all output silently |
| `cmd <<EOF ... EOF` | Here-document: inline multi-line input |

**Order matters with `2>&1`:**

```bash
# CORRECT: redirect stdout first, then merge stderr into it
ls /dir > out.log 2>&1

# WRONG: stderr goes to terminal, only stdout to file
ls /dir 2>&1 > out.log
```

**Here-document:**

```bash
cat > config.txt <<EOF
host=localhost
port=8080
debug=true
EOF
```

Used everywhere: Dockerfiles, Ansible, remote SSH commands, scripts.

---

## Level 11: Regular Expressions

> *A pattern language for matching text. Learn it once, use it everywhere.*

| Pattern | Matches |
|---|---|
| `^` | Start of line |
| `$` | End of line |
| `.` | Any single character |
| `*` | Zero or more of preceding |
| `+` | One or more (needs `-E`) |
| `?` | Zero or one (needs `-E`) |
| `[abc]` | Any character in set |
| `[^abc]` | Any character NOT in set |
| `[a-z]` | Any lowercase letter |
| `[0-9]` | Any digit |
| `\b` | Word boundary |
| `pat1\|pat2` | Either pattern (needs `-E`) |
| `(group)` | Grouping (needs `-E`) |

**Examples:**

```bash
grep '^ERROR' app.log          # Lines starting with ERROR
grep '/bin/bash$' /etc/passwd  # Lines ending with /bin/bash
grep -E '[0-9]{3}-[0-9]{4}'   # Phone number pattern
grep -E 'error|warning|fatal'  # Any of three words
grep -v '^#' config.conf       # Non-comment lines
```

{: .note }
Basic regex (BRE) requires `\+` `\|` `\(`. Extended regex (ERE, enabled with `-E` or `egrep`) uses `+` `|` `(` without backslashes. Always prefer `-E` for readability.

---

## Level 12: Advanced grep

> *grep is more than a filter. It's an investigation tool.*

| Flag | Effect |
|---|---|
| `-n` | Show line numbers |
| `-c` | Count matching lines only |
| `-l` | List filenames only (not matching lines) |
| `-v` | Invert match (lines that do NOT match) |
| `-i` | Case-insensitive |
| `-w` | Whole word match only |
| `-o` | Print only the matched portion |
| `-r` | Recursive (search subdirectories) |
| `-A N` | N lines After each match |
| `-B N` | N lines Before each match |
| `-C N` | N lines of Context (before and after) |
| `--include='*.log'` | Only search files matching glob |
| `--exclude='*.bak'` | Skip files matching glob |

**Investigation workflow:**

```bash
# Find which files have errors
grep -rl 'ERROR' /var/log/

# See the errors with surrounding context
grep -C 3 'FATAL' /var/log/app.log

# Extract just the error codes (not whole lines)
grep -oE 'E[0-9]+' /var/log/app.log | sort | uniq -c | sort -rn

# Count errors per log file
grep -rc 'ERROR' /var/log/*.log
```

---

## Level 13: Advanced sed

> *Automated text editing at the command line.*

sed reads line by line, applies commands, and outputs the result.

| Syntax | What it does |
|---|---|
| `sed 's/old/new/'` | Replace first occurrence per line |
| `sed 's/old/new/g'` | Replace all occurrences (global) |
| `sed 's/old/new/2'` | Replace 2nd occurrence only |
| `sed '/pattern/d'` | Delete lines matching pattern |
| `sed -n '5p'` | Print line 5 only (`-n` suppresses default) |
| `sed -n '2,8p'` | Print lines 2–8 |
| `sed -n '/START/,/END/p'` | Print between two patterns |
| `sed '3s/old/new/'` | Substitute on line 3 only |
| `sed -i.bak 's/old/new/g' file` | Edit file in-place, backup as .bak |

**Delimiter flexibility:**

```bash
# Use | instead of / when the pattern contains slashes
sed 's|/usr/local|/opt|g' config.txt
```

**In-place editing:**

```bash
# Linux (GNU sed): backup optional
sed -i 's/foo/bar/g' file.txt

# macOS (BSD sed): backup extension required (use empty string for no backup)
sed -i.bak 's/foo/bar/g' file.txt
sed -i '' 's/foo/bar/g' file.txt
```

{: .mac }
macOS ships BSD sed. The `-i` flag behaves differently: it requires an extension argument. Use `-i.bak` for a backup (works on both platforms) or `-i ''` for no backup on macOS only.

---

## Level 14: Advanced awk

> *awk is a complete programming language for text.*

```
awk 'BEGIN{setup} condition{action} END{teardown}' file
```

| Variable | Value |
|---|---|
| `$0` | Entire current line |
| `$1`, `$2`... | Fields 1, 2... |
| `$NF` | Last field |
| `NR` | Current record (line) number |
| `NF` | Number of fields on current line |
| `FS` | Input field separator |
| `OFS` | Output field separator |

**Common patterns:**

```bash
# Print specific fields
awk '{print $1, $3}' data.txt

# Use custom delimiter
awk -F: '{print $1}' /etc/passwd

# Filter rows
awk '$3 > 100' data.txt

# Sum a column
awk '{sum += $2} END {print "Total:", sum}' scores.txt

# Print with formatting
awk '{printf "%-20s %5d\n", $1, $2}' data.txt

# Print header then data
awk 'BEGIN{print "NAME  SCORE"} {print}' scores.txt

# Multi-condition
awk '$2 > 50 && $3 == "PASS"' results.txt
```
