---
title: "Command Reference"
description: "Quick lookup for every command covered across all 86 levels."
---

Quick lookup for every command covered across all 86 levels.

---

## Navigation

```bash
ls              # list directory
ls -l           # long format (permissions, owner, size)
ls -la          # long format + hidden files
ls -lh          # long format + human-readable sizes
pwd             # print working directory
cd dir          # change directory
cd ~  /  cd     # go home
cd -            # go back to previous directory
cd ..           # go up one level
mkdir dir       # make directory
mkdir -p a/b/c  # make nested directories
rmdir dir       # remove empty directory
tree            # show directory tree (if installed)
```

---

## Files

```bash
cat file            # print file
less file           # page through file (q=quit, /=search)
head -n 10 file     # first 10 lines
tail -n 10 file     # last 10 lines
tail -f file        # follow file live
touch file          # create empty file / update timestamp
cp src dst          # copy file
cp -r src/ dst/     # copy directory recursively
mv src dst          # move or rename
rm file             # delete (permanent)
rm -r dir           # delete directory recursively
rm -rf dir          # delete without confirmation (dangerous)
ln -s target link   # create symbolic link
file path           # show file type
wc -l file          # count lines
wc -w file          # count words
wc -c file          # count bytes
```

---

## Archives & Compression

```bash
# tar
tar -czf out.tar.gz  dir/   # create gzip archive
tar -cjf out.tar.bz2 dir/   # create bzip2 archive
tar -cJf out.tar.xz  dir/   # create xz archive
tar -xzf file.tar.gz        # extract gzip
tar -xzf file.tar.gz -C /path/  # extract to directory
tar -tzf file.tar.gz        # list contents

# gzip
gzip file           # compress (replaces original)
gzip -k file        # compress, keep original
gunzip file.gz      # decompress
zcat file.gz        # read without decompressing
zgrep ERR file.gz   # grep inside .gz file

# bzip2
bzip2 file          # compress
bunzip2 file.bz2    # decompress
bzcat file.bz2      # read

# xz
xz file             # compress
xz -9 file          # maximum compression
unxz file.xz        # decompress

# zip
zip -r out.zip dir/ # create zip
unzip out.zip       # extract
unzip -l out.zip    # list contents
```

---

## Search & Filter

```bash
grep pattern file           # search for pattern
grep -i pattern file        # case-insensitive
grep -v pattern file        # invert: lines NOT matching
grep -n pattern file        # show line numbers
grep -c pattern file        # count matching lines
grep -l pattern dir/        # list filenames only
grep -r pattern .           # recursive search
grep -A 3 pattern file      # 3 lines after match
grep -B 3 pattern file      # 3 lines before match
grep -C 3 pattern file      # 3 lines context (both)
grep -E 'pat1|pat2' file    # extended regex
grep -o pattern file        # print only matched part
grep -w word file           # whole word match only
grep --include='*.txt' -r pattern .  # search only .txt files

find . -name '*.log'        # find by name
find . -type f              # files only
find . -type d              # directories only
find . -size +10M           # larger than 10MB
find . -mtime -1            # modified in last 1 day
find . -mmin -60            # modified in last 60 minutes
find . -exec cat {} \;      # run command on each found file
find . -exec cat {} +       # run command with all files batched
find . -name '*.tmp' -delete # delete found files
find . -print0 | xargs -0 grep ERROR  # safe with spaces in names
```

---

## Text Processing

```bash
# cut
cut -d: -f1 file        # field 1, delimiter :
cut -d, -f1,3 file      # fields 1 and 3, delimiter ,
cut -c1-5 file          # characters 1–5

# sort
sort file               # alphabetical
sort -n file            # numeric
sort -r file            # reverse
sort -rn file           # reverse numeric
sort -rh file           # reverse human-readable (1G > 100M)
sort -u file            # sort + deduplicate
sort -k2 file           # sort by field 2
sort -t: -k3 -n file    # field 3, delimiter :, numeric

# uniq
uniq file               # remove adjacent duplicates
uniq -c file            # count duplicates
uniq -d file            # show only duplicates

# sed
sed 's/old/new/' file           # replace first per line
sed 's/old/new/g' file          # replace all
sed 's/old/new/2' file          # replace 2nd occurrence
sed '/pattern/d' file           # delete matching lines
sed -n '5p' file                # print line 5 only
sed -n '2,8p' file              # print lines 2–8
sed -n '/START/,/END/p' file    # print between patterns
sed -i.bak 's/old/new/g' file   # edit in-place (backup .bak)

# awk
awk '{print $1}' file               # print field 1
awk -F: '{print $1}' file           # field separator :
awk '{print NR, $0}' file           # line numbers
awk '$2 > 50' file                  # filter by condition
awk '{sum += $2} END{print sum}' f  # sum column
awk 'BEGIN{print "Header"} {print}' file
awk '{printf "%-10s %d\n", $1, $2}' file

# tr
tr 'a-z' 'A-Z'          # lowercase to uppercase
tr -d '\r'              # delete carriage returns
tr -s ' '               # squeeze multiple spaces to one

# tee
cmd | tee file          # write to file AND pass through
cmd | tee -a file       # append to file AND pass through
```

---

## Pipes & Redirection

```bash
cmd1 | cmd2             # pipe stdout of cmd1 to stdin of cmd2
cmd > file              # redirect stdout (overwrite)
cmd >> file             # redirect stdout (append)
cmd < file              # use file as stdin
cmd 2> file             # redirect stderr
cmd > file 2>&1         # redirect both to file
cmd &> file             # same (bash shorthand)
cmd > /dev/null 2>&1    # discard all output

# xargs
find . -name '*.txt' | xargs wc -l
find . -name '*.log' | xargs -I{} cp {} {}.bak
find . -print0 | xargs -0 grep ERROR
echo "a b c" | xargs -n1 echo   # one arg per line
```

---

## Permissions

```bash
chmod 755 file          # rwxr-xr-x
chmod 644 file          # rw-r--r--
chmod 600 file          # rw------- (private key)
chmod 700 dir           # rwx------ (private dir)
chmod +x file           # add execute for all
chmod -w file           # remove write for all
chmod u+x file          # add execute for owner
chown user file         # change owner
chown user:group file   # change owner and group
chown -R user dir/      # recursive
whoami                  # print current username
id                      # print UID, GID, groups
id username             # print another user's IDs
```

---

## Processes

```bash
ps aux                  # all processes, all users
ps -ef                  # all processes (BSD vs GNU)
ps aux | grep name      # find process by name
top                     # live process viewer
htop                    # better live viewer (if installed)
kill PID                # SIGTERM (polite stop)
kill -9 PID             # SIGKILL (force stop)
killall name            # kill all processes with name
jobs                    # list background jobs
bg                      # resume stopped job in background
fg                      # bring job to foreground
fg %2                   # bring job 2 to foreground
command &               # start command in background
nohup command &         # survive terminal close
```

---

## Disk & System

```bash
df -h                   # free disk space, all filesystems
df -h /var              # free space for specific filesystem
du -sh dir/             # total directory size
du -sh *                # size of all items here
du -sh * | sort -rh     # largest items first
lsblk                   # list block devices
findmnt                 # show mount tree
mount                   # list all mounts
uname -a                # kernel and architecture
uptime                  # uptime and load averages
free -h                 # RAM usage (Linux)
vm_stat                 # memory stats (macOS)
lsof                    # list open files and sockets
lsof -i :80             # what's using port 80
who                     # currently logged in users
w                       # users + what they're doing
```

---

## Networking

```bash
ping -c 4 host          # test connectivity, 4 packets
curl url                # HTTP GET, print response
curl -o file url        # download to file
curl -I url             # headers only
curl -s url             # silent (no progress)
curl -L url             # follow redirects
curl -X POST -d 'data' url
wget url                # download (saves to file)
ssh user@host           # connect to server
ssh -i key user@host    # specific key
ssh -L 8080:localhost:80 user@host  # port forward
scp file user@host:/path/  # copy to remote
scp user@host:/path/file . # copy from remote
ss -tlnp                # listening TCP ports + process
netstat -tlnp           # same (older tool)
```

---

## Users & Groups

```bash
useradd -m username         # create user with home dir
passwd username             # set password
usermod -aG group user      # add to group (always use -a)
usermod -L username         # lock account
usermod -U username         # unlock account
userdel -r username         # delete user + home
groups username             # show group memberships
id username                 # show UID, GID, groups
su - username               # switch user (full login shell)
sudo command                # run as root
visudo                      # safely edit sudoers
```

---

## SSH Keys

```bash
ssh-keygen -t ed25519 -C 'email'    # generate key pair
chmod 600 ~/.ssh/id_ed25519         # fix private key perms
chmod 700 ~/.ssh                     # fix .ssh dir perms
ssh-copy-id user@host               # copy pubkey to server
cat ~/.ssh/id_ed25519.pub           # view public key
ssh-add ~/.ssh/id_ed25519           # add key to agent
```

---

## Environment & Shell

```bash
echo $PATH                  # show PATH
export PATH=/new:$PATH      # prepend to PATH
export VAR=value            # set environment variable
alias ll='ls -lah'          # create alias
alias                       # list all aliases
unalias ll                  # remove alias
source ~/.bashrc            # reload config
. ~/.bashrc                 # same
export PS1='\u@\h:\w\$ '   # set prompt
env                         # show all environment variables
printenv VAR                # print one variable
unset VAR                   # remove variable
```

---

## Cron

```bash
crontab -l                  # list cron jobs
crontab -e                  # edit crontab
crontab -r                  # remove ALL cron jobs

# Syntax: MIN HOUR DAY MON WEEKDAY command
* * * * *    /script.sh     # every minute
0 2 * * *    /backup.sh     # daily at 2am
*/15 * * * * /sync.sh       # every 15 minutes
0 9 * * 1-5  /report.sh     # 9am weekdays
0 0 1 * *    /monthly.sh    # first of month at midnight
```

---

## Logs & Journalctl

```bash
journalctl                          # all journal entries
journalctl -f                       # follow live
journalctl -u servicename           # service logs
journalctl -fu servicename          # follow service live
journalctl -n 50                    # last 50 lines
journalctl --since '1 hour ago'     # time filter
journalctl --since '2024-01-15'     # since date
journalctl -b                       # this boot
journalctl -b -1                    # previous boot
journalctl -p err                   # errors and above
journalctl --disk-usage             # journal disk usage
logger 'message'                    # write to system log
logger -t tag 'message'             # with tag
```

---

## Systemd

```bash
systemctl status service            # status + recent logs
sudo systemctl start service        # start now
sudo systemctl stop service         # stop now
sudo systemctl restart service      # stop + start
sudo systemctl reload service       # reload config (no downtime)
sudo systemctl enable service       # enable on boot
sudo systemctl disable service      # disable on boot
sudo systemctl enable --now service # enable + start
sudo systemctl disable --now service# disable + stop
systemctl list-units --type=service # list all services
systemctl --state=failed            # show failed units
sudo systemctl daemon-reload        # reload unit files
```

---

## Bash Scripting

```bash
# Safety header: use on every production script
#!/bin/bash
set -euo pipefail

# Variables
NAME="value"
echo "$NAME"
CMD=$(date)           # capture output

# Conditionals
if [ -f "$FILE" ]; then echo "exists"; fi
if [ "$A" -eq "$B" ]; then echo "equal"; fi
[ -z "$VAR" ] && echo "empty"
[ -n "$VAR" ] && echo "not empty"

# Loops
for i in 1 2 3; do echo $i; done
for f in *.txt; do echo "$f"; done
for item in "${ARRAY[@]}"; do echo "$item"; done
while read -r line; do echo "$line"; done < file

# Functions
myfunc() {
    local arg="$1"
    echo "$arg"
    return 0
}

# Error handling
trap 'echo "Cleaning up"; rm -rf "$TMPDIR"' EXIT
command || { echo "failed" >&2; exit 1; }

# String operations
${#VAR}           # length
${VAR:0:5}        # substring
${VAR%.gz}        # strip .gz suffix
${VAR##*/}        # basename (strip up to last /)
${VAR//old/new}   # replace all
${VAR:-default}   # default if unset

# Arrays
ARR=(a b c)
echo ${ARR[0]}        # first element
echo ${ARR[@]}        # all elements
echo ${#ARR[@]}       # count
ARR+=(d)              # append
for i in "${ARR[@]}"; do echo "$i"; done
```

---

## Storage & LVM

```bash
fdisk -l /dev/sda            # partition table (MBR/GPT)
parted -l                    # partition table, GPT-native
blkid                        # device, UUID, filesystem type
lsblk -f                     # block tree with filesystem/mount
mkfs.ext4 /dev/sdb1          # format ext4
mkfs.xfs /dev/sdc1           # format XFS
mkswap /dev/sdb2 && swapon /dev/sdb2   # create + activate swap
mount /dev/sdb1 /mnt/data    # mount
mount -a                     # test /etc/fstab without rebooting
pvcreate /dev/sdb1           # physical volume
vgcreate data_vg /dev/sdb1   # volume group
lvcreate -L 10G -n data_lv data_vg     # logical volume
lvextend -L +5G /dev/data_vg/data_lv   # grow it
resize2fs /dev/data_vg/data_lv         # grow the filesystem to match
lvcreate -L 2G -s -n snap /dev/data_vg/data_lv   # snapshot
```

---

## File Editing & Sharing

```bash
vim file            # i = insert, Esc = normal mode, :wq = save+quit
dd                   # delete line (vim, normal mode)
/pattern             # search forward (vim)
:%s/foo/bar/g        # replace every occurrence (vim)
getfacl file         # view ACLs
setfacl -m u:alice:rw file   # grant a user access
setfacl -b file       # strip all ACLs
umask 027             # tighten default permissions
testparm              # validate smb.conf
smbpasswd -a alice     # set a Samba password
mount -t cifs //host/share /mnt/win -o username=alice
exportfs -ra           # apply /etc/exports changes
showmount -e host       # see what a server exports
mount -t nfs host:/data /mnt/nfs
rsync -avz --delete home/ /mnt/backup/       # mirror, remove extras
rsync -avz -e ssh home/ user@host:/data/     # sync over SSH
```

---

## Networking (Advanced)

```bash
ip addr                      # every address on every interface
ip link set eth0 up          # bring an interface up
ip route                     # routing table
ip route add default via 192.168.1.1
traceroute host              # hop-by-hop path
mtr host                     # live combined trace + ping
dig domain                   # DNS query
dig domain MX                # specific record type
dig -x ip                    # reverse lookup
iptables -L -n                # list firewall rules
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
ufw allow 22 && ufw enable    # simple firewall
ip link add link eth0 name eth0.10 type vlan id 10   # VLAN subinterface
tcpdump -i eth0 port 443      # capture traffic on a port
ip -s link show eth0          # interface error/drop counters
```

---

## Storage Networking & SAN

```bash
iscsiadm -m discovery -t sendtargets -p host   # discover iSCSI targets
iscsiadm -m node -T <iqn> -p host --login      # log into a target
iscsiadm -m session                            # list active sessions
targetcli                                      # configure a target (server side)
systemctl status autofs                        # check autofs
multipath -ll                                  # list multipath devices
ls -la /dev/disk/by-id/                        # devices by WWN
multipath -f mpatha                            # flush one device map
lsscsi                                         # list SCSI/FC devices
cat /sys/class/fc_host/host0/port_state        # FC HBA port status
```

---

## Boot Process & Kernel

```bash
systemctl get-default            # default boot target
systemd-analyze                  # boot time breakdown
systemd-analyze blame            # slowest units to start
update-grub                      # regenerate grub.cfg (Debian)
grub2-mkconfig -o /boot/grub2/grub.cfg   # same, RHEL
grub-install /dev/sda            # reinstall GRUB to a disk
bootctl status                   # systemd-boot status
bootctl update                   # update systemd-boot binaries
journalctl -b -1                 # previous boot's logs (post-panic)
dmesg                            # kernel ring buffer
update-initramfs -u              # rebuild initramfs (Debian)
dracut -f                        # rebuild initramfs (RHEL)
touch /forcefsck                 # force fsck on next boot
make menuconfig                  # configure a kernel build
make -j$(nproc)                  # compile using every core
make modules_install && make install   # install modules + kernel
```

---

## Media Management

```bash
ffmpeg -i in.mp4 out.mkv                       # convert container
ffmpeg -i in.mp4 -vn audio.mp3                 # extract audio
ffmpeg -i in.mp4 -c:v libx264 -crf 23 out.mp4  # re-encode
ffmpeg -i in.mp4 -ss 00:00:10 -vframes 1 thumb.jpg   # grab a frame
ffprobe in.mp4                                 # inspect a media file
find . -iname "*.mkv"                          # find by pattern
sha256sum *.mkv > checksums.sha256             # generate checksums
sha256sum -c checksums.sha256                  # verify checksums
iotop                                          # live per-process disk I/O
```

---

## Desktop Ricing

```bash
echo $XDG_SESSION_TYPE           # X11 or Wayland
loginctl list-sessions           # active login sessions
i3-msg reload                    # apply i3 config live
i3-msg restart                   # restart i3, keep the layout
bindsym $mod+Return exec alacritty       # i3: bind a terminal
bindsym $mod+2 workspace 2               # i3: bind a workspace switch
picom &                          # launch a compositor
picom --config ~/.config/picom.conf
git init --bare $HOME/.dotfiles  # dotfiles as a bare repo
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
stow nvim                        # deploy a dotfiles package
gsettings set org.gnome.desktop.interface gtk-theme "Nordic"
feh --bg-fill ~/Pictures/wallpaper.jpg   # set wallpaper
```

---

## Git & Version Control

```bash
git init                              # turn a directory into a repo
git config --global user.name "You"  # set your identity
git config --global user.email "you@example.com"
git status                            # what's changed/staged/untracked
git status -s                         # compact one-line-per-file status

git add file                          # stage a file
git add .                             # stage everything
git commit -m "message"               # commit staged changes
git commit -am "message"              # stage tracked changes + commit
git diff                              # unstaged changes
git diff --staged                     # staged changes (--cached also works)

git log                               # full commit history
git log --oneline                     # compact history
git show <hash>                       # inspect one commit
git blame file                        # who last changed each line

git branch                            # list branches
git branch name                       # create a branch
git switch name                       # switch branches (or: git checkout name)
git switch -c name                    # create + switch (or: git checkout -b name)
git merge name                        # merge a branch into the current one
git branch -d name                    # delete a merged branch

git clone url                         # copy a remote repo locally
git remote add origin url             # register a remote
git remote -v                         # list remotes
git push -u origin main               # push + track upstream
git pull                              # fetch + merge
git fetch                             # download without merging

git restore --staged file             # unstage (keep the edits)
git restore file                      # discard uncommitted edits
git reset --soft HEAD~1               # undo last commit, keep it staged
git revert HEAD                       # undo a commit with a new commit (safe for pushed history)
git stash                             # shelve uncommitted changes
git stash pop                         # bring them back
echo node_modules >> .gitignore       # stop tracking a path forever
```

---

## Docker & Containers

```bash
docker pull nginx                     # download an image
docker run -d nginx                   # run detached
docker run -d -p 8080:80 nginx        # run detached, publish a port
docker ps                             # running containers
docker ps -a                          # every container, running or not
docker images                         # local images

docker logs -f web                    # follow a container's logs
docker exec -it web bash              # interactive shell inside a container
docker inspect web                    # full container detail (JSON)
docker stats                          # live resource usage
docker stop web                       # stop cleanly
docker rm web                         # remove a stopped container
docker rm -f web                      # force-stop and remove

# Dockerfile: FROM sets the base image
docker build -t myapp:latest .        # build from the current directory
docker tag myapp:latest myapp:v2      # add a second tag
docker push myrepo/myapp:latest       # push to a registry

docker volume create dbdata           # named volume
docker run -d -v dbdata:/var/lib/postgresql/data postgres
docker volume ls                      # list volumes
docker network create appnet          # custom network
docker run -d --network appnet redis  # attach a container to it

docker compose up -d                  # bring up the whole stack, detached
docker compose logs -f                # follow every service's logs
docker compose up -d --scale worker=3 # scale one service
docker compose down                   # tear the stack down

docker container prune                # remove stopped containers
docker image prune                    # remove dangling images
docker system prune                   # remove all of the above at once
docker system df                      # see what's using disk space
```

---

## Universal Packages (Snap & Flatpak)

```bash
snap install spotify                  # install a snap
snap list                             # installed snaps
snap info spotify                     # details before installing
snap remove spotify                   # uninstall
snap install code --classic           # full-system-access confinement

snap refresh                          # update every installed snap
snap install mytool --channel=edge    # track a specific release channel
snap list --all mytool                # every kept revision
snap revert mytool                    # roll back a bad update
snap disable mytool                   # disable without uninstalling

flatpak install flathub org.gimp.GIMP # install from a remote
flatpak run org.gimp.GIMP             # launch by app ID
flatpak list                          # installed flatpaks
flatpak uninstall org.gimp.GIMP       # remove an app
flatpak uninstall --unused            # clean up orphaned runtimes

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remotes                       # configured remotes
flatpak update                        # update everything
flatpak search video editor           # search flathub
```

---

## Terminal Multiplexing (tmux)

```bash
tmux new -s deploy               # start a named session
tmux ls                          # list sessions
tmux attach -t deploy            # reattach to a session
tmux kill-session -t deploy      # end a session entirely

tmux new-window                  # new window in the session
tmux new-window -n logs          # create + name it in one step
tmux rename-window deploy        # rename the current window
tmux next-window                 # cycle to the next window
tmux list-windows                # list windows in the session

tmux split-window -h             # split side by side
tmux split-window -v             # split stacked
tmux select-pane -R              # move focus right (-L/-U/-D too)
tmux resize-pane -R 10           # resize by 10 cells
tmux kill-pane                   # close the current pane

tmux detach                      # leave the session running, disconnect (Ctrl-b d)
tmux attach                      # reattach to the most recent session
tmux attach -d                   # reattach, kicking other clients off
```

---

## TUI Toolbelt

```bash
# ranger - keyboard-driven file manager
ranger                # launch in the current directory
ranger /var/log       # launch in a specific directory
# hjkl = down/up/back/into (same as vim), S = drop to a shell here, / = search

# cmus - terminal music player
cmus                   # launch
:add ~/Music           # command mode: add a library path
# c = play/pause, b = next track
cmus-remote -n         # control a detached instance from another terminal

# mpd/mpc - background music daemon + client
mpd                     # start the daemon
mpc update              # rescan the music directory
mpc add "Artist/Album/Track.flac"
mpc play                # start playback
mpc status              # what's playing right now
mpc random              # toggle shuffle

# btop - modern resource monitor
btop                    # launch
# / = filter processes, k = kill selected, p = cycle presets
btop -p 2                # launch straight into preset 2

# fzf - fuzzy finder
git branch | fzf                       # fuzzy-pick from any piped list
# Ctrl-R = fuzzy search shell history, Ctrl-T = fuzzy-insert a file path
fzf --preview 'cat {}'                 # preview the highlighted item live
ps aux | fzf | awk '{print $2}' | xargs kill   # fuzzy-pick a process to kill
```
