---
title: "Levels 78–81: Terminal Multiplexing"
description: "tmux sessions, windows, panes, and the detach/reattach loop that lets a job outlive a dropped SSH connection."
---

## Level 78: Starting tmux

> *An SSH session that drops kills every process running inside it, unless that process is running inside tmux. A tmux session lives on the server itself, independent of any one connection to it.*

| Command | What it does |
|---|---|
| `tmux new -s deploy` | Start a new, named session |
| `tmux ls` | List running sessions |
| `tmux attach -t deploy` | Reattach to a named session |
| `tmux kill-session -t deploy` | End a session entirely, from outside it |

---

## Level 79: Windows Inside a Session

> *One session can hold multiple windows, each a full separate terminal screen, closer to browser tabs than anything else.*

| Command | What it does |
|---|---|
| `tmux new-window` | Create a new window in the current session |
| `tmux new-window -n logs` | Create and name it in one step |
| `tmux rename-window deploy` | Rename the current window |
| `tmux next-window` | Switch to the next window |
| `tmux list-windows` | List every window in the session |

---

## Level 80: Panes

| Command | What it does |
|---|---|
| `tmux split-window -h` | Split side by side (the divider runs vertically) |
| `tmux split-window -v` | Split stacked (the divider runs horizontally) |
| `tmux select-pane -R` | Move focus right (`-L`/`-U`/`-D` for the others) |
| `tmux resize-pane -R 10` | Resize by 10 cells in a direction |
| `tmux kill-pane` | Close the current pane |

:::tip
tmux names splits by which way the *divider* runs, not which way the panes end up sitting. `-h` gives you left/right panes; `-v` gives you top/bottom. Easy to get backwards the first few times.
:::

---

## Level 81: Detach & Reattach

> *This is the entire reason tmux exists for a sysadmin: a long-running job survives an SSH connection dropping, on purpose.*

| Command | What it does |
|---|---|
| `tmux detach` (or Ctrl-b d) | Leave the session running, disconnect cleanly |
| `tmux attach` | Reattach to the most recently used session |
| `tmux attach -d` | Reattach, force-detaching every other connected client |
| `tmux ls` | Prove a job survived a dropped connection: if the session's still listed, whatever was running inside it never stopped |

---

Finish this tier and move on to [TUI Toolbelt](/bashquest/levels/17-tui-toolbelt/): a file manager, two approaches to terminal music, a resource monitor, and the fuzzy finder that ends up wired into everything.
