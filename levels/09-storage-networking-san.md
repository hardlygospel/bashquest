---
title: "Levels 46–49: Storage Networking & SAN"
parent: Levels
nav_order: 9
---

# Levels 46–49: Storage Networking & SAN
{: .no_toc }

<details open markdown="block">
  <summary>Contents</summary>
  {: .text-delta }
- TOC
{:toc}
</details>

---

## Level 46: iSCSI Initiators & Targets

> *SCSI storage commands over an ordinary IP network. The initiator asks, the target offers.*

| Command | What it does |
|---|---|
| `iscsiadm -m discovery -t sendtargets -p 192.168.1.20` | Discover targets on a portal |
| `iscsiadm -m node -T <iqn> -p <portal> --login` | Log into a target, establish the session |
| `iscsiadm -m session` | List active sessions |
| `iscsiadm -m node -T <iqn> --logout` | Cleanly disconnect |
| `targetcli` | Configure an iSCSI target (server side) |

---

## Level 47: NFS/SMB at Scale + autofs

> *Manually mounting shares doesn't scale past a handful of machines. autofs mounts on access, unmounts after a timeout.*

| Command | What it does |
|---|---|
| `systemctl status autofs` | Check the autofs service |
| `systemctl reload autofs` | Apply new map entries without a full restart |
| `cat /etc/auto.master` | Show the top-level autofs map |
| `mount` | See everything currently mounted |
| `umount -f /mnt/nfs` | Force-unmount a stale/unreachable share |

---

## Level 48: Multipath & SAN Concepts

> *A server connected to storage over multiple redundant paths, made to look like one reliable device.*

| Command | What it does |
|---|---|
| `multipath -ll` | List multipath devices and path states |
| `ls -la /dev/disk/by-id/` | Identify devices by WWN, not changeable /dev names |
| `systemctl restart multipathd` | Restart the multipath daemon |
| `multipath -f mpatha` | Flush one named device map |

{: .tip }
A WWN (World Wide Name) is burned into the storage hardware and never changes, even if Linux renames `/dev/sdb` after a reboot. SAN zoning is configured against WWNs for exactly this reason.

---

## Level 49: Fibre Channel & Storage Troubleshooting

> *FC is the older, dedicated-fabric sibling of iSCSI. Different tools, same troubleshooting instinct.*

| Command | What it does |
|---|---|
| `lsscsi` | List every SCSI device (iSCSI and FC alike) |
| `echo "- - -" \| tee /sys/class/scsi_host/host0/scan` | Rescan a host for new LUNs |
| `cat /sys/class/fc_host/host0/port_state` | Check an FC HBA port's link state |
| `multipath -F` | Clean up every unused multipath map at once |
