---
title: "Levels 82–86: TUI Toolbelt"
description: "ranger, cmus, mpd/mpc, btop, and fzf: a keyboard-only toolbelt that never leaves the terminal."
---

## Level 82: ranger

> *A full-screen file manager built for the keyboard, vim-style keybindings and a live preview pane, turning multi-step file operations into a handful of keystrokes.*

| Command | What it does |
|---|---|
| `ranger` | Launch in the current directory |
| `ranger /var/log` | Launch in a specific directory |
| `jkhl` | Navigation keys: down / up / back a directory / into a directory |
| `S` | Drop to a real shell, already cd'd where ranger is browsing |
| `/` | Search forward for a file or directory by name |

---

## Level 83: cmus

> *A full TUI music player that never leaves the terminal: browse a library, queue tracks, control playback, no mouse or GUI window involved.*

| Command | What it does |
|---|---|
| `cmus` | Launch |
| `:add ~/Music` | Command mode: recursively add a library path |
| `c` | Play/pause |
| `b` | Skip to the next track |
| `cmus-remote -n` | Control a detached instance from a different terminal |

---

## Level 84: mpd & mpc

> *cmus is a player. MPD is a background daemon that owns your music library and does the actual playing, controlled by any of a dozen lightweight clients.*

| Command | What it does |
|---|---|
| `mpd` | Start the daemon |
| `mpc update` | Rescan the music directory for new files |
| `mpc add "Artist/Album/Track.flac"` | Add a track to the queue |
| `mpc play` | Start playback |
| `mpc status` (or `mpc current`) | Check what's playing right now |
| `mpc random` | Toggle shuffle mode |

---

## Level 85: btop

> *The modern answer to top/htop: full mouse support, per-core graphs, disk and network I/O, and an interface that fits the ricing half of this job as much as the monitoring half.*

| Command | What it does |
|---|---|
| `btop` | Launch |
| `/` | Filter the process list live |
| `k` | Kill the selected process (opens a signal picker) |
| `p` | Cycle between preset layouts |
| `btop -p 2` | Launch straight into a specific preset |

---

## Level 86: fzf

> *Every tool in this tier replaces a whole workflow. fzf replaces a single reflex: type a few loose characters instead of remembering an exact name, and pick from a live fuzzy-filtered list.*

```bash
git branch | fzf                              # fuzzy-pick from any piped list
# Ctrl-R: fuzzy search shell history (replaces the plain reverse-search)
# Ctrl-T: fuzzy-insert a file path at the cursor
fzf --preview 'cat {}'                        # live preview of the highlighted item
ps aux | fzf | awk '{print $2}' | xargs kill  # fuzzy-pick a process to kill
```

:::tip
fzf reads lines from stdin and writes the selected line to stdout, nothing more. That's the entire design, and it's exactly why it composes with almost anything that produces a list.
:::

---

Finish this tier and move on to [Modern TUI Tools](/bashquest/levels/18-modern-tui-tools/): the newer generation of these same ideas, plus dedicated TUI dashboards for git and Docker.
