---
title: "Levels 50–54: Boot Process & Kernel"
parent: Levels
nav_order: 10
---

# Levels 50–54: Boot Process & Kernel
{: .no_toc }

<details open markdown="block">
  <summary>Contents</summary>
  {: .text-delta }
- TOC
{:toc}
</details>

---

## Level 50: Boot Process Overview

| Command | What it does |
|---|---|
| `systemctl get-default` | Show the default boot target |
| `systemctl set-default multi-user.target` | Set a headless (no GUI) default |
| `systemctl list-units --type=target` | List every available target |
| `systemd-analyze` | Boot time breakdown: firmware, loader, kernel, userspace |
| `systemd-analyze blame` | Every unit ranked by startup time, slowest first |

---

## Level 51: GRUB2

| Command | What it does |
|---|---|
| `update-grub` (Debian) / `grub2-mkconfig -o /boot/grub2/grub.cfg` (RHEL) | Regenerate grub.cfg after an edit |
| `grub-install /dev/sda` | Reinstall GRUB's boot code onto a disk |
| `cat /etc/default/grub` | The human-edited source, not the generated config |
| `ls` (at a `grub rescue>` prompt) | List partitions GRUB can see |
| `e` (at the GRUB menu) | Edit a boot entry's kernel parameters for one boot |

{: .warning }
Always edit `/etc/default/grub`, never `grub.cfg` directly. `update-grub` regenerates the real config from it.

---

## Level 52: Alternative Boot Managers

> *GRUB isn't the only option. systemd-boot is minimal and ships with systemd; rEFInd is a graphical multi-OS picker.*

| Command | What it does |
|---|---|
| `bootctl status` | Current systemd-boot status and entries |
| `bootctl update` | Update systemd-boot binaries on the ESP |
| `bootctl list` | List every boot entry |
| `bootctl install` | First-time install onto the EFI system partition |

---

## Level 53: Kernel Panics & Recovery

> *The kernel dumps everything it knows right before it dies. Reading that output is how you fix it.*

| Command | What it does |
|---|---|
| `systemd.unit=rescue.target` (kernel param) | Boot straight into a rescue shell |
| `journalctl -b -1` | Read the PREVIOUS boot's logs, where the panic actually happened |
| `dmesg` | Kernel ring buffer, direct from the kernel |
| `update-initramfs -u` (Debian) / `dracut -f` (RHEL) | Rebuild the initramfs after a driver fix |
| `touch /forcefsck` | Force a filesystem check on the next boot |

{: .tip }
The current boot's logs won't show a crash, it happened on the boot before. `journalctl -b -1` is the single most useful command after an unexpected reboot.

---

## Level 54: Building a Kernel

```bash
make menuconfig              # interactive configuration menu
make -j$(nproc)              # compile, using every CPU core
sudo make modules_install    # install built modules
sudo make install            # install the kernel image
sudo update-grub             # make it a selectable boot entry
```

Almost nobody builds a kernel from source for daily use, distros handle that. But knowing how, adding a missing driver or enabling a feature flag, is the deepest level of Linux mastery, and it demystifies everything above it.
