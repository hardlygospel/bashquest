---
title: "Levels"
description: "All 61 levels across twelve tiers, from basic navigation to enterprise storage, networking, and desktop ricing."
---

BashQuest has 61 levels split across twelve tiers, from basic navigation all the way to storage, enterprise networking, SAN, kernels, and desktop ricing. Each level has 5–8 challenges. Every challenge explains the command's purpose: not just its syntax.

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
