---
title: "Levels 58–61: Desktop Ricing"
description: "X11/Wayland and window managers, i3, AwesomeWM & compositors, dotfiles and theming."
---

## Level 58: X11, Wayland & Window Managers

| Command | What it does |
|---|---|
| `echo $XDG_SESSION_TYPE` | Check whether you're on X11 or Wayland |
| `loginctl list-sessions` | List every active login session |
| `ls /usr/share/xsessions` | List available X11 window manager sessions |
| `ls /usr/share/wayland-sessions` | List available Wayland-native sessions |
| `pgrep -l i3` | Check whether a specific WM process is running |

---

## Level 59: i3 Window Manager

> *A tiling window manager: no dragging windows, everything snaps into a grid, controlled entirely from the keyboard.*

| Command | What it does |
|---|---|
| `i3-msg reload` | Apply a config edit live, no restart |
| `i3-msg restart` | Restart i3 itself, preserving the current layout |
| `bindsym $mod+Return exec alacritty` | Bind a key to launch a terminal |
| `bindsym $mod+2 workspace 2` | Bind a key to switch workspace |
| `bindsym $mod+Shift+2 move container to workspace 2` | Bind a key to move a window to a workspace |

---

## Level 60: AwesomeWM & Compositors

> *AwesomeWM configures entirely in Lua. A compositor like picom adds the transparency, shadows, and smooth rendering a tiling WM doesn't provide on its own.*

| Command | What it does |
|---|---|
| Lua | The language `rc.lua`, AwesomeWM's config, is written in |
| `picom &` | Launch the compositor in the background |
| `picom --config ~/.config/picom.conf` | Launch with a specific config file |
| `pgrep picom` | Check for an already-running compositor |
| `pkill picom && picom -b` | Cleanly restart the compositor, daemonized |

---

## Level 61: Dotfiles & Theming

> *The tier's closing skill: managing every config you just spent three levels tuning, so one command reproduces your whole setup on a new machine.*

```bash
# The "dotfiles as a bare repo" trick
git init --bare $HOME/.dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# from here: config add ~/.vimrc && config commit -m "vimrc"

# Or, package-based with GNU Stow
stow nvim

# Theming
gsettings set org.gnome.desktop.interface gtk-theme "Nordic"
feh --bg-fill ~/Pictures/wallpaper.jpg
```

:::tip
Bare-repo dotfiles need no symlinks and no separate checked-out folder, git just tracks files that are already exactly where they need to be. Stow is the alternative: real files live in a package folder, stow symlinks them into place.
:::

---

Finish this level and the run keeps going: five more tiers cover git, Docker, snap/flatpak, tmux, and a TUI toolbelt before graduation. See [Git & Version Control](/bashquest/levels/13-git-version-control/) for what's next, or [how to play](/bashquest/getting-started/how-to-play/#graduation) for what the actual graduation ceremony looks like at the end of level 86.
