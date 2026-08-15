---
title: "Installation"
description: "System requirements and how to download and run BashQuest on Linux or macOS."
---

## Requirements

| Requirement | Detail |
|---|---|
| **Shell** | Bash 3.2 or higher |
| **OS** | Linux (any distro) or macOS |
| **Dependencies** | None: pure Bash, no external tools needed |
| **Disk** | ~60 KB for the script |

:::note
macOS ships Bash 3.2 by default (due to GPL licensing). BashQuest is fully compatible with 3.2+. If you have Bash 5 via Homebrew, it works there too.
:::

---

## One-liner Install

```bash
curl -o bashquest.sh https://raw.githubusercontent.com/hardlygospel/bashquest/main/bashquest.sh \
  && chmod +x bashquest.sh \
  && bash bashquest.sh
```

---

## Manual Install

**1. Download the script**

```bash
curl -O https://raw.githubusercontent.com/hardlygospel/bashquest/main/bashquest.sh
```

Or with wget:

```bash
wget https://raw.githubusercontent.com/hardlygospel/bashquest/main/bashquest.sh
```

**2. Make it executable**

```bash
chmod +x bashquest.sh
```

**3. Run it**

```bash
bash bashquest.sh
```

---

## Install System-wide (optional)

To run `bashquest` from anywhere:

```bash
sudo mv bashquest.sh /usr/local/bin/bashquest
sudo chmod +x /usr/local/bin/bashquest

# Then just run:
bashquest
```

---

## Save Data Location

BashQuest saves all user accounts and progress to `~/.bashquest/`:

```
~/.bashquest/
├── users.db          # hashed credentials (username:md5hash)
├── alice.save        # Alice's level/XP/lives
└── bob.save          # Bob's progress
```

To reset your progress, delete your `.save` file:

```bash
rm ~/.bashquest/yourname.save
```

To reset everything (all users):

```bash
rm -rf ~/.bashquest/
```

---

## Updating

```bash
# Re-download over the existing file
curl -o bashquest.sh https://raw.githubusercontent.com/hardlygospel/bashquest/main/bashquest.sh

# Your save data in ~/.bashquest/ is untouched
```
