---
title: "Levels"
description: "All 90 levels across eighteen tiers, from basic navigation to enterprise storage, networking, containers, and desktop ricing."
---

BashQuest has 90 levels split across eighteen tiers, from basic navigation all the way to storage, enterprise networking, SAN, kernels, containers, and desktop ricing. Each level has 4–8 challenges. Every challenge explains the command's purpose: not just its syntax.

| Tier | Levels | Focus |
|---|---|---|
| **Beginner** | 1–4 | Navigation, files, search, permissions |
| **Intermediate** | 5–8 | Processes, text tools, networking, scripting basics |
| **Pipes & Patterns** | 9–14 | Piping, redirection, regex, grep, sed, awk |
| **Power Tools** | 15–20 | xargs/find, disk, system info, users, SSH, environment |
| **Expert** | 21–28 | Cron, logs, packages, compression, strings, arrays, error handling, systemd |
| **Storage & Filesystems** | 29–34 | Partitioning, filesystems, mounting, LVM |
| **File Editing & Sharing** | 35–39 | Vim, ACLs, Samba, NFS, rsync |
| **Networking** | 40–45 | IP addressing, routing, DNS, firewalls, VLANs, bonding |
| **Storage Networking & SAN** | 46–49 | iSCSI, autofs, multipath, Fibre Channel |
| **Boot Process & Kernel** | 50–54 | Boot process, GRUB, alternative boot managers, kernel panics, building a kernel |
| **Media Management** | 55–57 | ffmpeg, library organization, home media servers |
| **Desktop Ricing** | 58–61 | X11/Wayland, i3, AwesomeWM, compositors, dotfiles |
| **Git & Version Control** | 62–67 | init/status/config, staging, history, branching, remotes, undo |
| **Docker & Containers** | 68–73 | Images, running/exec/logs, building, volumes/networks, Compose, cleanup |
| **Universal Packages** | 74–77 | Snap install/channels/revert, Flatpak install/remotes |
| **Terminal Multiplexing** | 78–81 | tmux sessions, windows, panes, detach/reattach |
| **TUI Toolbelt** | 82–86 | ranger, cmus, mpd/mpc, btop, fzf |
| **Modern TUI Tools** | 87–90 | Yazi, lazygit, lazydocker, zellij |

## Every Level and Its Commands

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
| 29 | Disks & Partitions | `lsblk` `fdisk -l` `parted -l` `blkid` |
| 30 | Partitioning | `parted mkpart` `fdisk n/w` `partprobe` |
| 31 | Filesystems | `mkfs.ext4` `mkfs.xfs` `mkswap` |
| 32 | Mounting & fstab | `mount` `umount` `/etc/fstab` UUID |
| 33 | LVM: Volumes & Groups | `pvcreate` `vgcreate` `lvcreate` |
| 34 | LVM: Resize & Snapshots | `lvextend` `resize2fs` `lvcreate -s` |
| 35 | Vim Essentials | `i` `Esc` `:wq` `dd` `/search` `:%s` |
| 36 | Permissions & ACLs | `setfacl` `getfacl` `umask` |
| 37 | Samba File Sharing | `smb.conf` `smbpasswd` `testparm` |
| 38 | NFS Sharing | `/etc/exports` `exportfs` `showmount` |
| 39 | Sync & Backup | `rsync -avz` `--delete` `-e ssh` |
| 40 | IP Addressing | `ip addr` `ip link` `hostname -I` |
| 41 | Routing & Gateways | `ip route` `traceroute` `mtr` |
| 42 | DNS Tools | `dig` `nslookup` `/etc/hosts` |
| 43 | Firewalls | `iptables` `nft` `ufw` |
| 44 | VLANs & Trunking | `ip link ... type vlan` `802.1Q` |
| 45 | Bonding & Troubleshooting | `tcpdump` `mtr` `ip -s link` |
| 46 | iSCSI Initiators & Targets | `iscsiadm` `targetcli` |
| 47 | NFS/SMB at Scale | `autofs` `automount` |
| 48 | Multipath & SAN | `multipath -ll` WWN, zoning |
| 49 | Fibre Channel Storage | `lsscsi` `systool` `multipath -F` |
| 50 | Boot Process Overview | `systemctl get-default` `systemd-analyze` |
| 51 | GRUB2 | `update-grub` `grub-mkconfig` |
| 52 | Alternative Boot Managers | `bootctl` `systemd-boot` `rEFInd` |
| 53 | Kernel Panics & Recovery | rescue mode, `journalctl -b -1`, initramfs |
| 54 | Building a Kernel | `menuconfig` `make` `modules_install` |
| 55 | ffmpeg Basics | transcode, extract audio, thumbnails |
| 56 | Media Library Organization | `find` `rename` `sha256sum` |
| 57 | Home Media Server | layout, hwaccel, transcode |
| 58 | X11/Wayland & WMs | `XDG_SESSION_TYPE` `loginctl` |
| 59 | i3 Window Manager | `mod+enter` workspaces, config |
| 60 | AwesomeWM & Compositors | `rc.lua` `picom` |
| 61 | Dotfiles & Theming | `stow` `git` bare-repo dotfiles |
| 62 | Git Basics | `git init` `status` `config --global` |
| 63 | Staging & Committing | `add` `commit -m` `-am` `diff --staged` |
| 64 | History & Diffs | `log` `--oneline` `diff` `show` `blame` |
| 65 | Branching & Merging | `branch` `switch -c` `merge` `branch -d` |
| 66 | Remotes | `clone` `remote add` `push -u` `pull` `fetch` |
| 67 | Undo & Ignore | `restore` `reset --soft` `revert` `stash` `.gitignore` |
| 68 | Images & Containers | `docker run -d` `-p` `ps -a` `images` |
| 69 | Logs, Exec & Inspecting | `logs -f` `exec -it` `inspect` `stats` |
| 70 | Building Images | `Dockerfile` `FROM` `build -t` `tag` `push` |
| 71 | Volumes & Networks | `volume create` `-v` `network create` |
| 72 | Docker Compose | `compose up -d` `--scale` `logs -f` `down` |
| 73 | Cleanup & Pruning | `container/image/system prune` `rm -f` `df` |
| 74 | Installing with Snap | `snap install` `list` `info` `--classic` |
| 75 | Snap Channels & Updates | `refresh` `--channel=edge` `revert` `disable` |
| 76 | Installing with Flatpak | `flatpak install` `run` `list` `--unused` |
| 77 | Flatpak Remotes | `remote-add` `remotes` `update` `search` |
| 78 | Starting tmux | `new -s` `ls` `attach -t` `kill-session` |
| 79 | Windows in a Session | `new-window -n` `rename-window` `next-window` |
| 80 | Panes | `split-window -h/-v` `select-pane -R` `resize-pane` |
| 81 | Detach & Reattach | `detach` `attach` `attach -d` `ls` |
| 82 | ranger | `ranger` `hjkl` `S` `/` |
| 83 | cmus | `:add` `c` `b` `cmus-remote -n` |
| 84 | mpd & mpc | `mpd` `mpc update/add/play/status/random` |
| 85 | btop | `/` `k` `p` `btop -p` |
| 86 | fzf | `\| fzf` `Ctrl-R` `Ctrl-T` `--preview` |
| 87 | Yazi | `yazi` `Enter` `y`/`p` `t` |
| 88 | lazygit | `space` `c` (commit) `P` (push) `5` |
| 89 | lazydocker | `Enter` `d` (delete) `Tab` `r` (restart) |
| 90 | zellij | `-s` `attach` `Ctrl-p` `Ctrl-o d` |
