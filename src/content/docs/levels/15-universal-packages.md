---
title: "Levels 74–77: Universal Packages"
description: "Snap install/channels/revert and Flatpak install/remotes: two competing answers to sandboxed, distro-independent app installs."
---

## Level 74: Installing with Snap

> *apt, dnf, and pacman install packages built for one distro's exact library versions. Every snap bundles its own dependencies and runs sandboxed, so it installs identically anywhere snapd runs.*

| Command | What it does |
|---|---|
| `snap install spotify` | Install a snap |
| `snap list` | List installed snaps |
| `snap info spotify` | Details before installing |
| `snap remove spotify` | Uninstall |
| `snap install code --classic` | Install with full system access instead of the normal sandbox |

---

## Level 75: Snap Channels & Updates

| Command | What it does |
|---|---|
| `snap refresh` | Check for and install updates to everything installed |
| `snap install mytool --channel=edge` | Install tracking a specific release channel |
| `snap list --all mytool` | See every kept revision, not just the active one |
| `snap revert mytool` | Roll back to the previous working revision |
| `snap disable mytool` | Disable without uninstalling |

---

## Level 76: Installing with Flatpak

> *Flathub is the community app store almost every flatpak setup points at by default.*

| Command | What it does |
|---|---|
| `flatpak install flathub org.gimp.GIMP` | Install an app from a remote |
| `flatpak run org.gimp.GIMP` | Launch by app ID |
| `flatpak list` | List installed flatpaks |
| `flatpak uninstall org.gimp.GIMP` | Remove an app |
| `flatpak uninstall --unused` | Clean up orphaned shared runtimes |

---

## Level 77: Flatpak Remotes

| Command | What it does |
|---|---|
| `flatpak remote-add --if-not-exists flathub <url>` | Wire up the flathub remote |
| `flatpak remotes` | List configured remotes |
| `flatpak update` | Update everything installed |
| `flatpak search video editor` | Search flathub by keyword |
| namespaces | The Linux kernel isolation feature flatpak sandboxing is built on (via bubblewrap), versus snap's AppArmor-based confinement |

:::tip
Both sandbox apps and bundle dependencies, but differently: snap ships a full, mostly self-contained package per app, while flatpak shares a deduplicated pool of runtimes across every app that depends on them.
:::

---

Finish this tier and move on to [Terminal Multiplexing](/bashquest/levels/16-terminal-multiplexing/): tmux, and why an SSH session dropping doesn't have to mean your work dies with it.
