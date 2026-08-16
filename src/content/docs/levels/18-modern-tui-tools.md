---
title: "Levels 87–90: Modern TUI Tools"
description: "Yazi, lazygit, lazydocker, and zellij: the newer generation of terminal tools, and the graduation finale."
---

## Level 87: Yazi

> *ranger proved the concept: vim-keys, full-screen, keyboard-only file management. Yazi is the newer, Rust-built answer to the same problem - async I/O, built-in image previews, and a plugin system, without giving up a single one of ranger's keybindings.*

| Command | What it does |
|---|---|
| `yazi` | Launch in the current directory |
| `yazi ~/Downloads` | Launch in a specific directory |
| `Enter` (or `l`) | Enter a directory, or open a file with its default app |
| `y` | Yank (copy) the highlighted file or directory |
| `t` | Open a new tab at the current directory |

---

## Level 88: lazygit

> *Every command from the Git & Version Control tier still works exactly the same, typed by hand. lazygit wraps the entire day-to-day loop into one full-screen view driven entirely by the keyboard.*

| Command | What it does |
|---|---|
| `lazygit` | Launch in the current repository |
| `space` | Stage/unstage the highlighted file |
| `c` | Open the commit-message prompt |
| `P` | Push the current branch (lowercase `p` pulls) |
| `5` | Jump straight to the commit log panel |

---

## Level 89: lazydocker

> *docker ps, docker logs -f, docker stats: three separate commands for a live picture of what's running. lazydocker puts containers, images, volumes, and their live logs and stats in one dashboard.*

| Command | What it does |
|---|---|
| `lazydocker` | Launch |
| `Enter` | View the highlighted container's live logs |
| `d` | Remove the highlighted container (or image, or volume) |
| `Tab` | Switch focus between panels |
| `r` | Restart the highlighted, currently-running container |

---

## Level 90: zellij

> *tmux has been the standard multiplexer for decades, and everything from the Terminal Multiplexing tier still works exactly the same. zellij is the newer, Rust-built alternative: the same core idea, with discoverable on-screen keybinding hints and a plugin system.*

```bash
zellij                          # start a new session
zellij --session deploy         # start a named session (or: zellij -s deploy)
zellij list-sessions            # list sessions
zellij attach deploy            # reattach to a named session
```

- **Ctrl-p** opens pane mode, for splitting and navigating panes.
- **Ctrl-o d** detaches: `Ctrl-o` opens session mode, `d` detaches - a two-step chord instead of tmux's single prefix-then-key, one of the bigger practical differences between the two.

:::tip
zellij's status bar shows exactly which keys do what while you're in a given mode - the discoverability tmux never had built in, which is a big part of why it's caught on with people who never fully memorized tmux's own muscle memory.
:::

---

Finish this level and you graduate: a certificate with your name, final stats, and badges, written to `~/.bashquest/<name>.certificate.txt`, plus a closing word from Tasmania. See [how to play](/bashquest/getting-started/how-to-play/#graduation) for what that looks like.
