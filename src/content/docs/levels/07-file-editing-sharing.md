---
title: "Levels 35–39: File Editing & Sharing"
description: "Vim essentials, ACLs, Samba, NFS, and rsync backups."
---

## Level 35: Vim Essentials

> *Every Linux box has vim, or at least vi. Editing a config over SSH at 3am is not the time to learn modal editing from scratch.*

| Key / Command | What it does | Why it matters |
|---|---|---|
| `vim file` | Open a file | Starts in normal mode, keystrokes are commands |
| `i` | Enter insert mode | Now you can type text |
| `Esc` | Back to normal mode | The most-pressed key in vim |
| `dd` | Delete the current line | `3dd` deletes three lines |
| `/pattern` | Search forward | `n` repeats, `?` searches backward |
| `:wq` | Save and quit | `:q!` discards changes instead |
| `:%s/foo/bar/g` | Replace every occurrence in the file | `%` = every line, `g` = every match per line |

---

## Level 36: Advanced Permissions & ACLs

> *chmod's owner/group/other model runs out of expressiveness fast.*

| Command | What it does | Why it matters |
|---|---|---|
| `getfacl file` | Show a file's full ACL | Standard bits plus any extended entries |
| `setfacl -m u:alice:rw file` | Grant a specific user access | Extra access without changing the owner |
| `setfacl -m g:devs:rx file` | Grant a specific group access | Same idea, for a whole group |
| `setfacl -b file` | Strip all extended ACLs | Clean baseline when ACLs have drifted |
| `umask` | Show the current default-permission mask | Determines new file/dir permissions |
| `umask 027` | Tighten the umask | New files: 640, new dirs: 750 |

---

## Level 37: Samba File Sharing

> *How a Linux box speaks SMB, so Windows machines see it as a normal network share.*

| Command | What it does | Why it matters |
|---|---|---|
| `testparm` | Validate smb.conf syntax | Test before restarting, a broken restart drops every share |
| `smbpasswd -a alice` | Set a Samba password for a Linux user | Samba keeps its own separate password database |
| `systemctl restart smbd` | Apply a config change | Samba doesn't reread its config automatically |
| `smbclient -L fileserver -U alice` | List shares from a client | Confirms share name and credentials before mounting |
| `mount -t cifs //fileserver/data /mnt/win -o username=alice` | Mount a Samba share | `cifs` is the modern SMB client filesystem |

---

## Level 38: NFS Sharing

> *The native way Unix and Linux machines share filesystems with each other.*

| Command | What it does | Why it matters |
|---|---|---|
| `exportfs -v` | Show current NFS exports | Reads the live kernel export table |
| `exportfs -ra` | Apply /etc/exports changes | Re-exports everything without an interruption |
| `showmount -e 192.168.1.10` | See what a server exports | Check before mounting blind |
| `mount -t nfs 192.168.1.10:/data /mnt/nfs` | Mount an NFS share | `server:/path` as one argument |
| `umount /mnt/nfs` | Unmount | `-f` forces it, `-l` does a lazy unmount |

---

## Level 39: Sync & Backup with rsync

> *Only transfers what changed. Runs over SSH with no extra setup. Learn this one properly.*

```bash
rsync -av home/ /mnt/backup/                    # basic archive copy
rsync -av --delete home/ /mnt/backup/            # mirror exactly, remove extras at destination
rsync -avz -e ssh home/ alice@backup:/data/      # sync over SSH
rsync -avzn home/ /mnt/backup/                   # dry run, preview only
rsync -avz --progress home/ /mnt/backup/         # live progress on a large transfer
```

:::caution
Always dry-run (`-n` or `--dry-run`) a sync that uses `--delete` before trusting it against anything that matters.
:::
