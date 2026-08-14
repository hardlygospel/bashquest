#!/bin/bash
# BashQuest: The Linux Command Learning Adventure
# Copyright (C) 2026 Tony "Hardlygospel" Hosaroygard <tasmaniamate@gmail.com>
# github.com/hardlygospel/bashquest
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

# ============================================================
# BASHQUEST - The Linux Command Learning Adventure
# ============================================================

RED=$(printf '\033[0;31m');    LRED=$(printf '\033[1;31m')
GREEN=$(printf '\033[0;32m');  LGREEN=$(printf '\033[1;32m')
YELLOW=$(printf '\033[1;33m')
BLUE=$(printf '\033[0;34m');   LBLUE=$(printf '\033[1;34m')
MAGENTA=$(printf '\033[0;35m');LMAGENTA=$(printf '\033[1;35m')
CYAN=$(printf '\033[0;36m');   LCYAN=$(printf '\033[1;36m')
WHITE=$(printf '\033[1;37m')
BOLD=$(printf '\033[1m');      DIM=$(printf '\033[2m')
BG_RED=$(printf '\033[41m');   BG_GREEN=$(printf '\033[42m')
BG_BLUE=$(printf '\033[44m');  BG_MAGENTA=$(printf '\033[45m')
BG_YELLOW=$(printf '\033[43m');BG_CYAN=$(printf '\033[46m')
NC=$(printf '\033[0m')

SAVE_DIR="$HOME/.bashquest"
USERS_FILE="$SAVE_DIR/users.db"
mkdir -p "$SAVE_DIR"

# The whole curriculum in one place. Every "28" that used to be hardcoded
# throughout the file reads from TOTAL_LEVELS now, so growing the game means
# growing this number, the TIERS table below, and the LEVELS table in
# level_select(), nothing else.
TOTAL_LEVELS=61

# num|name|icon|start_level|end_level
TIERS=(
    " 1|Beginner               |🗺 | 1| 4"
    " 2|Intermediate           |⚙ | 5| 8"
    " 3|Pipes & Patterns       |🔗| 9|14"
    " 4|Power Tools            |🔧|15|20"
    " 5|Expert                 |🛡️|21|28"
    " 6|Storage & Filesystems  |💾|29|34"
    " 7|File Editing & Sharing |📁|35|39"
    " 8|Networking             |🌐|40|45"
    " 9|Storage Networking & SAN|🔌|46|49"
    "10|Boot Process & Kernel  |🥾|50|54"
    "11|Media Management       |🎬|55|57"
    "12|Desktop Ricing         |🎨|58|61"
)

# num|name|cmds|icon, filtered by tier range in level_select_tier().
LEVELS=(
    " 1|Navigation & Basics   |ls cd pwd mkdir rmdir        |🗺 "
    " 2|File Operations       |cat touch cp mv rm tar       |📁"
    " 3|Text & Search         |grep find wc sort uniq       |🔍"
    " 4|Permissions & Users   |chmod chown whoami id        |🔐"
    " 5|Process Management    |ps kill jobs bg fg           |⚙ "
    " 6|Text Processing       |awk sed cut tr head tail     |✂ "
    " 7|Networking            |curl wget ping ssh ss        |🌐"
    " 8|Shell Scripting       |vars loops if/else funcs     |📜"
    " 9|Advanced Piping       |tee pipe-chains xargs        |🔗"
    "10|I/O Redirection       |> >> < 2> 2>&1 /dev/null     |📤"
    "11|Regular Expressions   |grep -E . * + ? [] ^ \$       |🔤"
    "12|Advanced grep         |-n -l -c -A -B -C --include  |🔎"
    "13|Advanced sed          |s/// -i ranges d p addresses |📝"
    "14|Advanced awk          |NR NF BEGIN END printf math  |⚡"
    "15|xargs & find -exec    |-exec xargs -I{} -size -mtime|🔧"
    "16|Disk & Storage        |df du lsblk mount findmnt    |💾"
    "17|System Information    |uname lscpu free uptime lsof |🖥️"
    "18|User Management       |useradd usermod passwd groups |👥"
    "19|SSH & Keys            |ssh-keygen ssh-copy-id -i -L |🔑"
    "20|Environment & Shell   |PATH export alias source PS1  |🌍"
    "21|Cron & Scheduling     |crontab syntax at timers     |⏰"
    "22|Logs & Monitoring     |tail -f journalctl logger    |📋"
    "23|Package Management    |apt dnf brew install search  |📦"
    "24|Compression Deep Dive |gzip bzip2 xz zip zcat       |🗜️"
    "25|String Processing     |\${#} \${:} \${%} \${//} printf   |🔡"
    "26|Arrays in Bash        |declare -a [@] loops append  |📚"
    "27|Functions & Errors    |\$? set -e trap return exit   |🛡️"
    "28|Systemd & Services    |systemctl journalctl units   |⚙️"
    "29|Disks & Partitions    |lsblk fdisk -l parted -l blkid|💽"
    "30|Partitioning          |parted mkpart fdisk partprobe|✂️"
    "31|Filesystems           |mkfs.ext4 mkfs.xfs mkswap    |🧱"
    "32|Mounting & fstab      |mount umount /etc/fstab UUID |📌"
    "33|LVM: Volumes & Groups |pvcreate vgcreate lvcreate   |🧩"
    "34|LVM: Resize & Snapshot|lvextend resize2fs lvcreate -s|📐"
    "35|Vim Essentials        |i Esc :wq dd /search :%s     |✏️"
    "36|Permissions & ACLs    |setfacl getfacl umask        |🧷"
    "37|Samba File Sharing    |smb.conf smbpasswd testparm  |🗂️"
    "38|NFS Sharing           |/etc/exports exportfs showmount|📡"
    "39|Sync & Backup (rsync) |rsync -avz --delete -e ssh   |🔁"
    "40|IP Addressing         |ip addr ip link hostname -I  |🧭"
    "41|Routing & Gateways    |ip route traceroute          |🛣️"
    "42|DNS Tools             |dig nslookup /etc/hosts      |🧾"
    "43|Firewalls             |iptables nft ufw              |🧱"
    "44|VLANs & Trunking      |vlan id link add 802.1Q      |🔀"
    "45|Bonding & Troubleshoot|tcpdump mtr nmcli bond        |🩺"
    "46|iSCSI Init. & Targets |iscsiadm targetcli            |🔗"
    "47|NFS/SMB at Scale      |autofs automount              |🗺️"
    "48|Multipath & SAN       |multipath -ll WWN zoning      |🧵"
    "49|Fibre Channel Storage |lsscsi systool multipath -F   |🔬"
    "50|Boot Process Overview |systemctl get-default targets |🥾"
    "51|GRUB2                 |update-grub grub-mkconfig     |🐧"
    "52|Alt. Boot Managers    |bootctl systemd-boot rEFInd   |🔁"
    "53|Kernel Panics/Recovery|rescue single-user initramfs  |💥"
    "54|Building a Kernel     |menuconfig make modules_install|🧬"
    "55|ffmpeg Basics         |transcode extract-audio thumbs|🎞️"
    "56|Media Library Org     |find rename sha256sum         |🗃️"
    "57|Home Media Server     |layout hwaccel transcode      |📺"
    "58|X11/Wayland & WMs     |XDG_SESSION_TYPE loginctl     |🖼️"
    "59|i3 Window Manager     |mod+enter workspaces config   |🪟"
    "60|AwesomeWM & Compositors|rc.lua picom                 |🎨"
    "61|Dotfiles & Theming    |stow git bare-repo dotfiles   |🌈"
)

PLAYER_NAME=""
PLAYER_LEVEL=1
PLAYER_XP=0
PLAYER_LIVES=3
GAME_DIR=""

# Run-wide counters behind the achievement system. Persisted alongside the
# core save so they survive a logout/login, reset to zero for a brand new
# account. These are read, never guessed at, every badge is earned from a
# real tally, not a random roll.
PLAYER_STREAK=0
PLAYER_BEST_STREAK=0
TOTAL_HINTS_USED=0
TOTAL_SKIPS_USED=0
TOTAL_LIVES_LOST=0
RUN_START_TS=0

# Per-level scratch counters. Reset in level_intro, read in level_complete:
# they never persist, they only decide what to say about the level you just
# finished (the streak/achievement talk cares about the whole run instead).
LEVEL_HINTS=0
LEVEL_SKIPS=0
LEVEL_LIVES_LOST=0

# ---- TASMANIA: your guide through this ----
#
# Tasmania is Tony "Hardlygospel" Hosaroygard's in-game handle, a legend of
# a sysadmin who has seen every incident worth seeing and lived to log it.
# Every array below is a bank of lines root_pick() draws from at random, so
# two playthroughs never sound identical. Keep new lines in Tasmania's voice:
# dry, honest, unimpressed by excuses, quietly proud when you earn it.
# (The internal root_* naming stuck around from an early draft; it's plumbing,
# not what the player sees.)

ROOT_CORRECT=(
    "Clean. That's how it's done."
    "Textbook. A lot of seniors would've fat-fingered that."
    "Good. Now do it again in six months without looking it up."
    "That command just saved someone's 3am."
    "Correct, and you didn't even reach for the man page."
    "Nice. I've seen people with ten years on you get that wrong."
    "That's the one. Muscle memory starts here."
    "Perfect. Ship it."
    "Right first time. I'm writing that down."
    "Exactly. The terminal doesn't lie, and neither does that answer."
)

ROOT_WRONG=(
    "Not quite. Even I've typed 'sl' instead of 'ls' more times than I'll admit."
    "Wrong, but closer than most people's first try. Think it through."
    "No, but failure is just a stack trace you haven't read yet."
    "Missed it. Reread the challenge, the answer's hiding in plain sight."
    "Nope. Everyone who's ever run rm -rf on the wrong path started exactly here."
    "Not it. Take a breath, re-read, try again."
    "Incorrect. The terminal doesn't judge. I do, a little."
    "Off target. The hint's right there if your pride can take it."
    "Wrong command, right instinct. Try the next thing that comes to mind."
    "No. But you're debugging now, and that's half the job anyway."
)

ROOT_HINT=(
    "Leaning in, here's the play:"
    "Fine. Between us:"
    "Cheat sheet, coming right up:"
    "No shame in it, everyone greps the docs:"
    "Here, this one's on the house:"
    "Quietly, so nobody else hears:"
)

ROOT_STREAK_3=(
    "3 in a row. You're finding a rhythm."
    "3 straight. Keep that pace and I'll stop watching so closely."
)
ROOT_STREAK_5=(
    "5 clean answers. Somewhere a junior sysadmin just got promoted in spirit."
    "5 in a row, that's not luck anymore, that's competence."
)
ROOT_STREAK_8=(
    "8 straight. I'm almost impressed. Almost."
    "8 in a row. You're on fire, and for once that's a good thing on a server."
)

ROOT_LEVEL_COMPLETE=(
    "Level cleared. On to the next fire."
    "Solid work. The server thanks you, even if it can't say so."
    "That's one more thing you'll never have to Google at 3am."
    "Progress. Real, earned, sysadmin-grade progress."
    "Good. Forget the exact syntax if you must, just remember WHY, that's what sticks."
    "Another tool in the belt. It's getting heavy in a good way."
    "You just got faster than most people who put 'DevOps' on their resume."
    "Onward. The infrastructure never sleeps, and neither do we."
)

ROOT_GAME_OVER=(
    "Out of lives. Every sysadmin has a war story like this one, now it's yours."
    "Down, not out. Come back when you're ready to run it back."
    "That's what staging environments are for. Reset, and try again."
    "Lives spent, lesson learned. That's a fair trade most days."
    "Even root gets locked out sometimes. Log back in when you're ready."
)

# The one-line intro Tasmania gives on top of each level's own lore paragraph.
# Deliberately generic, it's connective tissue between levels, not a
# retelling of what the level already explains.
ROOT_ENCOURAGE=(
    "Pay attention. This is the part people skip, then regret at 3am."
    "Everything from here builds on what you already know. Don't rush it."
    "This one shows up in real incidents more than you'd think."
    "Learn this properly once, and you'll never have to learn it twice."
    "Small commands, big consequences. Take it seriously."
    "I've watched this exact skill save a job interview. Pay attention."
)

# Idle chatter for the main menu, lower stakes than ROOT_ENCOURAGE, just
# Tasmania keeping you company between levels.
ROOT_IDLE=(
    "Take your time. The servers aren't going anywhere. Probably."
    "Level select's over there if you want to revisit something."
    "Command Reference exists so you stop asking me the same thing twice."
    "The leaderboard updates the moment you earn XP. No cheating it."
    "Achievements track the whole run, not just one level. Check them."
    "Whenever you're ready. I've got nowhere else to be."
)

root_pick() {
    # Prints one random element from the arguments given (the caller passes
    # a whole array via "${ARR[@]}"). Kept as a plain function taking args,
    # not name-based array indirection, so it stays bash 3.2-safe.
    local -a lines=("$@")
    local n=${#lines[@]}
    [ "$n" -eq 0 ] && return
    printf '%s' "${lines[$((RANDOM % n))]}"
}

root_says() {
    printf '%b\n' "  ${DIM}${LMAGENTA}Tasmania${NC}${DIM} »${NC} ${MAGENTA}$1${NC}"
}

# A short multi-line Tasmania speech (the origin story, the graduation).
# Reveals a whole line at a time with a brief pause between lines rather
# than type_text's character-by-character animation: on a real terminal a
# five-line char-by-char typewriter effect is a genuinely long wait, and on
# a slow/sandboxed shell (a fork+exec of sleep per character) it can take
# far longer than intended. One sleep per LINE keeps the dramatic pacing
# without either cost. Pass each line as a separate argument.
root_speech() {
    printf '%b\n' "  ${DIM}${LMAGENTA}Tasmania${NC}${DIM} »${NC}"
    local line
    for line in "$@"; do
        printf '%b\n' "  ${MAGENTA}${line}${NC}"
        sleep 0.5
    done
}

# ---- PROGRESSION HELPERS ----

# Which accent colour a level's UI chrome uses, cycling through the palette
# so the run visually changes character as you move through the tiers
# instead of every level looking identical.
level_color() {
    local n=$((${1:-1} % 7))
    case $n in
        0) printf '%s' "$LCYAN" ;;
        1) printf '%s' "$LGREEN" ;;
        2) printf '%s' "$YELLOW" ;;
        3) printf '%s' "$LMAGENTA" ;;
        4) printf '%s' "$LBLUE" ;;
        5) printf '%s' "$LRED" ;;
        *) printf '%s' "$WHITE" ;;
    esac
}

# A filled/empty block progress bar: progress_bar CURRENT TOTAL WIDTH
progress_bar() {
    local current="$1" total="$2" width="${3:-20}" filled empty i bar
    [ "$total" -le 0 ] && total=1
    filled=$(( current * width / total ))
    [ "$filled" -gt "$width" ] && filled=$width
    empty=$((width - filled))
    bar=""
    for ((i = 0; i < filled; i++)); do bar="${bar}█"; done
    for ((i = 0; i < empty; i++)); do bar="${bar}░"; done
    printf '%s' "$bar"
}

# ---- DISPLAY ----

clear_screen() { clear; }

print_banner() {
    clear_screen
    printf '%b\n' "${LCYAN}"
    echo ' ██████╗  █████╗ ███████╗██╗  ██╗ ██████╗ ██╗   ██╗███████╗███████╗████████╗'
    echo ' ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔═══██╗██║   ██║██╔════╝██╔════╝╚══██╔══╝'
    echo ' ██████╔╝███████║███████╗███████║██║   ██║██║   ██║█████╗  ███████╗   ██║   '
    echo ' ██╔══██╗██╔══██║╚════██║██╔══██║██║▄▄ ██║██║   ██║██╔══╝  ╚════██║   ██║   '
    echo ' ██████╔╝██║  ██║███████║██║  ██║╚██████╔╝╚██████╔╝███████╗███████║   ██║   '
    echo ' ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚══▀▀╝  ╚═════╝ ╚══════╝╚══════╝   ╚═╝   '
    printf '%b\n' "${NC}${YELLOW}              ⚡  The Ultimate Linux Command Learning Adventure  ⚡${NC}"
    printf '%b\n' "${DIM}          by Tony \"Hardlygospel\" Hosaroygard  ·  github.com/hardlygospel${NC}"
    printf '%b\n' "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

status_bar() {
    printf '%b\n' "\n${BG_BLUE}${WHITE}  👤 ${PLAYER_NAME}  ${NC}${BG_MAGENTA}${WHITE}  ⭐ Level ${PLAYER_LEVEL}  ${NC}${BG_GREEN}${WHITE}  ✨ XP: ${PLAYER_XP}  ${NC}${BG_RED}${WHITE}  ❤  Lives: ${PLAYER_LIVES}  ${NC}"
    local lvl_shown=$PLAYER_LEVEL
    [ "$lvl_shown" -gt "$TOTAL_LEVELS" ] && lvl_shown=$TOTAL_LEVELS
    printf '%b\n' "${DIM}  ${NC}${LCYAN}$(progress_bar "$lvl_shown" "$TOTAL_LEVELS" 40)${NC} ${DIM}${lvl_shown}/${TOTAL_LEVELS} levels${NC}$([ "$PLAYER_STREAK" -ge 3 ] && printf '%b' "  ${YELLOW}🔥 streak ${PLAYER_STREAK}${NC}")"
    printf '%b\n' "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

press_enter() {
    printf '%b\n' "\n${DIM}Press ${YELLOW}[ENTER]${NC}${DIM} to continue...${NC}"
    read -r
}

# Every menu loop below calls this right after its `read`. A closed stdin
# (Ctrl+D, or a pipe that ran out) makes `read` fail without blocking, a
# menu function that just recurses into itself on any non-matching input
# would then spin instantly and forever, since there's no more input coming
# to ever match. Exit cleanly instead of burning CPU in a stack that never
# unwinds.
require_input() {
    if [ "$1" -ne 0 ]; then
        printf '%b\n' "\n${YELLOW}Input closed. See you next time!${NC}"
        exit 0
    fi
}

type_text() {
    local text="$1" delay="${2:-0.025}" i
    for ((i=0; i<${#text}; i++)); do
        printf "%s" "${text:$i:1}"
        sleep "$delay"
    done
    printf "\n"
}

# A short fake boot log, once per launch, before the title screen. Purely
# cosmetic, no state depends on it, but it's the first thing a player
# sees, and first impressions are worth the two seconds it costs.
boot_sequence() {
    clear_screen
    printf '%b' "${DIM}${GREEN}"
    local lines=(
        "[  OK  ] Mounting /dev/quest on / ..."
        "[  OK  ] Starting terminal subsystem ..."
        "[  OK  ] Loading personality module: tasmania.ko ..."
        "[  OK  ] Checking for legendary sysadmins in /etc/passwd ..."
        "[ INFO ] Found 1: Tony \"Hardlygospel\" Hosaroygard."
    )
    local l
    for l in "${lines[@]}"; do
        printf '%b\n' "$l"
        sleep 0.14
    done
    printf '%b\n' "${NC}"
    sleep 0.2
    printf "  %s" "${LMAGENTA}"
    type_text "Tasmania is watching the login prompt..." 0.02
    printf "%s" "${NC}"
    sleep 0.4
}

show_xp_gain() {
    local amount="$1"
    PLAYER_XP=$((PLAYER_XP + amount))
    printf '%b\n' "\n${BG_GREEN}${WHITE}  ✨ +${amount} XP!  Total: ${PLAYER_XP}  ${NC}"
    save_progress
}

wrong_answer() {
    PLAYER_LIVES=$((PLAYER_LIVES - 1))
    TOTAL_LIVES_LOST=$((TOTAL_LIVES_LOST + 1))
    LEVEL_LIVES_LOST=$((LEVEL_LIVES_LOST + 1))
    PLAYER_STREAK=0
    save_progress
    if [ "$PLAYER_LIVES" -le 0 ]; then
        game_over
        return 1
    fi
    printf '%b\n' "\n${LRED}  ✗  Incorrect!${NC}  Lives remaining: ${YELLOW}${PLAYER_LIVES} ❤${NC}"
    root_says "$(root_pick "${ROOT_WRONG[@]}")"
    return 0
}

game_over() {
    clear_screen
    printf '%b\n' "${LRED}"
    echo '  ██████╗  █████╗ ███╗   ███╗███████╗     ██████╗ ██╗   ██╗███████╗██████╗ '
    echo ' ██╔════╝ ██╔══██╗████╗ ████║██╔════╝    ██╔═══██╗██║   ██║██╔════╝██╔══██╗'
    echo ' ██║  ███╗███████║██╔████╔██║█████╗      ██║   ██║██║   ██║█████╗  ██████╔╝'
    echo ' ██║   ██║██╔══██║██║╚██╔╝██║██╔══╝      ██║   ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗'
    echo ' ╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗    ╚██████╔╝ ╚████╔╝ ███████╗██║  ██║'
    echo '  ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝     ╚═════╝   ╚═══╝  ╚══════╝╚═╝  ╚═╝'
    printf '%b\n' "${NC}"
    printf '%b\n' "${YELLOW}  You ran out of lives, ${BOLD}${PLAYER_NAME}${NC}${YELLOW}. Better luck next time!${NC}"
    printf '%b\n' "${CYAN}  Final XP: ${PLAYER_XP}  |  Level reached: ${PLAYER_LEVEL}${NC}"
    root_says "$(root_pick "${ROOT_GAME_OVER[@]}")"
    PLAYER_LIVES=3
    PLAYER_STREAK=0
    save_progress
    press_enter
    main_menu
}

# ---- SAVE / LOAD ----

save_progress() {
    printf 'PLAYER_LEVEL=%s\nPLAYER_XP=%s\nPLAYER_LIVES=%s\nPLAYER_BEST_STREAK=%s\nTOTAL_HINTS_USED=%s\nTOTAL_SKIPS_USED=%s\nTOTAL_LIVES_LOST=%s\nRUN_START_TS=%s\n' \
        "$PLAYER_LEVEL" "$PLAYER_XP" "$PLAYER_LIVES" "$PLAYER_BEST_STREAK" \
        "$TOTAL_HINTS_USED" "$TOTAL_SKIPS_USED" "$TOTAL_LIVES_LOST" "$RUN_START_TS" \
        > "$SAVE_DIR/${PLAYER_NAME}.save"
}

load_progress() {
    local f="$SAVE_DIR/${PLAYER_NAME}.save"
    [ -f "$f" ] && source "$f"
}

# ---- AUTH ----

hash_pw() { printf '%s' "$1" | md5 2>/dev/null || printf '%s' "$1" | md5sum | cut -d' ' -f1; }

register_user() {
    clear_screen; print_banner
    printf '%b\n' "\n${LCYAN}╔═══════════════════════════════╗"
    printf '%b\n' "║     CREATE YOUR ACCOUNT       ║"
    printf '%b\n' "╚═══════════════════════════════╝${NC}\n"
    local username password confirm hashed
    while true; do
        printf "${YELLOW}Choose a username: ${NC}"; read -r username; require_input $?
        username="${username//[[:space:]]/}"
        [ -z "$username" ] && printf '%b\n' "${RED}Username cannot be empty.${NC}" && continue
        grep -q "^${username}:" "$USERS_FILE" 2>/dev/null && printf '%b\n' "${RED}Username taken.${NC}" && continue
        break
    done
    while true; do
        printf "${YELLOW}Choose a password: ${NC}"; read -rs password; require_input $?; echo
        [ ${#password} -lt 4 ] && printf '%b\n' "${RED}Minimum 4 characters.${NC}" && continue
        printf "${YELLOW}Confirm password: ${NC}";  read -rs confirm; require_input $?; echo
        [ "$password" != "$confirm" ] && printf '%b\n' "${RED}Passwords do not match.${NC}" && continue
        break
    done
    hashed=$(hash_pw "$password")
    echo "${username}:${hashed}" >> "$USERS_FILE"
    PLAYER_NAME="$username"; PLAYER_LEVEL=1; PLAYER_XP=0; PLAYER_LIVES=3
    PLAYER_STREAK=0; PLAYER_BEST_STREAK=0
    TOTAL_HINTS_USED=0; TOTAL_SKIPS_USED=0; TOTAL_LIVES_LOST=0; RUN_START_TS=0
    save_progress
    printf '%b\n' "\n${LGREEN}  ✓ Account created! Welcome, ${BOLD}${username}${NC}${LGREEN}!${NC}\n"
    sleep 0.5
    root_speech \
        "Name's Tony Hosaroygard. Round here they call me Tasmania." \
        "Twenty-five years of IT, every role you can name. I've seen every" \
        "3am page, every rm -rf typo, every 'it works on my machine.'" \
        "You're new here, and that's fine, everyone starts at uid 1000." \
        "By the time we're done you won't just know commands, you'll be able to" \
        "run storage, networking, a SAN, a boot process gone wrong, and still" \
        "have the taste to rice your own desktop after hours. Let's begin, ${username}." \
        "(github.com/hardlygospel, if you ever want to see what I actually build.)"
    press_enter
    main_menu
}

login_user() {
    clear_screen; print_banner
    printf '%b\n' "\n${LCYAN}╔═══════════════════════════════╗"
    printf '%b\n' "║       TERMINAL LOGIN          ║"
    printf '%b\n' "╚═══════════════════════════════╝${NC}\n"
    printf '%b\n' "${GREEN}BashQuest OS v2.4.1 LTS (GNU/Linux 5.15.0-amd64)${NC}"
    printf '%b\n' "${DIM}$(date)${NC}\n"
    local attempts=0 username password hashed
    while [ $attempts -lt 3 ]; do
        printf "${WHITE}login: ${NC}";    read -r username; require_input $?
        printf "${WHITE}Password: ${NC}"; read -rs password; require_input $?; echo
        hashed=$(hash_pw "$password")
        if grep -q "^${username}:${hashed}$" "$USERS_FILE" 2>/dev/null; then
            PLAYER_NAME="$username"; load_progress
            printf '%b\n' "\n${LGREEN}  ✓ Authentication successful.${NC}"
            sleep 0.6; main_menu; return
        fi
        attempts=$((attempts + 1))
        printf '%b\n' "${RED}  Login incorrect.${NC}\n"
    done
    printf '%b\n' "${LRED}  Too many failed attempts.${NC}"; sleep 2; startup_screen
}

# ---- MENUS ----

main_menu() {
    clear_screen; print_banner; status_bar
    printf '%b\n' "\n${LCYAN}╔══════════════════════════════════════╗"
    printf '%b\n' "║             MAIN MENU                ║"
    printf '%b\n' "╠══════════════════════════════════════╣"
    printf '%b\n' "║  ${LGREEN}[1]${LCYAN} Continue Adventure              ║"
    printf '%b\n' "║  ${YELLOW}[2]${LCYAN} Level Select                    ║"
    printf '%b\n' "║  ${BLUE}[3]${LCYAN} Command Reference               ║"
    printf '%b\n' "║  ${MAGENTA}[4]${LCYAN} Leaderboard                    ║"
    printf '%b\n' "║  ${LMAGENTA}[5]${LCYAN} Achievements                    ║"
    printf '%b\n' "║  ${RED}[6]${LCYAN} Logout                         ║"
    printf '%b\n' "╚══════════════════════════════════════╝${NC}\n"
    root_says "$(root_pick "${ROOT_IDLE[@]}")"
    printf "\n${YELLOW}Choice: ${NC}"; read -r choice; require_input $?
    case $choice in
        1) run_current_level ;;
        2) level_select ;;
        3) command_reference ;;
        4) leaderboard ;;
        5) achievements_panel ;;
        6) startup_screen ;;
        *) main_menu ;;
    esac
}

# Step 1: pick a tier. With 61 levels a flat list stopped being useful, so
# level select is now two menus deep: tier, then level within that tier.
# Every tier is always browsable (you can look ahead at what's coming), the
# individual levels inside still show [LOCKED] same as before.
level_select() {
    clear_screen; print_banner; status_bar
    printf '%b\n' "\n${LCYAN}╔══════════════════════════════════════════════════════════════════════════╗"
    printf '%b\n' "║$(printf '%*s%s%*s' 30 '' "JUMP TO TOPIC" 31 '')║"
    printf '%b\n' "╠══════════════════════════════════════════════════════════════════════════╣${NC}"
    local entry num name icon start end n
    for entry in "${TIERS[@]}"; do
        IFS='|' read -r num name icon start end <<< "$entry"
        n=$(echo "$num" | tr -d ' ')
        if [ "$PLAYER_LEVEL" -ge "$start" ]; then
            printf '%b\n' "${LCYAN}║ ${LGREEN}[${num}]${NC} ${icon} ${WHITE}${BOLD}${name}${NC} ${DIM}(levels ${start}-${end})${NC}"
        else
            printf '%b\n' "${LCYAN}║ ${DIM}[${num}] ${icon} ${name} (levels ${start}-${end}) [LOCKED]${NC}"
        fi
    done
    printf '%b\n' "${LCYAN}╚══════════════════════════════════════════════════════════════════════════╝${NC}"
    printf "\n${YELLOW}Enter tier (1-${#TIERS[@]}) or 0 to go back: ${NC}"; read -r choice; require_input $?
    [ "$choice" = "0" ] && main_menu && return
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#TIERS[@]}" ]; then
        level_select_tier "$choice"
    else
        printf '%b\n' "${RED}  Invalid tier!${NC}"; sleep 1; level_select
    fi
}

# Step 2: pick a level within the chosen tier.
level_select_tier() {
    local tier_num="$1"
    local entry num name icon start end tier_name tier_icon
    IFS='|' read -r num tier_name tier_icon start end <<< "${TIERS[$((tier_num - 1))]}"

    clear_screen; print_banner; status_bar
    printf '%b\n' "\n${LCYAN}╔══════════════════════════════════════════════════════════════════════════╗"
    printf '%b\n' "║ ${tier_icon} ${WHITE}${BOLD}${tier_name}${NC}"
    printf '%b\n' "${LCYAN}╠══════════════════════════════════════════════════════════════════════════╣${NC}"
    local lvl_num lvl_name lvl_cmds lvl_icon n
    for entry in "${LEVELS[@]:$((start - 1)):$((end - start + 1))}"; do
        IFS='|' read -r lvl_num lvl_name lvl_cmds lvl_icon <<< "$entry"
        n=$(echo "$lvl_num" | tr -d ' ')
        if [ "$n" -le "$PLAYER_LEVEL" ]; then
            printf '%b\n' "${LCYAN}║ ${LGREEN}[${lvl_num}]${NC} ${lvl_icon} ${WHITE}${BOLD}${lvl_name}${NC} ${DIM}${lvl_cmds}${NC}"
        else
            printf '%b\n' "${LCYAN}║ ${DIM}[${lvl_num}] ${lvl_icon} ${lvl_name} ${lvl_cmds} [LOCKED]${NC}"
        fi
    done
    printf '%b\n' "${LCYAN}╚══════════════════════════════════════════════════════════════════════════╝${NC}"
    printf "\n${YELLOW}Enter level (${start}-${end}) or 0 to go back: ${NC}"; read -r choice; require_input $?
    [ "$choice" = "0" ] && level_select && return
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge "$start" ] && [ "$choice" -le "$end" ] && [ "$choice" -le "$PLAYER_LEVEL" ]; then
        dispatch_level "$choice"
    else
        printf '%b\n' "${RED}  Locked or invalid!${NC}"; sleep 1; level_select_tier "$tier_num"
    fi
}

command_reference() {
    clear_screen; print_banner
    printf '%b\n' "\n${LCYAN}╔══════════════════════════════════════════════════════════════════╗"
    printf '%b\n' "║                      COMMAND REFERENCE                          ║"
    printf '%b\n' "╚══════════════════════════════════════════════════════════════════╝${NC}\n"
    printf '%b\n' "  ${LGREEN}NAVIGATION ${NC}  ls  cd  pwd  mkdir  rmdir  tree"
    printf '%b\n' "  ${YELLOW}FILES      ${NC}  cat  touch  cp  mv  rm  ln  tar  gzip  zip  less"
    printf '%b\n' "  ${CYAN}SEARCH     ${NC}  grep  grep -E  grep -v  grep -r  find  locate"
    printf '%b\n' "  ${MAGENTA}PERMISSIONS${NC}  chmod  chown  whoami  id  su  sudo"
    printf '%b\n' "  ${BLUE}PROCESSES  ${NC}  ps  kill  jobs  bg  fg  nohup  lsof"
    printf '%b\n' "  ${LRED}TEXT PROC  ${NC}  awk  sed  cut  tr  sort  uniq  head  tail  tee"
    printf '%b\n' "  ${LCYAN}NETWORKING ${NC}  curl  wget  ping  ssh  scp  ssh-keygen  ss"
    printf '%b\n' "  ${WHITE}SCRIPTING  ${NC}  echo  read  if  for  while  case  function  trap"
    printf '%b\n' "  ${LMAGENTA}DISK/SYS   ${NC}  df  du  lsblk  mount  uname  uptime  free  lscpu"
    printf '%b\n' "  ${YELLOW}USERS/SVCS ${NC}  useradd  usermod  passwd  systemctl  journalctl"
    printf '%b\n' "  ${LGREEN}REDIRECT   ${NC}  >  >>  <  2>  2>&1  /dev/null  |  tee  xargs"
    printf '%b\n' "  ${CYAN}CRON       ${NC}  crontab  at  * * * * *  (min hr day mon wday)"
    printf '%b\n' "  ${MAGENTA}STRINGS    ${NC}  \${#v}  \${v:0:n}  \${v%p}  \${v//f/r}  printf"
    printf '%b\n' "  ${BLUE}PACKAGES   ${NC}  apt  dnf  yum  brew  pacman  pip  snap"
    printf '%b\n' "  ${LCYAN}STORAGE/LVM${NC}  fdisk  parted  mkfs  pvcreate  vgcreate  lvcreate"
    printf '%b\n' "  ${YELLOW}SHARING    ${NC}  vim  setfacl  smbclient  exportfs  showmount  rsync"
    printf '%b\n' "  ${CYAN}NETWORK 2  ${NC}  ip addr  ip route  dig  iptables  nft  ufw  tcpdump"
    printf '%b\n' "  ${MAGENTA}SAN/ISCSI  ${NC}  iscsiadm  targetcli  multipath  lsscsi  autofs"
    printf '%b\n' "  ${BLUE}BOOT/KERNEL${NC}  update-grub  bootctl  journalctl -b  dmesg  make"
    printf '%b\n' "  ${LRED}MEDIA      ${NC}  ffmpeg  ffprobe  sha256sum  iotop  find -size"
    printf '%b\n' "  ${LGREEN}RICING     ${NC}  i3-msg  bindsym  picom  stow  gsettings  feh"
    printf '%b\n' "\n${DIM}  In-game: type '${YELLOW}hint${NC}${DIM}' for a clue, '${YELLOW}skip${NC}${DIM}' to skip (costs 1 life).${NC}"
    printf '%b\n' "${DIM}  Platform notes: macOS uses md5/vm_stat/sysctl/brew vs Linux md5sum/free/lscpu/apt.${NC}"
    press_enter; main_menu
}

leaderboard() {
    clear_screen; print_banner
    printf '%b\n' "\n${YELLOW}╔══════════════════════════════════════╗"
    printf '%b\n' "║            LEADERBOARD               ║"
    printf '%b\n' "╚══════════════════════════════════════╝${NC}\n"
    printf '%b\n' "${BOLD}${WHITE}  #    Player            Level   XP${NC}"
    printf '%b\n' "${DIM}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    local rank=1
    for save in "$SAVE_DIR"/*.save; do
        [ -f "$save" ] || continue
        local name xp lvl
        name=$(basename "$save" .save)
        xp=$(grep "^PLAYER_XP=" "$save" | cut -d= -f2)
        lvl=$(grep "^PLAYER_LEVEL=" "$save" | cut -d= -f2)
        echo "$xp $lvl $name"
    done | sort -rn | head -10 | while read -r xp lvl name; do
        local medal="  "
        [ $rank -eq 1 ] && medal="${YELLOW}🥇${NC}"
        [ $rank -eq 2 ] && medal="${CYAN}🥈${NC}"
        [ $rank -eq 3 ] && medal="${MAGENTA}🥉${NC}"
        printf "  ${medal}%-3s  %-16s  %-6s  %s\n" "#$rank" "$name" "$lvl" "$xp"
        rank=$((rank + 1))
    done
    press_enter; main_menu
}

# Badges earned from real, tallied counters, never a dice roll. Every badge
# here is either still true right now (a run-wide streak, like "never used
# a hint") or a one-time milestone already crossed (a best streak, or
# graduating). Shown live so a player can see exactly what they'd lose by
# reaching for a hint on the next challenge.
achievements_panel() {
    clear_screen; print_banner
    printf '%b\n' "\n${LMAGENTA}╔══════════════════════════════════════════════════════╗"
    printf '%b\n' "║                    ACHIEVEMENTS                      ║"
    printf '%b\n' "╚══════════════════════════════════════════════════════╝${NC}\n"

    local mark
    mark() { [ "$1" -eq 1 ] && printf '%b' "${LGREEN}✓${NC}" || printf '%b' "${DIM}·${NC}"; }

    printf " %s  %-16s %s\n" "$(mark $([ "$TOTAL_HINTS_USED" -eq 0 ] && echo 1 || echo 0))" \
        "Purist" "${DIM}Never used a hint (${TOTAL_HINTS_USED} used so far)${NC}"
    printf " %s  %-16s %s\n" "$(mark $([ "$TOTAL_SKIPS_USED" -eq 0 ] && echo 1 || echo 0))" \
        "No Shortcuts" "${DIM}Never skipped a challenge (${TOTAL_SKIPS_USED} used so far)${NC}"
    printf " %s  %-16s %s\n" "$(mark $([ "$TOTAL_LIVES_LOST" -eq 0 ] && echo 1 || echo 0))" \
        "Untouchable" "${DIM}Never lost a life (${TOTAL_LIVES_LOST} lost so far)${NC}"
    printf " %s  %-16s %s\n" "$(mark $([ "$PLAYER_BEST_STREAK" -ge 5 ] && echo 1 || echo 0))" \
        "On a Roll" "${DIM}5-answer streak (best: ${PLAYER_BEST_STREAK})${NC}"
    printf " %s  %-16s %s\n" "$(mark $([ "$PLAYER_BEST_STREAK" -ge 10 ] && echo 1 || echo 0))" \
        "Unstoppable" "${DIM}10-answer streak (best: ${PLAYER_BEST_STREAK})${NC}"
    printf " %s  %-16s %s\n" "$(mark $([ "$PLAYER_LEVEL" -gt "$TOTAL_LEVELS" ] && echo 1 || echo 0))" \
        "Graduate" "${DIM}Completed all ${TOTAL_LEVELS} levels${NC}"

    printf '\n'
    root_says "Purist and No Shortcuts are only true until the moment you reach for either. Own that."
    press_enter; main_menu
}

startup_screen() {
    PLAYER_NAME=""; PLAYER_LEVEL=1; PLAYER_XP=0; PLAYER_LIVES=3
    clear_screen; print_banner
    printf '%b\n' "\n${LCYAN}╔══════════════════════════════════════╗"
    printf '%b\n' "║      WELCOME TO BASHQUEST  🐧         ║"
    printf '%b\n' "╠══════════════════════════════════════╣"
    printf '%b\n' "║  ${LGREEN}[1]${LCYAN} Login                          ║"
    printf '%b\n' "║  ${YELLOW}[2]${LCYAN} Create Account                 ║"
    printf '%b\n' "║  ${RED}[3]${LCYAN} Quit                           ║"
    printf '%b\n' "╚══════════════════════════════════════╝${NC}\n"
    printf "${YELLOW}Choice: ${NC}"; read -r choice; require_input $?
    case $choice in
        1) login_user ;;
        2) register_user ;;
        3) printf '%b\n' "\n${CYAN}Thanks for playing BashQuest! Keep hacking! 🐧${NC}\n"; exit 0 ;;
        *) startup_screen ;;
    esac
}

# ---- GAME ENGINE ----

setup_game_env() {
    GAME_DIR=$(mktemp -d /tmp/bashquest_XXXXXX)
    mkdir -p "$GAME_DIR"/{home,etc,var/log,usr/bin,tmp,projects}
    echo "root:x:0:0:root:/root:/bin/bash"              > "$GAME_DIR/etc/passwd"
    echo "daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin" >> "$GAME_DIR/etc/passwd"
    echo "bashuser:x:1000:1000:BashQuest User:/home/bashuser:/bin/bash" >> "$GAME_DIR/etc/passwd"
    echo "Welcome to BashQuest, your Linux adventure begins!"  > "$GAME_DIR/home/welcome.txt"
    echo "This is a secret file. You found it!"               > "$GAME_DIR/home/secret.txt"
    echo "ERROR: Disk partition /dev/sda1 is full"            > "$GAME_DIR/var/log/error.log"
    echo "INFO: System started successfully"                  >> "$GAME_DIR/var/log/error.log"
    echo "WARNING: Memory usage above 80%"                    >> "$GAME_DIR/var/log/error.log"
    echo "ERROR: Failed to connect to database"              >> "$GAME_DIR/var/log/error.log"
    for name in Alice Bob Charlie Dave Eve; do
        echo "$name: $((RANDOM % 100 + 1))"
    done > "$GAME_DIR/home/scores.txt"
    chmod 640 "$GAME_DIR/home/secret.txt"
    cd "$GAME_DIR" 2>/dev/null || true
}

cleanup_game_env() {
    [ -n "$GAME_DIR" ] && rm -rf "$GAME_DIR" 2>/dev/null
    GAME_DIR=""
    cd "$HOME" 2>/dev/null || cd / 2>/dev/null || true
}

run_challenge() {
    local title="$1" desc="$2" hint="$3" check="$4" xp="$5"
    local user_input
    while true; do
        printf '%b\n' "\n${LCYAN}┌──────────────────────────────────────────────────┐"
        printf "│  ${YELLOW}%-48s${LCYAN}│\n" "CHALLENGE: $title"
        printf '%b\n' "└──────────────────────────────────────────────────┘${NC}"
        printf '%b\n' "\n${WHITE}${desc}${NC}\n"
        printf "${LGREEN}bashquest${NC}${CYAN}@terminal${NC}:${YELLOW}~\$${NC} "
        read -r user_input; require_input $?
        case "$user_input" in
            hint)
                TOTAL_HINTS_USED=$((TOTAL_HINTS_USED + 1))
                LEVEL_HINTS=$((LEVEL_HINTS + 1))
                root_says "$(root_pick "${ROOT_HINT[@]}")"
                printf '%b\n' "  ${YELLOW}💡 ${hint}${NC}"
                continue ;;
            skip)
                printf '%b\n' "\n${DIM}  Skipped. -1 life.${NC}"
                TOTAL_SKIPS_USED=$((TOTAL_SKIPS_USED + 1))
                LEVEL_SKIPS=$((LEVEL_SKIPS + 1))
                PLAYER_LIVES=$((PLAYER_LIVES - 1))
                PLAYER_STREAK=0
                save_progress
                [ "$PLAYER_LIVES" -le 0 ] && game_over
                return ;;
        esac
        if eval "$check" 2>/dev/null; then
            PLAYER_STREAK=$((PLAYER_STREAK + 1))
            [ "$PLAYER_STREAK" -gt "$PLAYER_BEST_STREAK" ] && PLAYER_BEST_STREAK=$PLAYER_STREAK
            printf '%b\n' "\n${LGREEN}  ✓  Correct!${NC}"
            root_says "$(root_pick "${ROOT_CORRECT[@]}")"
            case "$PLAYER_STREAK" in
                3) printf '%b\n' "  ${YELLOW}🔥 $(root_pick "${ROOT_STREAK_3[@]}")${NC}" ;;
                5) printf '%b\n' "  ${YELLOW}🔥 $(root_pick "${ROOT_STREAK_5[@]}")${NC}" ;;
                8) printf '%b\n' "  ${YELLOW}🔥 $(root_pick "${ROOT_STREAK_8[@]}")${NC}" ;;
            esac
            show_xp_gain "$xp"
            sleep 0.5
            return
        else
            wrong_answer || return
            printf '%b\n' "${DIM}  Type '${YELLOW}hint${NC}${DIM}' for help or '${YELLOW}skip${NC}${DIM}' to skip.${NC}"
        fi
    done
}

level_intro() {
    local num="$1" title="$2" desc="$3" badge="$4"
    local accent
    accent=$(level_color "$num")
    [ "$RUN_START_TS" -eq 0 ] && RUN_START_TS=$(date +%s 2>/dev/null || echo 0)
    LEVEL_HINTS=0; LEVEL_SKIPS=0; LEVEL_LIVES_LOST=0
    clear_screen; print_banner; status_bar
    printf '%b\n' "\n${accent}  LEVEL ${num}: ${BOLD}${title}${NC}${accent}  ${NC}\n"
    printf '%b\n' "  ${badge}\n"
    printf "  %s" "${CYAN}"; type_text "${desc}" 0.018; printf "%s\n" "${NC}"
    printf '\n'; root_says "$(root_pick "${ROOT_ENCOURAGE[@]}")"
    press_enter
}

level_complete() {
    local num="$1"
    clear_screen
    printf '%b\n' "${LGREEN}"
    echo ' ██╗     ███████╗██╗   ██╗███████╗██╗         ██████╗  ██████╗ ███╗   ██╗███████╗'
    echo ' ██║     ██╔════╝██║   ██║██╔════╝██║         ██╔══██╗██╔═══██╗████╗  ██║██╔════╝'
    echo ' ██║     █████╗  ██║   ██║█████╗  ██║         ██║  ██║██║   ██║██╔██╗ ██║█████╗  '
    echo ' ██║     ██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║         ██║  ██║██║   ██║██║╚██╗██║██╔══╝  '
    echo ' ███████╗███████╗ ╚████╔╝ ███████╗███████╗    ██████╔╝╚██████╔╝██║ ╚████║███████╗'
    echo ' ╚══════╝╚══════╝  ╚═══╝  ╚══════╝╚══════╝    ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝'
    printf '%b\n' "${NC}"
    printf '%b\n' "  ${YELLOW}⭐ Level ${num} Complete!${NC}   ${CYAN}XP: ${PLAYER_XP}${NC}"
    if [ "$LEVEL_HINTS" -eq 0 ] && [ "$LEVEL_SKIPS" -eq 0 ] && [ "$LEVEL_LIVES_LOST" -eq 0 ]; then
        printf '%b\n' "  ${LGREEN}✨ Flawless, no hints, no skips, no lives lost.${NC}"
    fi
    root_says "$(root_pick "${ROOT_LEVEL_COMPLETE[@]}")"
    [ "$PLAYER_LEVEL" -le "$num" ] && PLAYER_LEVEL=$((num + 1)) && save_progress
    sleep 1; press_enter; main_menu
}

# A bigger milestone than an ordinary level_complete: BashQuest's 28 levels
# split into four tiers (see levels/README.md), and finishing one is worth
# marking properly instead of it looking identical to every other level.
# This is also what replaces the old bug where level 8 alone showed a full
# "GAME COMPLETE" banner, a leftover from when the game only had 8 levels.
tier_complete() {
    local num="$1" tier_name="$2" tier_desc="$3" next_tier="$4"
    local accent
    accent=$(level_color "$num")
    clear_screen
    printf '%b\n' "${accent}"
    echo '╔═══════════════════════════════════════════════════════════════════════╗'
    printf '║  %b%-67s%b  ║\n' "${WHITE}${BOLD}" "🏁  TIER COMPLETE: ${tier_name}" "${NC}${accent}"
    echo '╚═══════════════════════════════════════════════════════════════════════╝'
    printf '%b\n' "${NC}"
    printf '%b\n' "  ${WHITE}${tier_desc}${NC}\n"
    printf '%b\n' "  ${YELLOW}⭐ Level ${num} Complete!${NC}   ${CYAN}XP: ${PLAYER_XP}${NC}   ${DIM}Best streak so far: ${PLAYER_BEST_STREAK}${NC}"
    root_says "$(root_pick "${ROOT_LEVEL_COMPLETE[@]}")"
    printf '\n'
    printf '%b\n' "  ${DIM}Next up:${NC} ${accent}${next_tier}${NC}"
    [ "$PLAYER_LEVEL" -le "$num" ] && PLAYER_LEVEL=$((num + 1)) && save_progress
    sleep 1; press_enter; main_menu
}

# ---- CHECK HELPERS ----
# Each returns 0 (true) if input matches, 1 (false) otherwise

chk() { echo "$user_input" | grep -qE "$1"; }
exact() { [ "$user_input" = "$1" ]; }

# ---- LEVEL 1: NAVIGATION ----

run_level_1() {
    level_intro 1 "Navigation & Basics" \
        "Welcome, recruit! Every Linux master starts here. You'll learn to move around the filesystem, see what's in directories, and create/remove folders. These are the commands you will use EVERY single day." \
        "🗺   Commands: ls  |  pwd  |  cd  |  mkdir  |  rmdir"
    setup_game_env

    run_challenge "List the Files" \
        "You've just SSH'd into a server. List the files in the current directory to see what's there.\n\n  Think: what command do you use to SEE what's in a folder?" \
        "The command is 'ls', two letters, List fileS" \
        'chk "^ls( -[a-zA-Z]+)*$"' 10

    run_challenge "Where Am I?" \
        "Before navigating anywhere, you need to know WHERE you are right now.\nPrint the full path of your current working directory." \
        "pwd: Print Working Directory" \
        'exact "pwd"' 10

    run_challenge "Long Listing" \
        "List files with DETAILED info: permissions, owner, size, and date.\n\n  The ls command has a flag for this." \
        "ls -l: long format. Also try ls -lh for human-readable sizes" \
        'chk "^ls -[a-zA-Z]*l[a-zA-Z]*$|^ls -l"' 15

    run_challenge "Show Hidden Files" \
        "Linux hides files that start with a dot (.). List ALL files including hidden ones.\n\n  You need a flag after ls to show ALL files." \
        "ls -a: show ALL, including hidden .dotfiles  (ls -la for both)" \
        'chk "^ls -[a-zA-Z]*a[a-zA-Z]*"' 15

    run_challenge "Make a Directory" \
        "Create a new directory called ${YELLOW}projects${NC} in the current location.\n\n  Build your workspace!" \
        "mkdir projects: MaKe DIRectory" \
        'chk "^mkdir [a-zA-Z0-9_-]+"' 20

    run_challenge "Navigate Into It" \
        "Change into the ${YELLOW}projects${NC} directory you just created." \
        "cd projects: Change Directory" \
        'chk "^cd [a-zA-Z0-9_.~/-]+"' 15

    run_challenge "Go Home" \
        "Navigate back to your home directory. Every user has one.\n\n  There are multiple correct ways to do this!" \
        "cd ~  OR just  cd  (no argument), both go home" \
        'chk "^cd( ~|$)"' 15

    run_challenge "Remove a Directory" \
        "Remove the empty directory called ${YELLOW}tmp${NC}.\n\n  Note: only works on EMPTY directories." \
        "rmdir tmp: ReMove DIRectory (empty dirs only). Use rm -r for non-empty" \
        'chk "^(rmdir|rm -r) [a-zA-Z0-9_-]+"' 20

    cleanup_game_env
    level_complete 1
}

# ---- LEVEL 2: FILE OPERATIONS ----

run_level_2() {
    level_intro 2 "File Operations" \
        "You can navigate, now work WITH files. Creating, reading, copying, moving, deleting. These are the daily bread of any Linux user. Master these and you'll be flying." \
        "📁   Commands: cat  |  touch  |  cp  |  mv  |  rm  |  tar"
    setup_game_env

    run_challenge "Read a File" \
        "Read the contents of ${YELLOW}home/welcome.txt${NC} and print it to the terminal." \
        "cat home/welcome.txt: conCATenate files to stdout" \
        'chk "^cat .+"' 10

    run_challenge "View First Lines" \
        "The log file ${YELLOW}var/log/error.log${NC} could be huge. Show just the first 2 lines." \
        "head -n 2 var/log/error.log: shows first N lines (default 10)" \
        'chk "^head .+"' 15

    run_challenge "View Last Lines" \
        "Show the LAST 2 lines of ${YELLOW}var/log/error.log${NC}.\n\n  Like head but from the bottom." \
        "tail -n 2 var/log/error.log: shows last N lines. tail -f follows live logs" \
        'chk "^tail .+"' 15

    run_challenge "Create an Empty File" \
        "Create a new empty file called ${YELLOW}notes.txt${NC}.\n\n  You're not writing to it yet, just creating it." \
        "touch notes.txt: creates empty file or updates timestamps" \
        'chk "^touch .+"' 15

    run_challenge "Copy a File" \
        "Back up ${YELLOW}home/welcome.txt${NC} as ${YELLOW}home/welcome.bak${NC}." \
        "cp home/welcome.txt home/welcome.bak: CoPy source destination" \
        'chk "^cp .+ .+"' 20

    run_challenge "Move / Rename" \
        "Rename ${YELLOW}notes.txt${NC} to ${YELLOW}mynotes.txt${NC}.\n\n  On Linux, rename and move are the SAME command!" \
        "mv notes.txt mynotes.txt: MoVe (also used for renaming)" \
        'chk "^mv .+ .+"' 20

    run_challenge "Delete a File" \
        "Delete ${YELLOW}home/welcome.bak${NC}, we no longer need it.\n\n  ${LRED}Warning: rm is permanent. No recycle bin!${NC}" \
        "rm home/welcome.bak: ReMove (permanent, use with care!)" \
        'chk "^rm( -[a-zA-Z]*)? .+"' 20

    run_challenge "Remove a Directory Recursively" \
        "Delete the ${YELLOW}tmp${NC} directory AND everything inside it." \
        "rm -r tmp: -r means recursive (also rm -rf to skip confirmation)" \
        'chk "^rm -r[f]? .+|^rm -rf .+"' 20

    run_challenge "Create a tar Archive" \
        "Archive the ${YELLOW}home${NC} directory into a compressed file called ${YELLOW}home.tar.gz${NC}.\n\n  tar is the standard way to bundle files on Linux, like zip but better." \
        "tar -czf home.tar.gz home/: c=create, z=gzip compress, f=filename" \
        'chk "^tar .*-[czf]*c[czf]*.* .+|^tar -czf .+ .+"' 25

    run_challenge "List Archive Contents" \
        "Without extracting it, list what's inside ${YELLOW}home.tar.gz${NC}.\n\n  Preview the archive before unpacking." \
        "tar -tzf home.tar.gz: t=list contents, z=gzip, f=filename. No extraction." \
        'chk "^tar .*t.* .+"' 20

    run_challenge "Extract a tar Archive" \
        "Extract ${YELLOW}home.tar.gz${NC} into the current directory.\n\n  Unpack the archive in place." \
        "tar -xzf home.tar.gz: x=extract, z=gzip, f=filename" \
        'chk "^tar .*x.* .+"' 20

    run_challenge "Extract to a Specific Directory" \
        "Extract ${YELLOW}home.tar.gz${NC} into the ${YELLOW}tmp${NC} directory instead of the current one." \
        "tar -xzf home.tar.gz -C tmp/: -C sets the destination directory" \
        'chk "^tar .*x.*-C .+|^tar .*-C .+.*x"' 25

    cleanup_game_env
    level_complete 2
}

# ---- LEVEL 3: TEXT & SEARCH ----

run_level_3() {
    level_intro 3 "Text & Search" \
        "Data is everywhere. Finding what you need inside files and directories is a critical skill. grep and find are two of the most powerful commands in Linux, you'll use them constantly as a sysadmin or developer." \
        "🔍   Commands: grep  |  find  |  wc  |  sort  |  uniq  |  pipes"
    setup_game_env

    run_challenge "Search in a File" \
        "The file ${YELLOW}var/log/error.log${NC} has multiple lines. Show only lines containing the word ${YELLOW}ERROR${NC}." \
        "grep ERROR var/log/error.log: Global Regular Expression Print" \
        'chk "^grep .+"' 15

    run_challenge "Case-Insensitive Search" \
        "Search for ${YELLOW}warning${NC} (any case) in ${YELLOW}var/log/error.log${NC}." \
        "grep -i warning var/log/error.log: -i = ignore case" \
        'chk "^grep -[a-zA-Z]*i[a-zA-Z]* .+|^grep -i .+"' 20

    run_challenge "Find Files by Name" \
        "Find all ${YELLOW}.txt${NC} files in the current directory tree." \
        "find . -name '*.txt': search from . (here) by filename pattern" \
        'chk "^find .+"' 20

    run_challenge "Find by Type" \
        "Find all DIRECTORIES under the current path." \
        "find . -type d: type d=directory, f=file, l=symlink" \
        'chk "^find .+-type .+"' 20

    run_challenge "Count Lines" \
        "Count how many lines are in ${YELLOW}home/scores.txt${NC}." \
        "wc -l home/scores.txt: Word Count: -l=lines, -w=words, -c=bytes" \
        'chk "^wc .+"' 15

    run_challenge "Sort a File" \
        "Sort ${YELLOW}home/scores.txt${NC} alphabetically and print to screen." \
        "sort home/scores.txt: sorts alphabetically by default. -n for numeric, -r reverse" \
        'chk "^sort .+"' 15

    run_challenge "Your First Pipe" \
        "PIPES connect commands! Count only the ERROR lines in ${YELLOW}var/log/error.log${NC}.\n\n  Combine grep and wc using the pipe symbol ${YELLOW}|${NC}" \
        "grep ERROR var/log/error.log | wc -l: pipe sends grep's output INTO wc" \
        'chk ".*\|.*"' 25

    run_challenge "Search Recursively" \
        "Search for the word ${YELLOW}bash${NC} in ALL files under the current directory." \
        "grep -r bash .: -r = recursive search through all files" \
        'chk "^grep -[a-zA-Z]*r[a-zA-Z]* .+|^grep -r .+"' 20

    cleanup_game_env
    level_complete 3
}

# ---- LEVEL 4: PERMISSIONS ----

run_level_4() {
    level_intro 4 "Permissions & Users" \
        "Linux is a multi-user system. Every file has an owner and permissions controlling who can read, write, or execute it. The permission model is: Owner | Group | Others. Each can have Read(4), Write(2), Execute(1) or any combination." \
        "🔐   Commands: chmod  |  chown  |  whoami  |  id  |  ls -l"
    setup_game_env

    run_challenge "Who Are You?" \
        "Find out what username you're currently logged in as." \
        "whoami: prints current username" \
        'exact "whoami"' 10

    run_challenge "Your Identity" \
        "Show your full user and group identity information." \
        "id: shows uid, gid, and all group memberships" \
        'exact "id"' 10

    run_challenge "Read Permissions" \
        "List the ${YELLOW}home${NC} directory with full permission details.\n\n  You need the long format flag." \
        "ls -l home/: shows permissions like: -rwxr-xr-x  owner group size date name" \
        'chk "^ls -[a-zA-Z]*l[a-zA-Z]* .+|^ls -l .+"' 15

    run_challenge "Make a Script Executable" \
        "You have ${YELLOW}deploy.sh${NC} that needs execute permission for everyone.\n\n  Permissions: owner=rwx(7), group=rx(5), others=rx(5)" \
        "chmod 755 deploy.sh  OR  chmod +x deploy.sh: CHange MODe" \
        'chk "^chmod .+ .+"' 25

    run_challenge "Owner-Only Read" \
        "Lock down ${YELLOW}home/secret.txt${NC} so ONLY the owner can read it, no group, no others.\n\n  Owner=read(4), Group=none(0), Others=none(0)" \
        "chmod 400 home/secret.txt: OR chmod 600 for read+write owner only" \
        'chk "^chmod [0-7]{3,4} .+|^chmod [ugoa][+-=].+ .+"' 25

    run_challenge "Understanding Permissions" \
        "What does the permission string ${YELLOW}-rwxr-xr--${NC} mean?\nType the numeric (octal) equivalent.\n\n  r=4, w=2, x=1. Add them for each group: owner|group|others" \
        "754: owner: rwx=7, group: r-x=5, others: r--=4" \
        'exact "754"' 20

    cleanup_game_env
    tier_complete 4 "The Fundamentals" \
        "Navigation, files, search, and permissions, the four skills you'll use in literally every session you ever have on a Linux box. Everything from here assumes you have these cold." \
        "Tier 2: Intermediate: processes, text tools, networking, and your first shell scripts."
}

# ---- LEVEL 5: PROCESSES ----

run_level_5() {
    level_intro 5 "Process Management" \
        "Linux runs hundreds of processes simultaneously. As a sysadmin, you MUST be able to view, control, and manage them. A runaway process can bring down a server, knowing how to kill it fast is essential." \
        "⚙    Commands: ps  |  kill  |  top  |  jobs  |  bg  |  fg"
    setup_game_env

    run_challenge "List All Processes" \
        "Show ALL running processes from ALL users on the system." \
        "ps aux: a=all users, u=user-friendly format, x=include background processes" \
        'chk "^ps( [auxef]+| -[ef]+)?$"' 20

    run_challenge "Find a Process" \
        "Check if a process named ${YELLOW}nginx${NC} is running.\n\n  Use ps combined with a pipe." \
        "ps aux | grep nginx: pipe ps output into grep to filter by name" \
        'chk ".*ps.*\|.*grep.*|.*grep.*\|.*ps.*"' 20

    run_challenge "Kill a Process" \
        "A process with PID ${YELLOW}1337${NC} is hanging. Send the default termination signal." \
        "kill 1337: sends SIGTERM (15). Politely asks the process to terminate" \
        'chk "^kill( -15)? [0-9]+"' 25

    run_challenge "Force Kill" \
        "PID ${YELLOW}9999${NC} ignored the kill signal. Force-terminate it immediately.\n\n  Use a signal that CANNOT be caught or ignored." \
        "kill -9 9999: SIGKILL: instant termination, no cleanup. Nuclear option." \
        'chk "^kill -9 [0-9]+"' 25

    run_challenge "Background a Job" \
        "You're running a long process. Send it to the background so you can keep using the terminal.\n\n  Type the command that moves the current foreground job to background." \
        "bg: sends current (stopped) job to background. Start with cmd & for direct background" \
        'chk "^bg|^.+ &$"' 20

    run_challenge "List Background Jobs" \
        "Show all jobs running in the background in this shell session." \
        "jobs: lists background jobs with their job numbers" \
        'exact "jobs"' 15

    cleanup_game_env
    level_complete 5
}

# ---- LEVEL 6: TEXT PROCESSING ----

run_level_6() {
    level_intro 6 "Text Processing Power" \
        "The real superpower of Linux is transforming text. awk, sed, cut, these tools process data that would take hours in a GUI in milliseconds on the command line. Every senior engineer uses these daily." \
        "✂    Commands: awk  |  sed  |  cut  |  tr  |  head  |  tail"
    setup_game_env

    run_challenge "Cut a Field" \
        "Extract ONLY the usernames (field 1) from ${YELLOW}etc/passwd${NC}.\n\n  The file uses ${YELLOW}:${NC} as the field separator." \
        "cut -d: -f1 etc/passwd: -d sets delimiter, -f selects field number" \
        'chk "^cut .+"' 25

    run_challenge "awk Column Extraction" \
        "Print only the first word (score name) from each line of ${YELLOW}home/scores.txt${NC} using awk." \
        'awk '"'"'{print $1}'"'"' home/scores.txt: $1=first field, $2=second, $NF=last' \
        'chk "^awk .+"' 30

    run_challenge "awk with Condition" \
        "Use awk to print lines from ${YELLOW}home/scores.txt${NC} where the score (field 2) is greater than 50." \
        'awk -F: '"'"'$2 > 50'"'"' home/scores.txt  OR  awk '"'"'$2 > 50'"'"' home/scores.txt' \
        'chk "^awk .+"' 30

    run_challenge "sed Substitution" \
        "Replace every occurrence of ${YELLOW}ERROR${NC} with ${YELLOW}RESOLVED${NC} in ${YELLOW}var/log/error.log${NC} output." \
        "sed 's/ERROR/RESOLVED/g' var/log/error.log: s/find/replace/g (g=global, all occurrences)" \
        'chk "^sed .+"' 30

    run_challenge "sed Delete Lines" \
        "Print ${YELLOW}var/log/error.log${NC} with the lines containing ${YELLOW}INFO${NC} removed." \
        "sed '/INFO/d' var/log/error.log: /pattern/d deletes matching lines" \
        'chk "^sed .+"' 25

    run_challenge "tr - Translate Characters" \
        "Convert all lowercase letters in ${YELLOW}home/welcome.txt${NC} to uppercase.\n\n  Pipe cat into tr." \
        "cat home/welcome.txt | tr 'a-z' 'A-Z': tr translates character sets" \
        'chk ".*tr .+"' 25

    cleanup_game_env
    level_complete 6
}

# ---- LEVEL 7: NETWORKING ----

run_level_7() {
    level_intro 7 "Networking" \
        "Linux runs the internet. Every web server, router, and cloud instance runs Linux. Understanding network commands is non-negotiable for sysadmins and backend developers. Test connectivity, transfer files, call APIs." \
        "🌐   Commands: curl  |  wget  |  ping  |  ssh  |  ss  |  netstat"
    setup_game_env

    run_challenge "Test Connectivity" \
        "Check if ${YELLOW}google.com${NC} is reachable. Send exactly 4 packets then stop." \
        "ping -c 4 google.com: -c COUNT limits packets. Without it, ping runs forever." \
        'chk "^ping .+"' 20

    run_challenge "Fetch a URL" \
        "Make an HTTP GET request to ${YELLOW}https://example.com${NC} and print the response." \
        "curl https://example.com: Client URL. Default: GET request, print to stdout" \
        'chk "^curl .+"' 25

    run_challenge "Save Download to File" \
        "Download from ${YELLOW}https://example.com/data.json${NC} and save it as ${YELLOW}data.json${NC}." \
        "curl -o data.json https://example.com/data.json  OR  wget https://example.com/data.json" \
        'chk "^(curl -o|wget) .+"' 25

    run_challenge "POST with curl" \
        "Send a POST request to ${YELLOW}https://api.example.com/login${NC} with JSON data.\n\n  Include Content-Type header and a data payload." \
        "curl -X POST -H 'Content-Type: application/json' -d '{\"user\":\"test\"}' https://api.example.com/login" \
        'chk "^curl .+-X POST.+|^curl .+-d .+"' 30

    run_challenge "Check Listening Ports" \
        "Show all TCP ports currently listening on this machine with process names." \
        "ss -tlnp: t=TCP, l=listening, n=numeric ports, p=process info" \
        'chk "^(ss|netstat) .+"' 25

    run_challenge "SSH Into a Server" \
        "Connect via SSH to the server ${YELLOW}webserver.example.com${NC} as user ${YELLOW}admin${NC}.\n\n  Standard SSH syntax." \
        "ssh admin@webserver.example.com: Secure SHell: user@host" \
        'chk "^ssh .+"' 20

    run_challenge "Copy File Over SSH" \
        "Copy ${YELLOW}home/scores.txt${NC} to the remote server ${YELLOW}192.168.1.10${NC} at path ${YELLOW}/tmp/${NC} as user ${YELLOW}admin${NC}." \
        "scp home/scores.txt admin@192.168.1.10:/tmp/: Secure CoPy: like cp but over SSH" \
        'chk "^scp .+"' 25

    cleanup_game_env
    level_complete 7
}

# ---- LEVEL 8: SHELL SCRIPTING ----

run_level_8() {
    level_intro 8 "Shell Scripting" \
        "You've mastered individual commands. Now combine them into PROGRAMS. Shell scripts automate deployments, process data, monitor systems, and run backups. This is where Linux mastery truly begins." \
        "📜   Variables  |  Loops  |  Conditionals  |  Functions  |  Shebang"
    setup_game_env

    run_challenge "The Shebang Line" \
        "Every bash script starts with a special first line that tells the OS which interpreter to use.\n\n  What is the shebang line for bash?" \
        "#!/bin/bash: #! is the shebang, /bin/bash is the interpreter path" \
        'chk "^#!/(bin/bash|usr/bin/env bash)"' 15

    run_challenge "Set a Variable" \
        "Declare a variable called ${YELLOW}HOSTNAME${NC} with value ${YELLOW}webserver01${NC}.\n\n  No spaces around the = sign!" \
        "HOSTNAME=webserver01: variable assignment. NO spaces around =" \
        'chk "^[A-Z_][A-Z0-9_]*=[a-zA-Z0-9_.-]+"' 20

    run_challenge "Use a Variable" \
        "Print the value of the ${YELLOW}HOSTNAME${NC} variable.\n\n  Variables are accessed with \$ prefix." \
        "echo \$HOSTNAME: use \$ to expand/dereference a variable" \
        'chk "^echo \\\$[A-Z_][A-Z0-9_]*$"' 20

    run_challenge "Command Substitution" \
        "Store the output of ${YELLOW}date${NC} into a variable called ${YELLOW}NOW${NC}.\n\n  Capture command output with \$() syntax." \
        'NOW=$(date): $() captures command output. Old style: `date` (backticks)' \
        'chk "^[A-Z_]+=\\\$\(.+\)"' 25

    run_challenge "For Loop" \
        "Write a for loop that iterates over the values ${YELLOW}1 2 3${NC} and echoes each.\n\n  All on one line using semicolons." \
        "for i in 1 2 3; do echo \$i; done: basic for..in loop syntax" \
        'chk "^for .+do .+done$"' 25

    run_challenge "While Loop" \
        "Write a while loop that runs while a condition is true.\n\n  Use while true to make an infinite loop (common in servers)." \
        "while true; do echo running; sleep 1; done: while condition; do ... done" \
        'chk "^while .+do .+done$"' 25

    run_challenge "If Statement" \
        "Write an if statement that checks if ${YELLOW}home/welcome.txt${NC} exists and echoes 'found'." \
        "if [ -f home/welcome.txt ]; then echo found; fi: -f=file exists, -d=dir, -z=string empty" \
        'chk "^if \[.+\]; then .+fi$"' 30

    run_challenge "Function" \
        "Define a bash function called ${YELLOW}greet${NC} that echoes 'Hello World'." \
        "greet() { echo 'Hello World'; }: function syntax: name() { commands; }" \
        'chk "^[a-z_]+\(\) \{.+\}$"' 30

    cleanup_game_env
    tier_complete 8 "Processes & First Scripts" \
        "You can now inspect and control anything running on a box, reshape text with real precision, reach across the network, and write your first automation instead of typing the same commands by hand. That's the job, in miniature." \
        "Tier 3: Pipes & Patterns: chaining commands together and regex, the language every text tool speaks."
}

# ============================================================
# LEVEL 9: ADVANCED PIPING
# ============================================================

run_level_9() {
    level_intro 9 "Advanced Piping" \
        "The pipe | is the beating heart of Unix philosophy: each small tool does ONE thing well, and you chain them together. Data flows left to right, the STDOUT of each command becomes the STDIN of the next. Mastering pipes lets you build powerful one-liners that would take dozens of lines in any other language." \
        "🔗   |  tee  chaining  multi-pipe  sort|uniq  grep|wc"
    setup_game_env

    run_challenge "Your First Chain" \
        "Count how many UNIQUE users are defined in ${YELLOW}etc/passwd${NC}.\n\n  Chain four commands:\n  ${CYAN}cut${NC} → extract field 1 (username)\n  ${CYAN}sort${NC} → put them in order (uniq needs sorted input!)\n  ${CYAN}uniq${NC} → remove duplicates\n  ${CYAN}wc -l${NC} → count the lines" \
        "cut -d: -f1 etc/passwd | sort | uniq | wc -l: four pipes, four tools, one answer" \
        'chk ".*\|.*\|.*\|.*"' 30

    run_challenge "tee: Branch the Stream" \
        "Search ${YELLOW}var/log/error.log${NC} for ${YELLOW}ERROR${NC} lines, display them on screen AND save them to ${YELLOW}errors.txt${NC} simultaneously.\n\n  ${CYAN}tee${NC} is named after a plumbing T-junction: it splits the stream in two directions at once. Perfect for logging pipeline output while still watching it." \
        "grep ERROR var/log/error.log | tee errors.txt: tee writes to the file AND passes the data downstream unchanged" \
        'chk ".*\| *tee .+"' 25

    run_challenge "Count Non-matching Lines" \
        "Count how many lines in ${YELLOW}var/log/error.log${NC} do NOT contain ${YELLOW}INFO${NC}.\n\n  ${CYAN}grep -v${NC} inverts the match (shows lines that do NOT match). Pipe that into ${CYAN}wc -l${NC} to count." \
        "grep -v INFO var/log/error.log | wc -l: -v inverts grep: shows every line that does NOT match the pattern" \
        'chk "grep -[a-zA-Z]*v[a-zA-Z]* .+ .+\| *wc|grep -v .+\| *wc"' 25

    run_challenge "Sort + Deduplicate" \
        "From ${YELLOW}home/scores.txt${NC}, extract the names (first word on each line), sort them, and remove duplicates.\n\n  ${CYAN}Key insight${NC}: uniq only removes ADJACENT duplicates, so you must sort first, then uniq." \
        "cut -d' ' -f1 home/scores.txt | sort | uniq: always sort before uniq, otherwise non-adjacent duplicates survive" \
        'chk ".*cut .+\| *sort.*\| *uniq|.*sort .+\| *uniq"' 25

    run_challenge "Pipe to a Pager" \
        "The output of ${YELLOW}cat etc/passwd${NC} is long. Pipe it through a pager so you can scroll it.\n\n  ${CYAN}less${NC} lets you scroll up/down (j/k or arrow keys), search with /, quit with q. On servers with huge outputs, always use a pager." \
        "cat etc/passwd | less: less is a pager. Also: q=quit, G=end, g=start, /pattern=search" \
        'chk ".*\| *(less|more)$"' 15

    run_challenge "Extract, Sort, Count" \
        "From ${YELLOW}var/log/error.log${NC}, find the most common log level (ERROR/INFO/WARNING).\n\n  Pipeline: ${CYAN}grep -oE${NC} (extract the word) → ${CYAN}sort${NC} → ${CYAN}uniq -c${NC} (count each) → ${CYAN}sort -rn${NC} (highest count first)" \
        "grep -oE 'ERROR|INFO|WARNING' var/log/error.log | sort | uniq -c | sort -rn: uniq -c prepends count. sort -rn = reverse numeric sort" \
        'chk ".*\| *sort.*\| *uniq -c.*\| *sort"' 30

    cleanup_game_env
    level_complete 9
}

# ============================================================
# LEVEL 10: I/O REDIRECTION
# ============================================================

run_level_10() {
    level_intro 10 "Input & Output Redirection" \
        "Every process has three standard streams: stdin (0) for input, stdout (1) for normal output, stderr (2) for errors. Redirection sends these streams to files or other places. This is fundamental to scripting, logging, automation, and understanding why some programs seem to 'not output' when piped." \
        "📤   >  >>  <  2>  2>&1  &>  /dev/null  <<EOF"
    setup_game_env

    run_challenge "Redirect stdout to a File" \
        "Run ${YELLOW}ls -l home/${NC} and save the output to ${YELLOW}listing.txt${NC} instead of the screen.\n\n  ${CYAN}>${NC} redirects stdout to a file, overwriting it each time. This is how you capture command output for later use, logging, or passing to other tools." \
        "ls -l home/ > listing.txt: > redirects stdout. WARNING: overwrites existing file without warning. Use >> to append." \
        'chk ".+ > [a-zA-Z0-9_./-]+"' 20

    run_challenge "Append to a File" \
        "Append the current date and time to ${YELLOW}listing.txt${NC} without erasing what's already there.\n\n  ${CYAN}>>${NC} vs ${CYAN}>${NC}: one appends, one overwrites. Getting this wrong in a cron script can silently destroy log history." \
        "date >> listing.txt: >> appends without overwriting. Cron jobs and log scripts always use >> for safety." \
        'chk ".+ >> [a-zA-Z0-9_./-]+"' 20

    run_challenge "Redirect stderr" \
        "Run ${YELLOW}ls /doesnotexist${NC} but send the error message to ${YELLOW}err.log${NC} instead of the screen.\n\n  ${CYAN}2>${NC} redirects file descriptor 2 (stderr). Normal output (stdout) still goes to the screen. Separating error streams is essential in production scripts." \
        "ls /doesnotexist 2> err.log: 2> redirects stderr only. stdout remains on screen (or wherever it was going)." \
        'chk ".+ 2> [a-zA-Z0-9_./-]+"' 25

    run_challenge "Merge stdout and stderr" \
        "Run ${YELLOW}ls -l home/ /doesnotexist${NC} and send BOTH normal output AND errors to ${YELLOW}all.log${NC}.\n\n  ${CYAN}2>&1${NC} means 'send file descriptor 2 to wherever fd 1 is currently pointing'. Order matters: redirect stdout first, then merge stderr into it." \
        "ls -l home/ /doesnotexist > all.log 2>&1: OR: ls ... &> all.log  (&> is bash shorthand for both streams)" \
        'chk ".+ > .+ 2>&1|.+ &> .+"' 25

    run_challenge "Discard All Output" \
        "Run ${YELLOW}ls home/${NC} and throw away ALL output, stdout and stderr, completely silently.\n\n  ${CYAN}/dev/null${NC} is the 'black hole' device: anything written there disappears. In scripts you often only care if a command SUCCEEDS, not what it prints." \
        "ls home/ > /dev/null 2>&1  OR  ls home/ &> /dev/null: /dev/null discards everything written to it" \
        'chk ".+ > /dev/null 2>&1|.+ &> /dev/null"' 20

    run_challenge "Feed a File as Input" \
        "Use ${YELLOW}sort${NC} to sort ${YELLOW}home/scores.txt${NC} by redirecting the file as stdin rather than passing it as an argument.\n\n  ${CYAN}<${NC} redirects a file to a command's stdin. Both forms work for sort, but < is essential for commands that only read stdin." \
        "sort < home/scores.txt: < redirects file content to stdin. Equivalent here, but some commands ONLY read stdin." \
        'chk "sort < .+"' 20

    run_challenge "Here Document" \
        "Write two lines to ${YELLOW}note.txt${NC} using a here-document, inline multi-line input.\n\n  ${CYAN}<<EOF${NC} starts a heredoc: the shell reads lines until it sees EOF on its own line. Heredocs are used everywhere: Dockerfiles, Ansible, scripts, SSH remote commands." \
        "cat > note.txt <<EOF  (type your lines, then EOF alone on a line): heredoc syntax. The delimiter can be any word, not just EOF." \
        'chk ".*<< *[A-Z_]+"' 20

    cleanup_game_env
    level_complete 10
}

# ============================================================
# LEVEL 11: REGULAR EXPRESSIONS
# ============================================================

run_level_11() {
    level_intro 11 "Regular Expressions" \
        "Regex is a pattern language for matching text. It powers grep, sed, awk, Python, JavaScript, and almost every modern language. Once you learn it, you use it constantly. The basics cover: anchors (^ \$), wildcards (.), repetition (* + ?), character classes ([]), and alternation (|)." \
        "🔤   ^  \$  .  *  +  ?  []  [^]  \\b  |  ()  grep -E"
    setup_game_env

    run_challenge "Anchor: Start of Line" \
        "Show lines from ${YELLOW}var/log/error.log${NC} that START with the word ${YELLOW}ERROR${NC}.\n\n  ${CYAN}^${NC} anchors the match to the very start of a line. Without it, 'ERROR' would match anywhere in the line, even inside a URL or filename." \
        "grep '^ERROR' var/log/error.log: ^ means 'must match here at the start'. Essential for structured log parsing." \
        'chk "grep.*\^[A-Za-z].+ .+"' 25

    run_challenge "Anchor: End of Line" \
        "Find lines in ${YELLOW}etc/passwd${NC} that END with ${YELLOW}/bash${NC}.\n\n  ${CYAN}\$${NC} anchors the match to the end of a line. This ensures '/bash' is the final thing on the line, not just somewhere in the middle." \
        "grep '/bash\$' etc/passwd: \$ means 'end of line'. Combine with ^ for exact full-line matches: grep '^root:' " \
        'chk "grep.*\\\$.+ .+|grep.*/bash\\\$.+"' 25

    run_challenge "Character Class" \
        "Find lines in ${YELLOW}home/scores.txt${NC} that contain at least one digit.\n\n  ${CYAN}[0-9]${NC} matches any single character in that range. ${CYAN}[a-zA-Z]${NC} matches any letter. ${CYAN}[^0-9]${NC} (with ^) matches anything EXCEPT a digit." \
        "grep '[0-9]' home/scores.txt: [chars] is a character class. [0-9]=digit, [a-z]=lowercase, [^x]=not x" \
        'chk "grep.*\[.+\]"' 20

    run_challenge "Extended Regex: one or more (+)" \
        "Use ${YELLOW}grep -E${NC} to find lines in ${YELLOW}var/log/error.log${NC} containing one or more consecutive digits.\n\n  ${CYAN}+${NC} means 'one or more of the preceding'. It requires ${CYAN}-E${NC} (extended regex), in basic regex you need \\+ which is ugly. ${CYAN}*${NC} means zero or more. ${CYAN}?${NC} means zero or one." \
        "grep -E '[0-9]+' var/log/error.log: -E enables ERE (Extended Regular Expressions). Always prefer -E over escaping." \
        'chk "grep -[a-zA-Z]*E[a-zA-Z]* .+ .+"' 25

    run_challenge "Alternation: OR" \
        "Show lines from ${YELLOW}var/log/error.log${NC} that contain either ${YELLOW}ERROR${NC} or ${YELLOW}WARNING${NC} (one grep command).\n\n  ${CYAN}|${NC} inside a regex means OR. With ${CYAN}-E${NC}: pattern1|pattern2. Without -E you need \\| which is messier." \
        "grep -E 'ERROR|WARNING' var/log/error.log: alternation: matches if EITHER pattern is found on the line" \
        'chk "grep -[a-zA-Z]*E[a-zA-Z]*.+\|.+ .+"' 25

    run_challenge "Wildcard: any character (.)" \
        "Find lines in ${YELLOW}var/log/error.log${NC} that contain any 3-letter word starting with ${YELLOW}E${NC} and ending with ${YELLOW}R${NC}.\n\n  ${CYAN}.${NC} matches ANY single character (except newline). ${CYAN}E.R${NC} would match 'EAR', 'EOR', 'E R', etc." \
        "grep -E 'E.R' var/log/error.log: . is the wildcard: matches any single character. .* matches any sequence." \
        'chk "grep -[a-zA-Z]*E[a-zA-Z]* .E.R. .+|grep .E.R. .+"' 20

    run_challenge "Match Whole Word" \
        "Find lines in ${YELLOW}var/log/error.log${NC} containing the whole word ${YELLOW}disk${NC} but NOT ${YELLOW}diskspace${NC} or ${YELLOW}disks${NC}.\n\n  ${CYAN}-w${NC} matches whole words only, it won't match if the pattern is part of a longer word. Equivalent to surrounding with word boundaries \\b in -E mode." \
        "grep -w 'disk' var/log/error.log  OR  grep -E '\\bdisk\\b' var/log/error.log: -w is the clean approach" \
        'chk "grep -[a-zA-Z]*w[a-zA-Z]* .+ .+|grep -E .+\\\\b.+\\\\b .+"' 20

    cleanup_game_env
    level_complete 11
}

# ============================================================
# LEVEL 12: ADVANCED GREP
# ============================================================

run_level_12() {
    level_intro 12 "Advanced grep" \
        "grep is far more than a simple search tool. With -n you get line numbers, -l lists files, -c counts, -A/-B/-C gives context, -o extracts just the match, -r recurses directories. Combine these with pipes and regex and you can answer almost any 'find me this in these files' question in seconds." \
        "🔎   grep -n  -l  -c  -A  -B  -C  -o  -r  --include"
    setup_game_env

    run_challenge "Show Line Numbers" \
        "Search for ${YELLOW}ERROR${NC} in ${YELLOW}var/log/error.log${NC} and show the line number of each match.\n\n  ${CYAN}-n${NC} is invaluable in scripts, you can jump directly to the problem line in vim with :123 or sed -n '123p'." \
        "grep -n 'ERROR' var/log/error.log: -n prints: linenum:matchedline. Combine with -r for cross-file line numbers." \
        'chk "grep -[a-zA-Z]*n[a-zA-Z]* .+ .+"' 20

    run_challenge "Show Context Around a Match" \
        "Find ${YELLOW}WARNING${NC} in ${YELLOW}var/log/error.log${NC} and show 2 lines of context BEFORE and AFTER each match.\n\n  Errors rarely happen in isolation. The lines around a match often reveal the root cause, a failed connection, a timeout, a missing file." \
        "grep -C 2 'WARNING' var/log/error.log: -C N = N lines of Context (both sides). -A N = After. -B N = Before." \
        'chk "grep -[ABC] [0-9] .+ .+"' 25

    run_challenge "Count Matching Lines" \
        "Count how many lines in ${YELLOW}var/log/error.log${NC} contain ${YELLOW}ERROR${NC}.\n\n  ${CYAN}-c${NC} is faster than piping to wc -l because grep itself does the counting, one less process spawned." \
        "grep -c 'ERROR' var/log/error.log: -c prints the count of matching lines only, not the lines themselves" \
        'chk "grep -[a-zA-Z]*c[a-zA-Z]* .+ .+"' 20

    run_challenge "List Files with Matches" \
        "Recursively search ${YELLOW}.${NC} for the word ${YELLOW}bash${NC} and list only the FILENAMES that contain it.\n\n  ${CYAN}-l${NC} (list files) is the right tool when you have hundreds of files and just need to know WHICH ones to look at, not see every individual match." \
        "grep -rl 'bash' .: -r=recursive, -l=list filenames only (not the matching lines)" \
        'chk "grep -[a-zA-Z]*r[a-zA-Z]*l[a-zA-Z]* .+ .+|grep -[a-zA-Z]*l[a-zA-Z]*r[a-zA-Z]* .+ .+"' 25

    run_challenge "Limit to File Types" \
        "Recursively search ${YELLOW}.${NC} for ${YELLOW}root${NC} but only look inside ${YELLOW}.txt${NC} files.\n\n  ${CYAN}--include${NC} drastically speeds up large directory searches by skipping irrelevant files. Always use it when you know the file extension." \
        "grep -r --include='*.txt' 'root' .: --include='*.txt' filters which files grep opens. --exclude skips files." \
        'chk "grep -r.*--include.* .+ .+|grep.*--include.* -r .+ .+"' 25

    run_challenge "Extract Only the Match" \
        "From ${YELLOW}var/log/error.log${NC}, extract ONLY the words in ALL CAPS (not the whole line, just the matching text).\n\n  ${CYAN}-o${NC} prints only the matched portion of each line, one match per line. Extremely useful for extracting IP addresses, emails, version numbers, etc." \
        "grep -oE '[A-Z]{2,}' var/log/error.log: -o=only matching text. Each match on its own line. Great for feeding into sort|uniq|wc." \
        'chk "grep -[a-zA-Z]*o[a-zA-Z]* .+ .+"' 25

    cleanup_game_env
    level_complete 12
}

# ============================================================
# LEVEL 13: ADVANCED SED
# ============================================================

run_level_13() {
    level_intro 13 "Advanced sed: Stream Editor" \
        "sed reads input line by line and applies editing commands. Think of it as find-and-replace on steroids: it handles ranges, patterns, in-place file editing, line deletion, and extraction. sed is in every sysadmin's deployment script, every CI/CD pipeline, and every config management tool." \
        "📝   s/find/replace/flags  -i  /pattern/d  -n 'Np'  addr1,addr2  y///"
    setup_game_env

    run_challenge "Replace First Match per Line" \
        "Replace only the FIRST occurrence of ${YELLOW}ERROR${NC} per line with ${YELLOW}FIXED${NC} in ${YELLOW}var/log/error.log${NC}.\n\n  Without the ${CYAN}/g${NC} flag, sed's substitution stops after the first match on each line. Use this when later occurrences are intentional." \
        "sed 's/ERROR/FIXED/' var/log/error.log: no /g = first match per line only. The /g flag makes it global." \
        'chk "^sed .*s/.+/.+/"' 20

    run_challenge "Global Replace" \
        "Replace ALL occurrences of ${YELLOW}ERROR${NC} with ${YELLOW}FIXED${NC} on every line.\n\n  ${CYAN}/g${NC} (global flag) replaces every occurrence on each line, not just the first. This is what most people mean when they say 'find and replace'." \
        "sed 's/ERROR/FIXED/g' var/log/error.log: /g = global: all occurrences on every line" \
        'chk "^sed .*s/.+/.+/g"' 20

    run_challenge "Delete Lines by Pattern" \
        "Print ${YELLOW}var/log/error.log${NC} with all ${YELLOW}INFO${NC} lines removed entirely.\n\n  ${CYAN}/pattern/d${NC}, the d command deletes lines matching the address. Lines not matching pass through unchanged. Use this to strip noise from logs." \
        "sed '/INFO/d' var/log/error.log: /pattern/ is the address (which lines to act on). d = delete those lines." \
        'chk "^sed .*/.+/d"' 25

    run_challenge "Print a Specific Line" \
        "Print only line 2 of ${YELLOW}var/log/error.log${NC} using sed.\n\n  ${CYAN}sed -n '2p'${NC}: -n suppresses default output (sed normally prints every line), then p explicitly prints the addressed line. Together they print only what you select." \
        "sed -n '2p' var/log/error.log: -n suppresses auto-print. p = print this line. Alternative: awk 'NR==2'" \
        'chk "^sed -n .+[0-9]+p.+ .+"' 25

    run_challenge "Print a Line Range" \
        "Print lines 2 through 4 of ${YELLOW}var/log/error.log${NC}.\n\n  ${CYAN}addr1,addr2${NC} defines a range, from the first address to the second. Addresses can be line numbers, patterns, or a mix: '/START/,/END/'." \
        "sed -n '2,4p' var/log/error.log: 2,4 = from line 2 to line 4 inclusive. Try: sed -n '/ERROR/,/WARNING/p'" \
        'chk "^sed -n .+[0-9]+,[0-9]+p.+ .+"' 25

    run_challenge "In-place Edit" \
        "Edit ${YELLOW}var/log/error.log${NC} directly, replace ${YELLOW}ERROR${NC} with ${YELLOW}RESOLVED${NC} inside the file itself.\n\n  ${CYAN}-i.bak${NC} edits in-place and creates a backup (.bak suffix). On macOS, ${CYAN}-i.bak${NC} (no space) works on both BSD and GNU sed. ${CYAN}-i ''${NC} on macOS or ${CYAN}-i${NC} on Linux for no backup." \
        "sed -i.bak 's/ERROR/RESOLVED/g' var/log/error.log: -i.bak works on macOS AND Linux. For no backup: -i '' (macOS) or -i (Linux)" \
        'chk "^sed -i.* .+s/.+/.+/.* .+"' 30

    run_challenge "Target Specific Line" \
        "Replace ${YELLOW}INFO${NC} with ${YELLOW}DEBUG${NC} ONLY on line 2 of ${YELLOW}var/log/error.log${NC}, leave all other lines alone.\n\n  Prefix the s command with a line-number address to scope it. This is how sed replaces things surgically in config files." \
        "sed '2s/INFO/DEBUG/' var/log/error.log: 2s/find/replace/ = apply substitution only on line 2" \
        'chk "^sed .*[0-9]+s/.+/.+/"' 25

    cleanup_game_env
    level_complete 13
}

# ============================================================
# LEVEL 14: ADVANCED AWK
# ============================================================

run_level_14() {
    level_intro 14 "Advanced awk" \
        "awk is a complete text-processing language. It splits each line into numbered fields, runs your program on every line, and has built-in variables, math, string functions, and printf. awk is what you reach for when a shell pipeline gets complicated, it handles things cleanly that would take multiple sed and cut commands." \
        "⚡   NR  NF  \$0  \$1  FS  BEGIN{}  END{}  printf  conditions  math"
    setup_game_env

    run_challenge "NR and \$0: Line Number + Full Line" \
        "Print the line number and full content of every line in ${YELLOW}etc/passwd${NC}.\n\n  ${CYAN}NR${NC} = Number of Records (current line number). ${CYAN}\$0${NC} = the entire current line. ${CYAN}\$1, \$2...${NC} = individual fields split by the separator." \
        "awk '{print NR, \$0}' etc/passwd: NR auto-increments. \$0 is the whole line before field splitting." \
        'chk "^awk .+NR.+ .+"' 25

    run_challenge "NF: Number of Fields" \
        "For each line of ${YELLOW}etc/passwd${NC} (colon-separated), print how many fields it contains.\n\n  ${CYAN}NF${NC} = Number of Fields on the current line. ${CYAN}\$NF${NC} = the LAST field (handy for getting filenames from paths)." \
        "awk -F: '{print NF}' etc/passwd: -F: sets field separator to colon. NF tells you the count of fields." \
        'chk "^awk -F.* .+NF.+ .+"' 25

    run_challenge "Conditional Filter" \
        "Print only lines from ${YELLOW}home/scores.txt${NC} where the score (2nd field) is above 50.\n\n  ${CYAN}awk 'condition { action }'${NC}, if no action, the default is {print \$0}. Conditions can use ==, !=, >, <, >=, <=, && and ||." \
        "awk '\$2 > 50' home/scores.txt: condition without {action} defaults to printing the whole line. Clean and readable." \
        'chk "^awk .\\\$[0-9]+ *[><=!]+ *[0-9]+. .+"' 25

    run_challenge "Sum a Column" \
        "Calculate the total of all scores in ${YELLOW}home/scores.txt${NC} (2nd field).\n\n  ${CYAN}END{}${NC} runs once after ALL lines have been processed, perfect for totals, averages, and summaries. Variables in awk start at 0 automatically." \
        "awk '{sum += \$2} END {print \"Total:\", sum}' home/scores.txt: accumulate in sum each line, print once at END" \
        'chk "^awk .+END.+print.+ .+"' 30

    run_challenge "BEGIN Header" \
        "Print a header line ${YELLOW}NAME  SCORE${NC} before listing all lines of ${YELLOW}home/scores.txt${NC}.\n\n  ${CYAN}BEGIN{}${NC} runs once BEFORE any input is read. Use it for: printing headers, initialising variables, setting the field separator (FS=\":\")." \
        "awk 'BEGIN{print \"NAME  SCORE\"} {print}' home/scores.txt: BEGIN runs before line 1. END runs after the last line." \
        'chk "^awk .+BEGIN.+print.+ .+"' 25

    run_challenge "printf: Formatted Output" \
        "Print name and score from ${YELLOW}home/scores.txt${NC} in a neat fixed-width table using awk's printf.\n\n  ${CYAN}printf \"%-10s %4d\\n\", \$1, \$2${NC}, %-10s = left-aligned 10-char string, %4d = right-aligned 4-digit integer. Identical syntax to C's printf." \
        "awk '{printf \"%-10s %4d\\n\", \$1, \$2}' home/scores.txt: printf controls exact column widths. Essential for readable reports." \
        'chk "^awk .+printf.+ .+"' 30

    run_challenge "Field Separator: Parsing CSV/config" \
        "Extract just the usernames (field 1) and shells (last field) from ${YELLOW}etc/passwd${NC} in a clean two-column format.\n\n  Set ${CYAN}-F:${NC} for the colon separator, use ${CYAN}\$NF${NC} for the last field regardless of how many fields there are." \
        "awk -F: '{print \$1, \$NF}' etc/passwd: \$NF = last field. Works for any number of fields. Combine with printf for alignment." \
        'chk "^awk -F.+ .+\\\$NF.+ .+"' 25

    cleanup_game_env
    tier_complete 14 "Pipes & Patterns" \
        "Pipes, redirection, regex, and the big three text tools, grep, sed, awk, fluently. This is the tier that turns 'I know some Linux commands' into 'I can process anything a log file or config throws at me.'" \
        "Tier 4: Power Tools: xargs, disk and system diagnostics, users, SSH, and your shell environment."
}

# ============================================================
# LEVEL 15: XARGS & FIND -EXEC
# ============================================================

run_level_15() {
    level_intro 15 "xargs & find -exec" \
        "find locates files. But what do you DO with them once found? Two patterns: find -exec runs a command on each file one at a time. xargs batches them and passes them as arguments, far more efficient for large sets. xargs -I{} lets you place the filename anywhere in the command." \
        "🔧   find -exec {} \\;  find -exec {} +  xargs  xargs -I{}  -print0 | xargs -0"
    setup_game_env

    run_challenge "find -exec Basic" \
        "Find all ${YELLOW}.txt${NC} files under ${YELLOW}.${NC} and print their contents using find's -exec flag.\n\n  ${CYAN}-exec cmd {} \\;${NC}, {} is replaced with the found filename. \\; ends the -exec (runs command once per file). Use + instead of \\; to batch files into one command call." \
        "find . -name '*.txt' -exec cat {} \\;: {} = placeholder for found file. \\; = one call per file. Use + for efficiency with many files." \
        'chk "^find .+ -exec .+ \{\} [\\\\;+]"' 30

    run_challenge "xargs basics" \
        "Find all ${YELLOW}.txt${NC} files and count the lines in all of them at once using xargs.\n\n  ${CYAN}xargs${NC} reads lines from stdin and appends them as arguments to a command. More efficient than -exec \\; because it passes many files in one invocation." \
        "find . -name '*.txt' | xargs wc -l: xargs bundles stdin items as arguments. Better than -exec \\; for large file counts." \
        'chk ".*find .+\| *xargs .+"' 25

    run_challenge "xargs with a Placeholder" \
        "Copy every ${YELLOW}.txt${NC} file found under ${YELLOW}.${NC} to ${YELLOW}tmp/${NC} with ${YELLOW}.bak${NC} appended to its name.\n\n  ${CYAN}xargs -I{}${NC} lets you use {} as a placeholder ANYWHERE in the command, not just at the end. Essential when you need the filename in the middle of the command." \
        "find . -name '*.txt' | xargs -I{} cp {} tmp/{}.bak: -I{} replaces {} everywhere in the command line" \
        'chk ".*xargs -I.* .+"' 30

    run_challenge "Handle Filenames with Spaces" \
        "Safely find all ${YELLOW}.txt${NC} files and pass them to wc -l, even if filenames have spaces.\n\n  ${CYAN}-print0${NC} separates filenames with null bytes (not newlines). ${CYAN}xargs -0${NC} reads null-separated input. Together they're the safe way to handle any filename." \
        "find . -name '*.txt' -print0 | xargs -0 wc -l: -print0 and -0 use null bytes instead of newlines. Safe for ALL filenames." \
        'chk ".*-print0.*\|.*xargs -0.*|.*find .+-print0.*\| *xargs -0"' 30

    run_challenge "find by Size" \
        "Find all files under ${YELLOW}.${NC} larger than 10 bytes.\n\n  ${CYAN}-size +10c${NC}, c=bytes, k=kilobytes, M=megabytes, G=gigabytes. + means 'greater than', - means 'less than', no prefix means 'exactly'." \
        "find . -size +10c: +10c = larger than 10 bytes. -size +1M = larger than 1 MB. Combine with -exec to act on results." \
        'chk "^find .+ -size .+"' 20

    run_challenge "find by Modification Time" \
        "Find files modified in the last 2 days under ${YELLOW}.${NC}.\n\n  ${CYAN}-mtime -2${NC} = modified less than 2 days ago. ${CYAN}-mtime +7${NC} = older than 7 days. ${CYAN}-mmin -60${NC} = modified in the last 60 minutes. Great for finding recently changed config files." \
        "find . -mtime -2: -mtime -N = less than N days old. Useful: find /etc -mtime -1 to see recent config changes." \
        'chk "^find .+ -m(time|min) .+"' 25

    cleanup_game_env
    level_complete 15
}

# ============================================================
# LEVEL 16: DISK & STORAGE
# ============================================================

run_level_16() {
    level_intro 16 "Disk & Storage" \
        "A full disk silently kills services. Logs stop writing, databases corrupt, applications crash. Knowing how to quickly diagnose disk usage, which filesystem is full, which directory is the culprit, is one of the most time-critical sysadmin skills. These are your emergency tools." \
        "💾   df -h  |  du -sh  |  du -sh * | sort  |  lsblk  |  findmnt"
    setup_game_env

    run_challenge "Check Filesystem Usage" \
        "Show how much free space is available on all mounted filesystems in human-readable form.\n\n  ${CYAN}df -h${NC} is the first command you run when a server is slow or a service is dying, it tells you instantly if disk space is the culprit." \
        "df -h: Disk Free, -h = human-readable (GB/TB instead of 512-byte blocks). Look for 'Use%' near 100%." \
        'chk "^df( -[a-zA-Z]+)?$"' 15

    run_challenge "Directory Total Size" \
        "Show the total disk usage of the ${YELLOW}var${NC} directory in human-readable form.\n\n  ${CYAN}du${NC} (Disk Usage) measures actual file sizes, not filesystem-level allocation. -s gives a summary total, not a per-file breakdown." \
        "du -sh var/: -s = summary (total only, don't recurse into subdirectories), -h = human readable" \
        'chk "^du .+ .+"' 20

    run_challenge "Find the Space Hogs" \
        "List the sizes of all items in the current directory, sorted largest first.\n\n  This is the go-to command when a disk is full and you need to find the culprit quickly. ${CYAN}sort -rh${NC} sorts human-readable sizes in reverse order (largest first)." \
        "du -sh * | sort -rh: du * gets size of each item, sort -rh = reverse human-readable sort. macOS: add -k for stability." \
        'chk "^du .+\| *sort .+"' 25

    run_challenge "Find Large Files" \
        "Find all files under ${YELLOW}.${NC} larger than 50 bytes and list them with their size.\n\n  On a real server you'd search from / for files > 100MB. The -ls flag outputs like 'ls -l' so you see size, owner, and path." \
        "find . -size +50c -ls  OR  find . -size +50c -exec ls -lh {} \\;: -ls in find prints detailed info for each found file" \
        'chk "^find .+ -size .+"' 20

    run_challenge "List Block Devices" \
        "List all block devices (disks and their partitions) on the system in a tree view.\n\n  ${CYAN}lsblk${NC} shows the block device tree: physical disks, their partitions, and where they're mounted. Always check this before partitioning or mounting." \
        "lsblk: List BLocK devices. Shows: NAME, MAJ:MIN, SIZE, TYPE (disk/part/lvm), MOUNTPOINT" \
        'chk "^lsblk( -[a-zA-Z]+)?$"' 15

    run_challenge "Show Mount Points" \
        "Show all currently mounted filesystems in a human-readable tree.\n\n  ${CYAN}findmnt${NC} is the modern tool, cleaner than parsing /proc/mounts or running mount | column -t. Shows filesystem type, source, and mount options." \
        "findmnt  OR  mount | column -t: findmnt shows mount tree. On macOS: mount (no findmnt)" \
        'chk "^(findmnt|mount)( -[a-zA-Z]+)?$"' 15

    cleanup_game_env
    level_complete 16
}

# ============================================================
# LEVEL 17: SYSTEM INFORMATION
# ============================================================

run_level_17() {
    level_intro 17 "System Information" \
        "When you SSH into an unfamiliar server, or one that's misbehaving, you need to quickly establish situational awareness: what OS, what kernel, how much RAM, how many CPUs, how long has it been running, what's consuming resources. These commands build that picture in seconds." \
        "🖥️   uname  |  lscpu / sysctl  |  free / vm_stat  |  uptime  |  lsof  |  who"
    setup_game_env

    run_challenge "Kernel and Architecture" \
        "Print kernel name, hostname, kernel version, and hardware architecture all at once.\n\n  ${CYAN}uname -a${NC} is the first thing to run on an unfamiliar box. It tells you the OS family, kernel version, and CPU architecture (x86_64, arm64, etc.)." \
        "uname -a: All fields: kernel name, node name, release, version, machine, OS. On macOS too." \
        'chk "^uname( -[a-zA-Z]+)?$"' 15

    run_challenge "CPU Details" \
        "Show detailed CPU information, architecture, core count, speed.\n\n  ${CYAN}lscpu${NC} is Linux only. On macOS use ${CYAN}sysctl -n machdep.cpu.brand_string${NC}. The game validates either answer." \
        "lscpu  OR  sysctl -n machdep.cpu.brand_string: lscpu = Linux, sysctl = macOS/BSD. Know both." \
        'chk "^(lscpu|sysctl .+cpu.+)$"' 15

    run_challenge "Memory Usage" \
        "Show RAM usage, total, used, and free, in human-readable form.\n\n  ${CYAN}free -h${NC} is Linux only. On macOS use ${CYAN}vm_stat${NC} (different format, pages-based). The 'available' column in free -h is what matters, not 'free', which excludes cache." \
        "free -h  OR  vm_stat: free -h = Linux. vm_stat = macOS. Look at 'available', not just 'free'." \
        'chk "^(free( -[a-zA-Z]+)?|vm_stat)$"' 15

    run_challenge "System Uptime and Load" \
        "Show how long the system has been running and the current CPU load averages.\n\n  Load average: three numbers = 1 min, 5 min, 15 min average. Rule of thumb: load > number of CPU cores = system is under pressure." \
        "uptime: shows: current time, uptime duration, logged-in users, load averages (1/5/15 min)" \
        'exact "uptime"' 10

    run_challenge "List Open Files" \
        "List all open file descriptors on the system (what files/sockets are currently in use).\n\n  ${CYAN}lsof${NC} = List Open Files. Everything in Linux is a file, network connections, pipes, devices. lsof answers: 'what process has this port open?' or 'what's holding this file open?'" \
        "lsof  OR  lsof -i: lsof lists all. -i = network connections only. -p PID = files for one process. -u user = files for one user." \
        'chk "^lsof( -[a-zA-Z0-9:@]+)?$"' 20

    run_challenge "Current Users" \
        "Show who is currently logged into this system and what they are doing.\n\n  On shared servers, multi-tenant systems, or after a security incident, seeing who's logged in is essential. ${CYAN}w${NC} gives more detail than ${CYAN}who${NC}." \
        "w  OR  who: w shows logged-in users + their process, idle time, and load. who shows just the login details." \
        'chk "^(w|who)( -[a-zA-Z]+)?$"' 10

    cleanup_game_env
    level_complete 17
}

# ============================================================
# LEVEL 18: USER MANAGEMENT
# ============================================================

run_level_18() {
    level_intro 18 "User & Group Management" \
        "Linux security is built on users and groups. Every process runs as a user. Every file is owned by a user and a group. Adding users correctly, assigning the right groups, and understanding sudo vs su are fundamental sysadmin tasks. Getting them wrong creates security gaps." \
        "👥   useradd -m  |  usermod -aG  |  passwd  |  groups  |  su -  |  sudo"
    setup_game_env

    run_challenge "Create a User" \
        "Create a new system user called ${YELLOW}deploy${NC} with a home directory.\n\n  ${CYAN}-m${NC} creates the home directory. Without it, no home dir is made, services that expect ${CYAN}~/config${NC} will break. On macOS use ${CYAN}sysadminctl -addUser${NC} or ${CYAN}dscl${NC} instead." \
        "useradd -m deploy: -m creates /home/deploy. Always use -m for human users. For system accounts: useradd -r -s /sbin/nologin serviceuser" \
        'chk "^useradd .+ [a-zA-Z0-9_-]+"' 25

    run_challenge "Set a Password" \
        "Set the password for the ${YELLOW}deploy${NC} user.\n\n  ${CYAN}passwd username${NC} prompts interactively. In scripts use ${CYAN}chpasswd${NC} or ${CYAN}echo 'user:pass' | chpasswd${NC} to avoid interactive prompts." \
        "passwd deploy: interactive password set. In scripts: echo 'deploy:secretpass' | chpasswd" \
        'chk "^passwd [a-zA-Z0-9_-]+"' 20

    run_challenge "Add User to Group" \
        "Add user ${YELLOW}deploy${NC} to the ${YELLOW}sudo${NC} group.\n\n  ${CYAN}CRITICAL: always use -aG, NEVER just -G alone${NC}. The -a means APPEND, without it, -G replaces ALL the user's groups, locking them out of everything else they had access to." \
        "usermod -aG sudo deploy: -a = append, -G = supplementary group. Missing -a removes ALL other group memberships!" \
        'chk "^usermod -[a-zA-Z]*a[a-zA-Z]*G[a-zA-Z]* [a-zA-Z0-9_-]+ [a-zA-Z0-9_-]+|^usermod -aG [a-zA-Z0-9_-]+ [a-zA-Z0-9_-]+"' 25

    run_challenge "Check Group Memberships" \
        "Show all groups that user ${YELLOW}bashuser${NC} belongs to.\n\n  Group membership explains access. If a user can't read a file or run a command, check their groups first." \
        "groups bashuser  OR  id bashuser: groups lists names, id lists both names and GIDs. Try: id -nG username for just group names." \
        'chk "^(groups|id) [a-zA-Z0-9_-]+"' 15

    run_challenge "Switch User (Full Login)" \
        "Switch to the ${YELLOW}deploy${NC} user with a full login shell that loads their complete environment.\n\n  ${CYAN}su - username${NC} (with the dash): runs a login shell that sources .bashrc and .profile. Without the dash you keep your current environment, a common source of 'it works as me but not as deploy' bugs." \
        "su - deploy: the dash matters: it gives a full login shell. su deploy (no dash) = same shell env, just different user." \
        'chk "^su - [a-zA-Z0-9_-]+"' 20

    run_challenge "Sudo a Single Command" \
        "Run the command ${YELLOW}apt update${NC} as root using sudo.\n\n  ${CYAN}sudo${NC} runs ONE command as root (or another user). It logs every command to the auth log. Prefer sudo over su, it provides an audit trail of who ran what." \
        "sudo apt update: logs to /var/log/auth.log. sudo -u username cmd = run as specific user, not just root." \
        'chk "^sudo .+"' 15

    run_challenge "Lock an Account" \
        "Lock the ${YELLOW}deploy${NC} user account to prevent login immediately.\n\n  When an employee leaves or an account is compromised, lock first, it takes effect instantly. Review and delete later after data handover." \
        "usermod -L deploy  OR  passwd -l deploy: -L prefixes ! to the password hash. Check with: passwd -S deploy" \
        'chk "^(usermod -[a-zA-Z]*L[a-zA-Z]* [a-zA-Z0-9_-]+|passwd -l [a-zA-Z0-9_-]+)"' 20

    cleanup_game_env
    level_complete 18
}

# ============================================================
# LEVEL 19: SSH & KEYS
# ============================================================

run_level_19() {
    level_intro 19 "SSH & Key-Based Auth" \
        "SSH is how you control remote servers securely. Password auth is convenient but brute-forceable, key auth is the industry standard and is required by most cloud providers. Your private key is the equivalent of a physical key to your server: protect it with a passphrase, never share it, set strict permissions." \
        "🔑   ssh-keygen -t ed25519  |  chmod 600  |  ssh-copy-id  |  -i key  |  -L tunnel"
    setup_game_env

    run_challenge "Generate an ED25519 Key Pair" \
        "Generate a new SSH key pair using the ${YELLOW}ed25519${NC} algorithm with your email as the comment.\n\n  ${CYAN}ED25519${NC} is the modern standard, smaller keys, faster operations, and stronger security than RSA 2048. Always add a comment (-C) so you can identify which key is which across multiple servers." \
        "ssh-keygen -t ed25519 -C 'you@example.com': creates ~/.ssh/id_ed25519 (private) and id_ed25519.pub (public). Add -f to specify filename." \
        'chk "^ssh-keygen .+"' 25

    run_challenge "Fix Key Permissions" \
        "Your private key ${YELLOW}~/.ssh/id_ed25519${NC} has permissions 644. SSH will refuse to use it. Fix them.\n\n  ${CYAN}SSH enforces strict permissions${NC} on key files. If the private key is readable by others, SSH considers it compromised and refuses to load it, a deliberate security feature." \
        "chmod 600 ~/.ssh/id_ed25519: private keys must be 600 (owner read/write only). ~/.ssh dir should be 700." \
        'chk "^chmod 600 .+|^chmod 700 .ssh"' 20

    run_challenge "Copy Public Key to Server" \
        "Enable password-less login to ${YELLOW}admin@192.168.1.50${NC} by copying your public key there.\n\n  ${CYAN}ssh-copy-id${NC} appends your public key to the server's ${CYAN}~/.ssh/authorized_keys${NC} file, creating it with correct permissions if needed. Doing this manually is error-prone." \
        "ssh-copy-id admin@192.168.1.50: reads ~/.ssh/id_ed25519.pub and appends it to the server's authorized_keys" \
        'chk "^ssh-copy-id .+"' 25

    run_challenge "Connect with a Specific Key" \
        "SSH to ${YELLOW}admin@192.168.1.50${NC} using a specific key file ${YELLOW}~/.ssh/deploy_key${NC} instead of the default.\n\n  ${CYAN}-i${NC} specifies which identity (private key) file to use. When you manage many servers, each gets its own key, use -i to select the right one." \
        "ssh -i ~/.ssh/deploy_key admin@192.168.1.50: -i = identity file. Pair with ~/.ssh/config Host entries to avoid typing -i every time." \
        'chk "^ssh -i .+ .+@.+"' 25

    run_challenge "SSH Config Shortcut" \
        "Create an SSH config entry so ${YELLOW}ssh webserver${NC} connects to ${YELLOW}admin@192.168.1.50${NC} automatically.\n\n  ${CYAN}~/.ssh/config${NC} stores named host profiles: alias, hostname, user, port, and which key to use. This file saves enormous amounts of typing on systems with many servers." \
        "cat >> ~/.ssh/config  then add: Host webserver / Hostname 192.168.1.50 / User admin: one block per host. Then: ssh webserver just works." \
        'chk "^(cat|echo).+~/.ssh/config|^ssh webserver$|^nano ~/.ssh/config$"' 20

    run_challenge "Local Port Forwarding (Tunnel)" \
        "Forward your local port ${YELLOW}8080${NC} to port ${YELLOW}80${NC} on server ${YELLOW}192.168.1.50${NC} through SSH.\n\n  ${CYAN}SSH tunnelling${NC} lets you securely access services behind firewalls. After this, ${CYAN}localhost:8080${NC} in your browser reaches the server's web server, through the encrypted SSH connection." \
        "ssh -L 8080:localhost:80 admin@192.168.1.50: -L localport:remotehost:remoteport. After connecting, browse to localhost:8080." \
        'chk "^ssh -L .+:.+:.+ .+"' 30

    cleanup_game_env
    level_complete 19
}

# ============================================================
# LEVEL 20: ENVIRONMENT & SHELL CONFIG
# ============================================================

run_level_20() {
    level_intro 20 "Environment & Shell Configuration" \
        "Your shell environment controls how the terminal works, where commands are found (PATH), what shortcuts exist (aliases), what your prompt looks like (PS1), and which variables child processes inherit (export). These settings live in ~/.bashrc or ~/.zshrc and are loaded every time you open a terminal." \
        "🌍   PATH  |  export  |  alias  |  source  |  .bashrc  |  .profile  |  PS1"
    setup_game_env

    run_challenge "View PATH" \
        "Print your current PATH, the colon-separated list of directories where the shell searches for commands.\n\n  ${CYAN}'command not found'${NC} almost always means the program exists but isn't in a PATH directory. Knowing your PATH lets you diagnose this in 5 seconds." \
        "echo \$PATH: PATH is colon-separated: /usr/local/bin:/usr/bin:/bin. Commands are found by searching each in order." \
        'chk "^echo \\\$PATH$"' 15

    run_challenge "Prepend to PATH" \
        "Add ${YELLOW}/usr/local/mytools${NC} to the BEGINNING of your PATH for this session.\n\n  ${CYAN}Prepend${NC} so your version takes priority over system versions. ${CYAN}Append${NC} if you want system defaults to win. Always include :\$PATH to preserve existing entries." \
        "export PATH=/usr/local/mytools:\$PATH: prepend = your dir is searched first. export = available to child processes." \
        'chk "^export PATH=.+:\\\$PATH$|^PATH=.+:\\\$PATH"' 25

    run_challenge "Create an Alias" \
        "Create an alias ${YELLOW}ll${NC} that expands to ${YELLOW}ls -lah${NC}.\n\n  ${CYAN}Aliases${NC} are shell shortcuts, simple command replacements. For shortcuts needing arguments, use functions instead. Make aliases permanent by adding them to ~/.bashrc." \
        "alias ll='ls -lah': alias name='command'. Permanent: add to ~/.bashrc then source it. List all aliases: alias (no args)" \
        'chk "^alias [a-zA-Z_]+=.+"' 20

    run_challenge "Export a Variable" \
        "Set ${YELLOW}EDITOR=vim${NC} and export it so child processes (like git) can see it.\n\n  ${CYAN}export${NC} marks a variable for inheritance by child processes. Without export, variables are local to the current shell, git, make, and other tools won't see them." \
        "export EDITOR=vim: without export: var is local shell only. With export: child processes inherit it." \
        'chk "^export [A-Z_]+=.+"' 20

    run_challenge "Source a Config File" \
        "Apply changes from ${YELLOW}~/.bashrc${NC} to the current session without logging out.\n\n  ${CYAN}source${NC} runs the file in the CURRENT shell, so new aliases, exports, and functions take effect immediately. The shorthand ${CYAN}. ~/.bashrc${NC} is identical. A subshell (bash ~/.bashrc) wouldn't affect the current session." \
        "source ~/.bashrc  OR  . ~/.bashrc: dot and source are identical. Neither starts a subshell, so changes affect THIS session." \
        'chk "^(source|\.) ~/?.bash"' 15

    run_challenge "Customise the Prompt" \
        "Set your PS1 prompt to show ${YELLOW}user@host:dir\$${NC} format.\n\n  ${CYAN}PS1${NC} is the primary prompt variable. Escape sequences: \\u=username, \\h=short hostname, \\H=FQDN, \\w=working dir, \\W=basename only, \\$=$ for users, # for root." \
        "export PS1='\\u@\\h:\\w\\\$ ': always wrap color codes in \\[ ... \\] to prevent line length miscalculation." \
        'chk "^export PS1=.+"' 20

    cleanup_game_env
    tier_complete 20 "Power Tools" \
        "Disk diagnostics, system info, user management, SSH key auth, and a shell environment you actually control. If a server handed you a login prompt right now, you'd know exactly where to start looking." \
        "Tier 5: Expert: cron, log investigation, packages, compression, and the bash internals that make scripts production-grade."
}

# ============================================================
# LEVEL 21: CRON & SCHEDULING
# ============================================================

run_level_21() {
    level_intro 21 "Cron & Scheduling" \
        "Cron runs commands at set times automatically, every backup, cleanup, health check, and report on a server is cron-driven. The crontab format is: MIN HOUR DAY MONTH WEEKDAY command. Each field has wildcards (*), ranges (1-5), steps (*/15), and lists (1,3,5). Getting cron syntax wrong silently does nothing, so test carefully." \
        "⏰   crontab -l  -e  -r  |  * * * * *  |  at  |  /etc/cron.d"
    setup_game_env

    run_challenge "List Cron Jobs" \
        "List all cron jobs for the current user.\n\n  Before adding a new cron job, always list existing ones, to avoid duplication or conflicts. ${CYAN}crontab -l${NC} prints the current crontab. ${CYAN}crontab -e${NC} opens it in your editor. ${CYAN}crontab -r${NC} removes it entirely (dangerous, no confirmation!)." \
        "crontab -l: list. crontab -e = edit. crontab -r = REMOVE ALL (no undo). crontab -u user = act on another user's crontab (root only)" \
        'chk "^crontab -[a-zA-Z]"' 15

    run_challenge "Every Minute" \
        "Write the crontab line to run ${YELLOW}/usr/local/bin/check.sh${NC} every minute.\n\n  ${CYAN}* * * * *${NC}, five stars = every minute of every hour of every day. Format: MIN HOUR DAY MONTH WEEKDAY. Cron's minimum resolution is 1 minute." \
        "* * * * * /usr/local/bin/check.sh: * = any value in that field. Five stars = run every minute always." \
        'chk "^\* \* \* \* \* .+"' 25

    run_challenge "Daily at 2am" \
        "Write the crontab line to run ${YELLOW}/usr/local/bin/backup.sh${NC} every day at 2:00am.\n\n  ${CYAN}0 2 * * *${NC}, minute 0 (on the hour), hour 2, any day/month/weekday. Remember: minute comes FIRST, then hour, the opposite of how we speak ('2 o'clock' = hour 2, minute 0)." \
        "0 2 * * * /usr/local/bin/backup.sh: 0 2 = minute:0, hour:2 = 02:00. The remaining * fields mean any day/month/weekday." \
        'chk "^0 2 \* \* \* .+"' 25

    run_challenge "Every 15 Minutes" \
        "Write the crontab line to run ${YELLOW}/usr/local/bin/sync.sh${NC} every 15 minutes.\n\n  ${CYAN}*/15${NC} means 'every 15 steps', the / operator in cron defines a step. */15 in the minute field = minutes 0, 15, 30, 45." \
        "*/15 * * * * /usr/local/bin/sync.sh: */N = every N units. */15 = at 0,15,30,45. */2 in hours = every 2 hours." \
        'chk "^\*/[0-9]+ \* \* \* \* .+"' 25

    run_challenge "Weekdays Only" \
        "Run ${YELLOW}/usr/local/bin/report.sh${NC} at 9:00am Monday through Friday only.\n\n  The 5th cron field is the day-of-week: 0=Sunday, 1=Monday, 5=Friday, 6=Saturday (0 and 7 both mean Sunday). Ranges work: 1-5 = Monday to Friday." \
        "0 9 * * 1-5 /usr/local/bin/report.sh: weekday field 1-5 = Mon-Fri. Use 0 or 7 for Sunday. Use 1,3,5 for Mon/Wed/Fri." \
        'chk "^0 9 \* \* 1-5 .+"' 25

    run_challenge "One-Time Future Task" \
        "Schedule ${YELLOW}/usr/local/bin/restart.sh${NC} to run once at ${YELLOW}11pm tonight${NC}.\n\n  ${CYAN}at${NC} is for one-time scheduled commands, unlike cron which repeats. ${CYAN}atq${NC} lists pending at jobs. ${CYAN}atrm N${NC} removes one." \
        "echo '/usr/local/bin/restart.sh' | at 23:00  OR  at 11pm: at schedules one-time tasks. atq = queue, atrm = remove." \
        'chk ".*at [0-9]|.*at [0-9]+(am|pm)"' 20

    cleanup_game_env
    level_complete 21
}

# ============================================================
# LEVEL 22: LOGS & MONITORING
# ============================================================

run_level_22() {
    level_intro 22 "Logs & Monitoring" \
        "When something breaks at 3am, logs are your flashlight. Knowing how to tail a live log, filter it in real time with grep, and query the systemd journal for specific services and time windows makes the difference between a quick fix and a hours-long mystery. These are the commands you'll use in every incident." \
        "📋   tail -f  |  tail -f | grep --line-buffered  |  journalctl  |  logger"
    setup_game_env

    run_challenge "Follow a Log Live" \
        "Watch ${YELLOW}var/log/error.log${NC} in real-time, seeing new lines as they're written.\n\n  ${CYAN}tail -f${NC} (follow) stays running and prints new lines as they arrive, it's how you watch a deployment, monitor a service restart, or watch for errors during a load test. Ctrl+C to stop." \
        "tail -f var/log/error.log: -f = follow. The most-used command during incidents. Combine with grep for filtering." \
        'chk "^tail -[a-zA-Z]*f[a-zA-Z]* .+"' 20

    run_challenge "Follow with Live Filter" \
        "Watch ${YELLOW}var/log/error.log${NC} live but only show lines containing ${YELLOW}ERROR${NC}.\n\n  ${CYAN}grep --line-buffered${NC} is essential here, without it, grep buffers output and ERROR lines might not appear until the buffer fills. The flag forces line-by-line output." \
        "tail -f var/log/error.log | grep --line-buffered 'ERROR': --line-buffered prevents grep from holding output in its internal buffer" \
        'chk ".*tail -[a-zA-Z]*f[a-zA-Z]* .+\| *grep .+"' 25

    run_challenge "journalctl Overview" \
        "Show all system log entries from the systemd journal.\n\n  ${CYAN}journalctl${NC} is the modern replacement for reading /var/log/syslog or /var/log/messages on systemd distros. It's structured, searchable, persistent across reboots, and much faster to query than raw text files." \
        "journalctl: shows all entries. -n 50 = last 50 lines. -f = follow live. --since '1 hour ago' = time filter. -b = this boot only." \
        'chk "^journalctl( -[a-zA-Z]+.*)?$"' 15

    run_challenge "Filter by Service" \
        "Show logs for the ${YELLOW}sshd${NC} service only.\n\n  ${CYAN}-u${NC} (unit) filters by systemd service name, far faster than grepping /var/log/auth.log manually. Includes service start/stop events that raw log files miss." \
        "journalctl -u sshd: -u = unit (service name). Add -f to follow live: journalctl -fu sshd" \
        'chk "^journalctl -[a-zA-Z]*u[a-zA-Z]* [a-zA-Z0-9._-]+"' 20

    run_challenge "Time-Based Filter" \
        "Show journal entries from the last hour only.\n\n  ${CYAN}--since${NC} accepts natural language and ISO formats. Combine with ${CYAN}--until${NC} for a time window. Essential for incident investigation: 'show me everything that happened between 02:00 and 02:30'." \
        "journalctl --since '1 hour ago': --since accepts: 'today', 'yesterday', '2024-01-15 08:00', '1 hour ago'" \
        'chk "^journalctl --since .+"' 20

    run_challenge "Write to System Log" \
        "Write the message ${YELLOW}Deployment complete${NC} to the system log from a shell script.\n\n  ${CYAN}logger${NC} writes directly to syslog. Use it in your scripts so deployment events, backups, and custom health checks appear in journalctl alongside system events, one place to look for everything." \
        "logger 'Deployment complete': add -t TAG to label it (e.g. -t deploy). Visible in journalctl and /var/log/syslog." \
        'chk "^logger .+"' 15

    cleanup_game_env
    level_complete 22
}

# ============================================================
# LEVEL 23: PACKAGE MANAGEMENT
# ============================================================

run_level_23() {
    level_intro 23 "Package Management" \
        "Every Linux distro has a package manager, the system for safely installing, updating, and removing software with dependency resolution. apt for Debian/Ubuntu. dnf/yum for RHEL/Fedora/CentOS. pacman for Arch. brew for macOS. The concepts are the same; only the commands differ." \
        "📦   apt  |  dnf / yum  |  brew  |  update  install  remove  search  show"
    setup_game_env

    run_challenge "Update Package Index" \
        "Refresh the local list of available packages on a Debian/Ubuntu system.\n\n  ${CYAN}apt update${NC} fetches the latest package metadata from repositories, it does NOT install or upgrade anything. Always run it before installing, or you risk getting outdated versions." \
        "sudo apt update: fetches package lists. Does NOT change installed packages. Run before every install or upgrade." \
        'chk "^sudo apt(-get)? update$"' 15

    run_challenge "Upgrade All Packages" \
        "Upgrade all installed packages to their latest available versions on Ubuntu.\n\n  ${CYAN}apt upgrade${NC} installs new versions of packages already installed. ${CYAN}full-upgrade${NC} also handles packages that need to be removed to complete an upgrade." \
        "sudo apt upgrade  OR  sudo apt full-upgrade: upgrade = safe updates. full-upgrade = handles dependency changes too." \
        'chk "^sudo apt(-get)? (upgrade|full-upgrade|dist-upgrade)$"' 20

    run_challenge "Install a Package" \
        "Install the package ${YELLOW}htop${NC} non-interactively (no prompts) on Ubuntu.\n\n  ${CYAN}-y${NC} auto-answers yes, critical in scripts and Dockerfiles where you can't respond interactively. Without -y, apt pauses and waits, hanging your automation." \
        "sudo apt install -y htop: -y = yes to all prompts. In Dockerfiles and scripts ALWAYS use -y." \
        'chk "^sudo apt(-get)? install( -y| -y)? [a-zA-Z0-9_.-]+"' 20

    run_challenge "Search for a Package" \
        "Search for packages related to the keyword ${YELLOW}network${NC}.\n\n  Before installing, search first, the package name isn't always what you'd expect. ${CYAN}apt search${NC} searches both package names and descriptions." \
        "apt search network  OR  apt-cache search network: searches names and descriptions. Use grep to filter: apt search network | grep monitor" \
        'chk "^(apt|apt-cache) search [a-zA-Z0-9_.-]+"' 15

    run_challenge "Show Package Details" \
        "Show detailed information about the ${YELLOW}curl${NC} package, version, dependencies, size, description.\n\n  Check this before installing unfamiliar packages to understand their size, what they depend on, and whether they're the right tool." \
        "apt show curl  OR  apt-cache show curl: shows version, installed-size, depends, description, maintainer, homepage" \
        'chk "^apt(-cache)? show [a-zA-Z0-9_.-]+"' 15

    run_challenge "Remove a Package" \
        "Remove ${YELLOW}htop${NC} but keep its configuration files (in case you reinstall later).\n\n  ${CYAN}remove${NC} deletes the binary but keeps config. ${CYAN}purge${NC} also removes config files. If you're troubleshooting and might reinstall, use remove, purge if you're done permanently." \
        "sudo apt remove htop: keeps /etc config. Use 'purge' to also delete configs. 'autoremove' cleans orphaned dependencies." \
        'chk "^sudo apt(-get)? remove [a-zA-Z0-9_.-]+"' 20

    run_challenge "RHEL / Fedora Install" \
        "Install ${YELLOW}htop${NC} on a Red Hat Enterprise Linux or Fedora system.\n\n  ${CYAN}dnf${NC} is the modern replacement for ${CYAN}yum${NC} on RHEL 8+/Fedora. Same -y flag, same concepts, different package repositories." \
        "sudo dnf install -y htop  OR  sudo yum install -y htop: dnf = RHEL 8+/Fedora. yum = RHEL 7/CentOS. brew = macOS." \
        'chk "^sudo (dnf|yum) install( -y)? [a-zA-Z0-9_.-]+"' 20

    cleanup_game_env
    level_complete 23
}

# ============================================================
# LEVEL 24: COMPRESSION DEEP DIVE
# ============================================================

run_level_24() {
    level_intro 24 "Compression Deep Dive" \
        "Different formats trade speed for compression ratio. gzip is the universal Linux standard, fast, widely supported. bzip2 compresses better but is slower. xz achieves the best ratio and is used for Linux kernel releases and package archives. zip for Windows compatibility. Know when to use each." \
        "🗜️   gzip  gunzip  zcat  |  bzip2  bunzip2  |  xz  |  zip  unzip  |  -k keep"
    setup_game_env

    run_challenge "gzip a File" \
        "Compress ${YELLOW}home/welcome.txt${NC} with gzip.\n\n  ${CYAN}gzip${NC} replaces the original with a .gz file. Use ${CYAN}-k${NC} to keep the original. Typical ratios: 60-70% reduction on text. Used for log rotation, web transfer (Content-Encoding: gzip), and data pipelines." \
        "gzip home/welcome.txt: creates welcome.txt.gz, REMOVES original. Use -k to keep: gzip -k home/welcome.txt" \
        'chk "^gzip( -[a-zA-Z0-9]+)* .+"' 20

    run_challenge "Decompress gzip" \
        "Decompress ${YELLOW}home/welcome.txt.gz${NC} back to the original.\n\n  ${CYAN}gunzip${NC} and ${CYAN}gzip -d${NC} are identical. The -k flag works here too to keep the .gz file." \
        "gunzip home/welcome.txt.gz  OR  gzip -d home/welcome.txt.gz: gunzip restores the original, removes the .gz" \
        'chk "^(gunzip|gzip -d) .+"' 15

    run_challenge "Read Compressed Without Extracting" \
        "Read the contents of a .gz file without decompressing it to disk.\n\n  ${CYAN}zcat${NC} pipes decompressed content to stdout, perfect for grepping compressed log archives without storing uncompressed data. Also: zgrep, zless work directly on .gz files." \
        "zcat home/welcome.txt.gz  OR  gzip -dc home/welcome.txt.gz: zcat/zgrep/zless work on .gz files directly" \
        'chk "^(zcat|gzip -dc|zless|zgrep) .+"' 20

    run_challenge "bzip2" \
        "Compress ${YELLOW}home/scores.txt${NC} with bzip2.\n\n  ${CYAN}bzip2${NC} typically compresses 10-15% better than gzip but is 2-4x slower. Used for source code tarballs (.tar.bz2) and where compression ratio matters more than speed." \
        "bzip2 home/scores.txt: creates scores.txt.bz2. bunzip2 or bzip2 -d to decompress. bzcat to read compressed." \
        'chk "^bzip2( -[a-zA-Z0-9]+)* .+"' 20

    run_challenge "xz Maximum Compression" \
        "Compress ${YELLOW}home/scores.txt${NC} with xz.\n\n  ${CYAN}xz${NC} achieves the best compression ratio of common Linux formats, the Linux kernel .tar.xz is ~30% smaller than .tar.gz. The trade-off is it's significantly slower. Use for archives you'll store long-term." \
        "xz home/scores.txt  OR  xz -9 home/scores.txt: -9 = maximum compression (slowest). xzcat/unxz to decompress." \
        'chk "^xz( -[0-9a-zA-Z]+)* .+"' 20

    run_challenge "zip for Cross-Platform" \
        "Create a zip archive of the ${YELLOW}home${NC} directory named ${YELLOW}backup.zip${NC}.\n\n  ${CYAN}zip${NC} is the right choice when sharing with Windows users, they have built-in zip support but not tar.gz. ${CYAN}unzip${NC} to extract. ${CYAN}zip -e${NC} for encrypted archives." \
        "zip -r backup.zip home/: -r = recursive. zip is cross-platform. unzip backup.zip to extract, unzip -l to list contents." \
        'chk "^zip -[a-zA-Z]*r[a-zA-Z]* .+ .+"' 20

    run_challenge "tar with xz (Best Practice)" \
        "Create a tar archive of the ${YELLOW}home${NC} directory compressed with xz, named ${YELLOW}home.tar.xz${NC}.\n\n  ${CYAN}tar -cJf${NC}: J flag selects xz compression (j = bzip2, z = gzip, J = xz). The .tar.xz format is the Linux gold standard for software distribution." \
        "tar -cJf home.tar.xz home/: J = xz. z = gzip (.tar.gz). j = bzip2 (.tar.bz2). All combine archive+compress in one step." \
        'chk "^tar -[cJjz]*J[cJjz]* .+ .+|^tar .*-J.* .+"' 25

    cleanup_game_env
    level_complete 24
}

# ============================================================
# LEVEL 25: STRING PROCESSING
# ============================================================

run_level_25() {
    level_intro 25 "Bash String Processing" \
        "Bash has powerful built-in string manipulation, no external process needed, no subshell overhead. Substring extraction, length, pattern stripping, and search-and-replace are all built into the parameter expansion syntax \${...}. Combined with printf, you can format output precisely. These features make scripts lean and fast." \
        "🔡   \${#v}  \${v:off:len}  \${v%pat}  \${v%%pat}  \${v#pat}  \${v##pat}  \${v//f/r}  \${v^^}"
    setup_game_env

    run_challenge "String Length" \
        "Given the variable ${YELLOW}WORD=BashQuest${NC}, print the number of characters without calling any external command.\n\n  ${CYAN}\${#var}${NC}, the hash prefix gives the length. Pure shell, no subshell. Far faster than echo \$var | wc -c in a loop." \
        "WORD=BashQuest; echo \${#WORD}: \${#varname} = character count. Works for any variable. \${#array[@]} = array element count." \
        'chk ".*\\\$\{#[a-zA-Z_][a-zA-Z0-9_]*\}"' 25

    run_challenge "Substring Extraction" \
        "Extract the first 4 characters of ${YELLOW}WORD=BashQuest${NC}.\n\n  ${CYAN}\${var:offset:length}${NC}, offset is zero-based. ${CYAN}\${var: -4}${NC} (space before minus) gives the last 4 chars. No external command needed." \
        "WORD=BashQuest; echo \${WORD:0:4}: :0:4 = start at char 0, take 4 chars. \${var: -3} = last 3 chars (note the space)." \
        'chk ".*\\\$\{[a-zA-Z_][a-zA-Z0-9_]*:[0-9]"' 25

    run_challenge "Strip Suffix (short)" \
        "Given ${YELLOW}FILE=report.tar.gz${NC}, strip the ${YELLOW}.gz${NC} extension to get ${YELLOW}report.tar${NC}.\n\n  ${CYAN}\${var%pattern}${NC} strips the SHORTEST match from the END. ${CYAN}\${var%%pattern}${NC} strips the LONGEST. The % pattern is glob syntax (not regex)." \
        "FILE=report.tar.gz; echo \${FILE%.gz}: % strips shortest suffix. %%.* would strip .tar.gz (longest .*)" \
        'chk ".*\\\$\{[a-zA-Z_][a-zA-Z0-9_]*%[^}]"' 25

    run_challenge "Strip Directory from Path" \
        "Given ${YELLOW}FULL=/home/tony/scripts/bashquest.sh${NC}, extract just the filename.\n\n  ${CYAN}\${var##pattern}${NC} strips the LONGEST match from the START. ${CYAN}##*/#{NC} removes everything up to and including the last slash, equivalent to basename." \
        "FULL=/home/tony/scripts/bashquest.sh; echo \${FULL##*/}: ## strips longest prefix. ##*/ = everything up to last /." \
        'chk ".*\\\$\{[a-zA-Z_][a-zA-Z0-9_]*##[^}]"' 25

    run_challenge "Search and Replace (all)" \
        "Given ${YELLOW}TEXT='the cat sat on the cat mat'${NC}, replace ALL occurrences of ${YELLOW}cat${NC} with ${YELLOW}dog${NC}.\n\n  ${CYAN}\${var//find/replace}${NC}, double slash replaces ALL occurrences. Single slash ${CYAN}\${var/find/replace}${NC} replaces only the first." \
        "TEXT='the cat sat on the cat mat'; echo \${TEXT//cat/dog}: // = all occurrences. / = first only." \
        'chk ".*\\\$\{[a-zA-Z_][a-zA-Z0-9_]*//"' 25

    run_challenge "Uppercase Conversion" \
        "Convert the value of ${YELLOW}NAME=bashquest${NC} to uppercase without using tr or awk.\n\n  ${CYAN}\${var^^}${NC} converts all characters to uppercase (bash 4+). ${CYAN}\${var,,}${NC} lowercases. ${CYAN}\${var^}${NC} capitalises the first character only.\n  ${DIM}Note: macOS ships bash 3.2 where ^^ is unavailable, use tr 'a-z' 'A-Z' there.${NC}" \
        "NAME=bashquest; echo \${NAME^^}: bash 4+ only. macOS/bash3 alternative: echo \$NAME | tr 'a-z' 'A-Z'" \
        'chk ".*\\\$\{[a-zA-Z_][a-zA-Z0-9_]*\^\^?\}"' 20

    run_challenge "printf Formatting" \
        "Print the number ${YELLOW}3.14159265${NC} rounded to exactly 2 decimal places using printf.\n\n  ${CYAN}printf '%.2f'${NC}, printf gives precise output control. %.2f = float with 2 decimal places. %d = integer, %s = string, %10s = 10-char right-aligned, %-10s = left-aligned." \
        "printf '%.2f\\n' 3.14159265: %.2f = 2 decimal places. printf is far more precise than echo for formatted output." \
        'chk "^printf .+%.*f.+ [0-9]+\.[0-9]+"' 20

    cleanup_game_env
    level_complete 25
}

# ============================================================
# LEVEL 26: ARRAYS IN BASH
# ============================================================

run_level_26() {
    level_intro 26 "Arrays in Bash" \
        "Arrays store multiple values in a single variable. Bash supports indexed arrays (zero-based integers) and associative arrays (string keys, like dictionaries). Arrays are essential for iterating over server lists, storing config values, processing argument lists, and building commands dynamically without string splitting issues." \
        "📚   arr=(a b c)  \${arr[0]}  \${arr[@]}  \${#arr[@]}  +=  declare -A"
    setup_game_env

    run_challenge "Create an Array" \
        "Create an indexed array called ${YELLOW}SERVERS${NC} containing three values: ${YELLOW}web01 web02 db01${NC}.\n\n  ${CYAN}()${NC} groups elements, spaces separate them. No commas, bash uses spaces, not commas. Quote elements that contain spaces." \
        "SERVERS=(web01 web02 db01): parentheses + space-separated. No commas. Quote elements with spaces: ('web 01' 'web 02')" \
        'chk "^[A-Z_]+=\([a-zA-Z0-9_.\" -]+\)$"' 20

    run_challenge "Access One Element" \
        "Print the first element of ${YELLOW}SERVERS=(web01 web02 db01)${NC}.\n\n  ${CYAN}\${arr[0]}${NC}, zero-indexed. Curly braces are REQUIRED: \$arr[0] doesn't work (gives you literal '[0]' appended to \$arr's value)." \
        "SERVERS=(web01 web02 db01); echo \${SERVERS[0]}: zero-indexed. Curly braces required for array access." \
        'chk ".*\\\$\{[A-Z_]+\[[0-9]+\]\}"' 20

    run_challenge "All Elements" \
        "Print ALL elements of ${YELLOW}SERVERS=(web01 web02 db01)${NC} as separate words.\n\n  ${CYAN}\${arr[@]}${NC} expands to all elements as separate words (safe for loops). ${CYAN}\${arr[*]}${NC} joins all into one string, dangerous in loops if elements have spaces. Always use @ in for loops." \
        "SERVERS=(web01 web02 db01); echo \${SERVERS[@]}: @ = all as separate words. Always use @ not * in loops." \
        'chk ".*\\\$\{[A-Z_]+\[@\]\}"' 20

    run_challenge "Array Length" \
        "Print how many elements are in ${YELLOW}SERVERS=(web01 web02 db01)${NC}.\n\n  ${CYAN}\${#arr[@]}${NC}, combine the # (length) operator with [@] (all elements). This gives element count, not string length." \
        "SERVERS=(web01 web02 db01); echo \${#SERVERS[@]}: \${#arr[@]} = element count. \${#arr[0]} = string length of first element." \
        'chk ".*\\\$\{#[A-Z_]+\[@\]\}"' 25

    run_challenge "Loop Over an Array" \
        "Loop over ${YELLOW}SERVERS=(web01 web02 db01)${NC} and print each server name.\n\n  ${CYAN}for item in \"\${arr[@]}\"${NC}, quoting \"\${arr[@]}\" is critical: it preserves elements with spaces as single items. Unquoted, spaces in elements would split them into separate words." \
        'SERVERS=(web01 web02 db01); for s in "${SERVERS[@]}"; do echo $s; done: always quote "${arr[@]}" in for loops' \
        'chk "^for .+in .*\\\$\{[A-Z_]+\[@\]\}.*; *do .+done$"' 25

    run_challenge "Append to Array" \
        "Add ${YELLOW}db02${NC} to the end of ${YELLOW}SERVERS=(web01 web02 db01)${NC}.\n\n  ${CYAN}arr+=(element)${NC} appends without removing existing elements. You can append multiple at once: arr+=(e1 e2 e3)." \
        "SERVERS=(web01 web02 db01); SERVERS+=(db02): += appends element(s). Direct index: SERVERS[3]=db02 also works." \
        'chk ".*[A-Z_]+=\+?\([a-zA-Z0-9_]+\)"' 20

    run_challenge "Associative Array" \
        "Create an associative array ${YELLOW}PORTS${NC} mapping ${YELLOW}http${NC} → ${YELLOW}80${NC} and ${YELLOW}https${NC} → ${YELLOW}443${NC}.\n\n  ${CYAN}declare -A${NC} is required for associative arrays (bash 4+). String keys instead of integer indices. Access with \${PORTS[http]}." \
        "declare -A PORTS=([http]=80 [https]=443)  OR  declare -A PORTS; PORTS[http]=80; PORTS[https]=443" \
        'chk "^declare -A .+"' 25

    cleanup_game_env
    level_complete 26
}

# ============================================================
# LEVEL 27: FUNCTIONS & ERROR HANDLING
# ============================================================

run_level_27() {
    level_intro 27 "Functions & Error Handling" \
        "Production-grade scripts don't silently fail. They catch errors, clean up temp files, and exit with meaningful status codes. set -e, set -u, set -o pipefail, and trap form the standard safety net. Functions encapsulate reusable logic and communicate success or failure through exit codes, exactly like commands." \
        "🛡️   function  \$?  return  set -euo pipefail  trap  exit  \$1 \$2 \$@"
    setup_game_env

    run_challenge "Define a Function" \
        "Define a bash function called ${YELLOW}greet${NC} that accepts a name argument and prints ${YELLOW}Hello, NAME!${NC}.\n\n  ${CYAN}\$1, \$2...${NC} inside a function are the FUNCTION's arguments, not the script's. Functions create their own positional parameter scope." \
        'greet() { echo "Hello, $1!"; }: then call it: greet Tony. Functions share global variables but have their own $1 $2 $@' \
        'chk "^[a-z_]+\(\) *\{.+\}$"' 25

    run_challenge "Check Exit Code" \
        "Run ${YELLOW}ls /nonexistent 2>/dev/null${NC} and immediately check whether it succeeded.\n\n  ${CYAN}\$?${NC} holds the exit code of the last command: 0 = success, non-zero = failure. Check it IMMEDIATELY, it's overwritten after every command. Scripts use if \$? to branch on success/failure." \
        "ls /nonexistent 2>/dev/null; echo \$?: \$?=0 means success. \$?=1 or higher means failure. Check right after the command." \
        'chk ".*echo \\\$\?"' 20

    run_challenge "Exit on Error" \
        "Add the shell option that makes the script exit immediately when any command returns a non-zero exit code.\n\n  ${CYAN}set -e${NC} is the most important script safety option. Without it, a script merrily continues after failures, deleting the wrong directory, deploying broken code, corrupting data." \
        "set -e: exit immediately on any non-zero exit. Can cause issues with commands that intentionally return non-zero (like grep with no match). Use || true to allow those." \
        'chk "^set -[euo]*e[euo]*$"' 20

    run_challenge "Fail on Unset Variables" \
        "Enable the shell option that treats using an unset variable as an error and exits.\n\n  ${CYAN}set -u${NC} prevents the classic bash typo bug: a misspelled variable silently expands to empty string. \${TMPDIR:-/tmp} provides a default value and still works with -u." \
        "set -u: unset variable = fatal error. Use \${var:-default} to provide safe defaults for optional variables." \
        'chk "^set -[euo]*u[euo]*$"' 20

    run_challenge "Catch Pipeline Failures" \
        "Enable the option that makes a pipeline fail if ANY command in it fails, not just the last.\n\n  ${CYAN}set -o pipefail${NC}, by default, 'false | true' returns 0 (success) because only the last command's exit code counts. pipefail catches failures anywhere in the pipe, critical for data pipelines where a corrupt grep result shouldn't look like success." \
        "set -o pipefail: without it: 'false | true' exits 0. With it: 'false | true' exits 1. Always add alongside set -e." \
        'chk "^set -o pipefail$"' 25

    run_challenge "Cleanup with trap" \
        "Set a trap to print ${YELLOW}Cleaning up...${NC} and remove ${YELLOW}/tmp/workdir${NC} whenever the script exits.\n\n  ${CYAN}trap 'commands' EXIT${NC} fires on ANY exit: normal completion, set -e failure, SIGTERM, Ctrl+C. It's the reliable cleanup mechanism, more dependable than trying to clean up in every error path." \
        "trap 'echo Cleaning up...; rm -rf /tmp/workdir' EXIT: EXIT fires on any exit. Also trap specific signals: INT TERM ERR." \
        'chk "^trap .+ EXIT$"' 25

    run_challenge "The Safety Header" \
        "Write the recommended safety header for any serious bash script (set flags on one line).\n\n  ${CYAN}set -euo pipefail${NC} is the industry-standard opening for production scripts: e=exit on error, u=error on unset var, o pipefail=catch pipe failures. Often paired with IFS=\$'\\n\\t' to avoid word-splitting surprises." \
        "set -euo pipefail: the three most important bash safety options combined. Add to every script that runs in production." \
        'chk "^set -[euo]*euo[euo]* *pipefail|^set -euo pipefail$|^set -[euo]+ *&& *set -o pipefail"' 25

    cleanup_game_env
    level_complete 27
}

# ============================================================
# LEVEL 28: SYSTEMD & SERVICES
# ============================================================

run_level_28() {
    level_intro 28 "Systemd & Services" \
        "On modern Linux, systemd manages everything that runs as a service, web servers, databases, cron, SSH, even your desktop. systemctl controls services: start, stop, enable, disable, status, and restart. journalctl reads their logs. If you manage Linux servers, these are the commands you use every single day." \
        "⚙️   systemctl start/stop/enable/disable/status/restart  |  journalctl -u -f  |  unit files"
    setup_game_env

    run_challenge "Check Service Status" \
        "Check whether ${YELLOW}nginx${NC} is running and see its recent log output.\n\n  ${CYAN}systemctl status${NC} gives you: Active state (running/failed/inactive), how long it's been running, its PID and memory usage, and the last 10 log lines. First command to run when a service isn't working." \
        "systemctl status nginx: shows: Active state, PID, memory, last log entries. Exit code: 0=active, 3=inactive, non-0=failed." \
        'chk "^systemctl status [a-zA-Z0-9_.-]+"' 15

    run_challenge "Start a Service" \
        "Start the ${YELLOW}nginx${NC} service right now.\n\n  ${CYAN}start${NC} runs the service immediately but does NOT enable it on boot. After a reboot it stays stopped. Use ${CYAN}enable --now${NC} to do both in one command." \
        "sudo systemctl start nginx: starts now only. Does NOT survive reboot unless also enabled. Check with: systemctl status nginx" \
        'chk "^sudo systemctl start [a-zA-Z0-9_.-]+"' 20

    run_challenge "Enable on Boot" \
        "Enable ${YELLOW}nginx${NC} to start automatically every time the system boots.\n\n  ${CYAN}enable${NC} creates a symlink in the current target's 'wants' directory. ${CYAN}enable --now${NC} is the most common form, it enables AND starts in one command." \
        "sudo systemctl enable nginx  OR  sudo systemctl enable --now nginx: enable = survives reboot. --now also starts immediately." \
        'chk "^sudo systemctl enable( --now)? [a-zA-Z0-9_.-]+"' 20

    run_challenge "Restart After Config Change" \
        "Restart ${YELLOW}nginx${NC} after you've edited its configuration file.\n\n  ${CYAN}restart${NC} = stop then start (brief downtime). ${CYAN}reload${NC} = send SIGHUP to re-read config without downtime (only works if the service supports it). For nginx: reload is preferred in production." \
        "sudo systemctl restart nginx  OR  sudo systemctl reload nginx: reload is zero-downtime if the service supports it" \
        'chk "^sudo systemctl re(start|load) [a-zA-Z0-9_.-]+"' 20

    run_challenge "Stop and Disable" \
        "Stop ${YELLOW}nginx${NC} AND prevent it from starting on next boot in one efficient way.\n\n  Stopping alone leaves it enabled, it will restart on next reboot. ${CYAN}disable --now${NC} disables boot start AND stops immediately." \
        "sudo systemctl disable --now nginx: --now also stops the service. Without --now: disabled but still running until next reboot." \
        'chk "^sudo systemctl disable( --now)? [a-zA-Z0-9_.-]+"' 20

    run_challenge "Live Service Logs" \
        "Follow the live log output of ${YELLOW}nginx${NC} as new entries arrive.\n\n  ${CYAN}-f${NC} (follow) + ${CYAN}-u${NC} (unit) is the most-used journalctl combination, watch a specific service's logs stream in real time during a deployment or incident." \
        "journalctl -fu nginx: -f=follow live, -u=unit (service). Add --since '5 min ago' to start from recent history." \
        'chk "^journalctl -[a-zA-Z]*f[a-zA-Z]*u[a-zA-Z]* [a-zA-Z0-9_.-]+|^journalctl -[a-zA-Z]*u[a-zA-Z]*f[a-zA-Z]* [a-zA-Z0-9_.-]+"' 25

    run_challenge "List Failed Services" \
        "Show all systemd units that are currently in a FAILED state.\n\n  ${CYAN}--state=failed${NC} quickly shows everything that's broken on the system. After a reboot or deploy, run this as your first health check." \
        "systemctl --state=failed  OR  systemctl list-units --state=failed: shows only failed units. Fix: systemctl reset-failed after resolving the issue." \
        'chk "^systemctl.*--state=failed|^systemctl list-units.*failed"' 20

    run_challenge "Write a Service Unit File" \
        "Show the command to create a systemd unit file for a service that runs ${YELLOW}/usr/local/bin/myapp${NC}.\n\n  Unit files live in ${YELLOW}/etc/systemd/system/${NC}. After creating/editing: ${CYAN}systemctl daemon-reload${NC} to pick up changes. A minimal unit needs [Unit], [Service] with ExecStart=, and [Install] with WantedBy=." \
        "cat > /etc/systemd/system/myapp.service <<EOF: after writing: systemctl daemon-reload && systemctl enable --now myapp" \
        'chk ".*systemd/system/.+\\.service|.*daemon-reload"' 25

    cleanup_game_env
    tier_complete 28 "Expert" \
        "Cron, logs, packages, compression, string processing, arrays, error handling, and systemd. You can now run a Linux box end to end without adult supervision." \
        "Tier 6: Storage & Filesystems: partitioning, filesystems, mounting, and LVM."
}

# ---- TIER 6: STORAGE & FILESYSTEMS ----

run_level_29() {
    level_intro 29 "Disks & Partition Tables" \
        "Before you can format or mount anything, you need to know what's actually attached to the box: which devices exist, how they're partitioned, and what's already living on them. fdisk, parted, blkid, and lsblk each answer a slightly different question, and a real sysadmin reaches for all four before touching a disk." \
        "💽   lsblk -f  |  fdisk -l  |  parted -l  |  blkid  |  /proc/partitions"
    setup_game_env

    run_challenge "Read the Partition Table (fdisk)" \
        "List the partition table of ${YELLOW}/dev/sda${NC} using fdisk.\n\n  ${CYAN}fdisk -l${NC} works on MBR and GPT disks alike. Run without a device to list every disk on the system." \
        "sudo fdisk -l /dev/sda: -l lists the partition table. No device argument lists all disks." \
        'chk "^sudo fdisk -l"' 15

    run_challenge "Read the Partition Table (parted)" \
        "Do the same thing with parted instead of fdisk.\n\n  ${CYAN}parted${NC} handles GPT natively and is the safer choice on disks over 2TB, where MBR runs out of addressing space." \
        "sudo parted -l: -l lists every disk's partition table, GPT included." \
        'chk "^sudo parted -l"' 15

    run_challenge "Identify Filesystem Types" \
        "Find out what filesystem type lives on every block device, without mounting anything.\n\n  Essential before you format or mount a disk you didn't set up yourself, so you don't overwrite live data." \
        "sudo blkid: prints device, UUID, and filesystem TYPE for every block device." \
        'chk "^sudo blkid"' 15

    run_challenge "Filesystem-Aware Block Tree" \
        "Show the block device tree the way lsblk normally does, but with filesystem type and mount point included.\n\n  ${CYAN}-f${NC} adds FSTYPE and MOUNTPOINT columns to the usual tree view." \
        "lsblk -f: -f adds filesystem type, label, UUID, and mountpoint to the tree." \
        'chk "^lsblk -f"' 15

    run_challenge "Read Partitions Straight from the Kernel" \
        "The kernel exposes a live list of every partition it currently knows about. Print it.\n\n  Useful when a tool's cache is stale and you want ground truth straight from the kernel." \
        "cat /proc/partitions: major, minor, block count, and name for every partition the kernel sees." \
        'chk "^cat /proc/partitions"' 15

    cleanup_game_env
    level_complete 29
}

run_level_30() {
    level_intro 30 "Partitioning with parted &amp; fdisk" \
        "Once you know what's on a disk, the next step is carving it up. parted does it in one non-interactive command, fdisk drops you into an interactive prompt where n creates and w writes. Both get used constantly, know both." \
        "✂️   parted mkpart  |  fdisk n/w  |  partprobe"
    setup_game_env

    run_challenge "Create a Partition (parted)" \
        "Create a new primary ext4 partition spanning the whole disk on ${YELLOW}/dev/sdb${NC}.\n\n  parted takes the whole operation as one line: device, action, filesystem hint, start, end." \
        "sudo parted /dev/sdb mkpart primary ext4 0% 100%: mkpart creates it, 0% to 100% uses the entire disk." \
        'chk "^sudo parted /dev/sdb mkpart"' 20

    run_challenge "fdisk: Start a New Partition" \
        "You're inside an interactive fdisk session on /dev/sdb. Type the single letter that starts creating a new partition." \
        "n: n = new partition. fdisk then prompts for partition number, first sector, and last sector." \
        'exact "n"' 10

    run_challenge "fdisk: Write and Exit" \
        "You've finished configuring the new partition inside fdisk. Type the single letter that writes the change to disk and exits.\n\n  Nothing is written until this point, everything before it lives only in memory. ${CYAN}q${NC} quits without saving if you change your mind." \
        "w: w writes the new partition table to disk and exits. q discards changes instead." \
        'exact "w"' 10

    run_challenge "Force the Kernel to Reread the Table" \
        "You just repartitioned ${YELLOW}/dev/sdb${NC} without rebooting. Make the kernel notice the new layout.\n\n  Without this, the kernel keeps using its old, stale view of the partition table until the next reboot." \
        "sudo partprobe /dev/sdb: tells the kernel to reread the partition table. Some kernels need partprobe with no argument instead." \
        'chk "^sudo partprobe"' 15

    run_challenge "Delete a Partition (parted)" \
        "Remove partition number 1 from ${YELLOW}/dev/sdb${NC} using parted.\n\n  ${LRED}Destroys any data on that partition. Always double-check the device and number first.${NC}" \
        "sudo parted /dev/sdb rm 1: rm removes the partition by its number, not its device name." \
        'chk "^sudo parted /dev/sdb rm 1"' 20

    cleanup_game_env
    level_complete 30
}

run_level_31() {
    level_intro 31 "Filesystems &amp; Formatting" \
        "A blank partition is just an empty container until you put a filesystem on it. ext4 is the safe Linux default, xfs shines on large files and databases, and swap gives the kernel somewhere to page memory under pressure." \
        "🧱   mkfs.ext4  |  mkfs.xfs  |  mkswap  |  swapon  |  fsck"
    setup_game_env

    run_challenge "Format as ext4" \
        "Format ${YELLOW}/dev/sdb1${NC} with the ext4 filesystem.\n\n  ext4 is the default, well-understood choice for most Linux partitions: journaled, mature, and forgiving." \
        "sudo mkfs.ext4 /dev/sdb1: mkfs.<type> is shorthand for mkfs -t <type>." \
        'chk "^sudo mkfs\\.ext4 /dev/sdb1"' 20

    run_challenge "Format as XFS" \
        "Format ${YELLOW}/dev/sdc1${NC} with XFS instead.\n\n  XFS handles very large files and high-throughput workloads (media servers, databases) better than ext4, at the cost of being harder to shrink later." \
        "sudo mkfs.xfs /dev/sdc1: XFS partitions generally can't be shrunk, only grown, plan sizing accordingly." \
        'chk "^sudo mkfs\\.xfs /dev/sdc1"' 20

    run_challenge "Create a Swap Partition" \
        "Turn ${YELLOW}/dev/sdb2${NC} into a swap partition.\n\n  Swap gives the kernel somewhere to evict idle memory pages under pressure, instead of the OOM killer stepping in immediately." \
        "sudo mkswap /dev/sdb2: prepares the partition's on-disk swap signature, but doesn't activate it yet." \
        'chk "^sudo mkswap /dev/sdb2"' 15

    run_challenge "Activate Swap" \
        "Turn on the swap space you just created on ${YELLOW}/dev/sdb2${NC}.\n\n  mkswap prepares it, swapon actually puts it into use. Add it to /etc/fstab to survive a reboot." \
        "sudo swapon /dev/sdb2: activates the swap partition. Check active swap with swapon --show or free -h." \
        'chk "^sudo swapon /dev/sdb2"' 15

    run_challenge "Check a Filesystem for Errors" \
        "Run a filesystem check on ${YELLOW}/dev/sdb1${NC} and automatically repair anything it finds.\n\n  ${LRED}Never run fsck on a mounted filesystem, unmount it first or you risk corruption.${NC}" \
        "sudo fsck -y /dev/sdb1: -y answers yes to every repair prompt automatically." \
        'chk "^sudo fsck"' 15

    cleanup_game_env
    level_complete 31
}

run_level_32() {
    level_intro 32 "Mounting &amp; /etc/fstab" \
        "A formatted partition still isn't usable until it's mounted somewhere in the filesystem tree. Mount it by hand for a one-off, or add it to /etc/fstab so it comes back automatically on every boot." \
        "📌   mount  |  umount  |  /etc/fstab  |  UUID  |  mount -a"
    setup_game_env

    run_challenge "Mount a Partition" \
        "Mount ${YELLOW}/dev/sdb1${NC} at ${YELLOW}/mnt/data${NC}.\n\n  The mount point directory needs to already exist. Anything that was in it before is hidden, not deleted, until you unmount again." \
        "sudo mount /dev/sdb1 /mnt/data: device first, mount point second." \
        'chk "^sudo mount /dev/sdb1 /mnt/data"' 15

    run_challenge "Unmount It Cleanly" \
        "Unmount ${YELLOW}/mnt/data${NC}.\n\n  If it reports 'target is busy', something still has an open file or working directory inside it, find it with lsof +D /mnt/data." \
        "sudo umount /mnt/data: works with either the mount point or the device path." \
        'chk "^sudo umount"' 15

    run_challenge "Find the UUID for fstab" \
        "Get the UUID of ${YELLOW}/dev/sdb1${NC} so you can reference it safely in /etc/fstab.\n\n  Device names like /dev/sdb1 can shift between boots if disks are added or removed. UUIDs never change, always prefer them in fstab." \
        "sudo blkid /dev/sdb1: prints the UUID, filesystem TYPE, and label for that one device." \
        'chk "^sudo blkid /dev/sdb1"' 15

    run_challenge "Test fstab Without Rebooting" \
        "You just added a new line to /etc/fstab. Verify every entry in it mounts cleanly, without rebooting the box.\n\n  This is the single most useful fstab command: it catches a typo now instead of leaving you staring at a boot that won't finish." \
        "sudo mount -a: mounts everything listed in /etc/fstab that isn't already mounted." \
        'chk "^sudo mount -a"' 20

    run_challenge "Remount Root Read-Write" \
        "The root filesystem came up read-only after a crash. Remount it read-write without unmounting it.\n\n  A read-only root after an unclean shutdown is one of the first things you'll see in a real incident. This gets you back to work immediately." \
        "sudo mount -o remount,rw /: -o remount changes mount options in place, no unmount needed." \
        'chk "^sudo mount -o remount,rw"' 20

    cleanup_game_env
    level_complete 32
}

run_level_33() {
    level_intro 33 "LVM: Volumes &amp; Groups" \
        "Logical Volume Manager adds a layer of abstraction between physical disks and the filesystems on them: physical volumes pool into volume groups, and volume groups carve out logical volumes you can resize on demand. It's how you avoid ever running out of space on a partition you sized wrong three years ago." \
        "🧩   pvcreate  |  vgcreate  |  lvcreate  |  pvs/vgs/lvs"
    setup_game_env

    run_challenge "Create a Physical Volume" \
        "Initialize ${YELLOW}/dev/sdb1${NC} as an LVM physical volume.\n\n  This is the bottom layer of LVM: a raw partition (or whole disk) marked so LVM can pool it into a volume group." \
        "sudo pvcreate /dev/sdb1: writes an LVM label to the start of the device." \
        'chk "^sudo pvcreate /dev/sdb1"' 15

    run_challenge "Create a Volume Group" \
        "Create a volume group called ${YELLOW}data_vg${NC} out of the physical volume you just made.\n\n  A volume group is a pool of storage, one or more physical volumes combined into a single space you carve logical volumes from." \
        "sudo vgcreate data_vg /dev/sdb1: name first, then one or more physical volumes to add to the pool." \
        'chk "^sudo vgcreate data_vg /dev/sdb1"' 20

    run_challenge "Create a Logical Volume" \
        "Carve a 10GB logical volume named ${YELLOW}data_lv${NC} out of ${YELLOW}data_vg${NC}.\n\n  A logical volume behaves like a partition, but it can be resized on the fly, span multiple disks, and be snapshotted, none of which a real partition can do." \
        "sudo lvcreate -L 10G -n data_lv data_vg: -L sets the size, -n names it, then the source volume group." \
        'chk "^sudo lvcreate -L ?10G -n data_lv data_vg"' 20

    run_challenge "Format the Logical Volume" \
        "Put an ext4 filesystem on the new logical volume at ${YELLOW}/dev/data_vg/data_lv${NC}.\n\n  From here it mounts exactly like any other formatted device." \
        "sudo mkfs.ext4 /dev/data_vg/data_lv: same mkfs you already know, just pointed at an LVM path instead of a raw partition." \
        'chk "^sudo mkfs\\.ext4 /dev/data_vg/data_lv"' 20

    run_challenge "List Volume Groups" \
        "Show every volume group on the system along with its size and free space.\n\n  vgs gives a compact one-line-per-group summary. vgdisplay gives the same information in a more verbose, human-readable layout." \
        "vgs: short columnar summary. vgdisplay gives the long form." \
        'chk "^(sudo )?vgs|^(sudo )?vgdisplay"' 15

    cleanup_game_env
    level_complete 33
}

run_level_34() {
    level_intro 34 "LVM: Resize &amp; Snapshots" \
        "The entire point of LVM is that today's sizing decision doesn't have to be final. Running low on space is a five-minute fix, not a migration project, and a snapshot gives you a safe rollback point before anything risky." \
        "📐   lvextend  |  resize2fs  |  vgextend  |  lvcreate -s"
    setup_game_env

    run_challenge "Extend a Logical Volume" \
        "Grow ${YELLOW}data_lv${NC} by another 5GB.\n\n  This grows the logical volume itself. The filesystem sitting on top of it doesn't know about the new space yet, that's the next step." \
        "sudo lvextend -L +5G /dev/data_vg/data_lv: the + makes it relative (add 5GB), omit it to set an absolute size instead." \
        'chk "^sudo lvextend -L \\+5G"' 20

    run_challenge "Grow the Filesystem to Match" \
        "The logical volume is bigger, but the ext4 filesystem on it still thinks it's the old size. Fix that.\n\n  For XFS the equivalent is xfs_growfs, and unlike ext4 it can only be grown online, never offline." \
        "sudo resize2fs /dev/data_vg/data_lv: grows ext4 to fill all available space on the logical volume." \
        'chk "^sudo resize2fs"' 20

    run_challenge "Add a Disk to the Volume Group" \
        "Add ${YELLOW}/dev/sdc1${NC} (already a physical volume) into ${YELLOW}data_vg${NC}, growing the pool.\n\n  This is how you outgrow the original disks entirely, add more physical volumes to the same group, no downtime, no data migration." \
        "sudo vgextend data_vg /dev/sdc1: group name first, then the physical volume to add." \
        'chk "^sudo vgextend data_vg /dev/sdc1"' 20

    run_challenge "Create a Snapshot" \
        "Take a 2GB snapshot of ${YELLOW}data_lv${NC} called ${YELLOW}data_snap${NC} before you make a risky change.\n\n  A snapshot freezes the volume's state at this instant. If the change goes wrong, you roll back to the snapshot instead of restoring from a backup." \
        "sudo lvcreate -L 2G -s -n data_snap /dev/data_vg/data_lv: -s marks it as a snapshot of the given source volume." \
        'chk "^sudo lvcreate -L ?2G -s -n data_snap"' 25

    run_challenge "Remove a Logical Volume" \
        "The snapshot did its job and the change succeeded. Remove ${YELLOW}data_snap${NC}, you don't need it anymore.\n\n  ${LRED}This is permanent. Confirm you're pointed at the snapshot, not the real volume, before running it.${NC}" \
        "sudo lvremove /dev/data_vg/data_snap: prompts for confirmation unless you add -f to force it." \
        'chk "^sudo lvremove"' 20

    cleanup_game_env
    tier_complete 34 "Storage & Filesystems" \
        "Partition tables, filesystems, mounting, and the full LVM lifecycle: create, extend, and snapshot. You can now build and grow storage on a Linux box without ever taking it offline." \
        "Tier 7: File Editing & Sharing: vim, ACLs, Samba, NFS, and rsync."
}

# ---- TIER 7: FILE EDITING & SHARING ----

run_level_35() {
    level_intro 35 "Vim Essentials" \
        "Every Linux box has vim, or at least vi, whether or not you asked for it. Editing a config file over SSH at 3am is not the time to be learning modal editing from scratch. You don't need to be fast, you just need to never get stuck." \
        "✏️   i / Esc  |  :wq  |  dd  |  /search  |  :%s///g"
    setup_game_env

    run_challenge "Open a File" \
        "Open ${YELLOW}home/welcome.txt${NC} in vim.\n\n  vim opens straight into normal mode, where keystrokes are commands, not text. That's the part that trips up everyone the first time." \
        "vim home/welcome.txt: vi works identically if vim isn't installed, most vim commands are shared with vi." \
        'chk "^vim? home/welcome\\.txt"' 10

    run_challenge "Enter Insert Mode" \
        "You're in normal mode looking at the file. Type the single key that switches to insert mode so you can actually type text." \
        "i: i = insert before the cursor. a = insert after it. Both drop you into insert mode." \
        'exact "i"' 10

    run_challenge "Back to Normal Mode" \
        "You just finished typing. Get back to normal mode so your next keystrokes are commands again, not more text.\n\n  This is the single most-pressed key in vim, and the one new users forget most often." \
        "Esc: the Escape key. Every vim session, every mode, always gets you back to normal mode." \
        'chk "^([Ee][Ss][Cc])$"' 10

    run_challenge "Delete the Current Line" \
        "From normal mode, delete the entire line the cursor is sitting on.\n\n  dd also copies the deleted line into vim's default register, so a following p pastes it right back." \
        "dd: press d twice. 3dd deletes three lines starting from the cursor." \
        'exact "dd"' 15

    run_challenge "Search Forward" \
        "Search forward through the file for the word ${YELLOW}error${NC}.\n\n  n repeats the search forward, N repeats it backward. ? searches backward from the start." \
        "/error: / starts a forward search, type the pattern, press Enter." \
        'chk "^/[A-Za-z]+$"' 15

    run_challenge "Save and Quit" \
        "You're done editing. Save the file and exit vim in one command." \
        ":wq: w writes, q quits. :q! discards changes instead, :wq! forces a write on a read-only file." \
        'exact ":wq"' 15

    run_challenge "Find and Replace Every Occurrence" \
        "Replace every instance of ${YELLOW}foo${NC} with ${YELLOW}bar${NC} across the whole file, not just the current line.\n\n  Without the leading %, the substitution only applies to the current line." \
        ":%s/foo/bar/g: % means every line, s is substitute, g means every match per line, not just the first." \
        'chk "^:%s/[^/]+/[^/]*/g$"' 20

    cleanup_game_env
    level_complete 35
}

run_level_36() {
    level_intro 36 "Advanced Permissions &amp; ACLs" \
        "chmod's owner/group/other model runs out of expressiveness fast: what if two different teams need different access to the same file, and neither is the owner? Access Control Lists let you grant permissions to specific users and groups on top of the normal permission bits." \
        "🧷   getfacl  |  setfacl  |  umask"
    setup_game_env

    run_challenge "View a File's ACLs" \
        "Show the full access control list for ${YELLOW}home/welcome.txt${NC}.\n\n  This shows the standard owner/group/other bits plus any extra user or group entries layered on top." \
        "getfacl home/welcome.txt: prints every ACL entry, standard and extended, for the file." \
        'chk "^getfacl home/welcome\\.txt"' 15

    run_challenge "Grant a User Extra Access" \
        "Give the user ${YELLOW}alice${NC} read and write access to ${YELLOW}home/welcome.txt${NC}, without changing the file's owner or group.\n\n  This is the whole point of ACLs: extra access for one specific user, layered on top of normal permissions." \
        "setfacl -m u:alice:rw home/welcome.txt: -m modifies the ACL, u:name:perms adds or updates a user entry." \
        'chk "^setfacl -m u:alice:rw"' 20

    run_challenge "Grant a Group Extra Access" \
        "Give the group ${YELLOW}devs${NC} read and execute access to ${YELLOW}home/welcome.txt${NC}.\n\n  Same idea as the user entry, but for an entire group instead of one person." \
        "setfacl -m g:devs:rx home/welcome.txt: g:name:perms adds or updates a group entry the same way u: does for users." \
        'chk "^setfacl -m g:devs:rx"' 20

    run_challenge "Strip All ACLs" \
        "Remove every extended ACL entry from ${YELLOW}home/welcome.txt${NC}, back to just the standard owner/group/other bits.\n\n  Useful when a file's ACLs have drifted into something nobody can explain anymore, and you want a clean baseline." \
        "setfacl -b home/welcome.txt: -b removes all extended ACL entries in one shot." \
        'chk "^setfacl -b"' 15

    run_challenge "Check the Current umask" \
        "Show the umask that determines the default permissions on every file you create from this shell." \
        "umask: with no arguments, prints the current umask (commonly 022, giving new files 644 and new directories 755)." \
        'exact "umask"' 10

    run_challenge "Tighten the umask" \
        "Set the umask for this session so newly created files default to owner-only access.\n\n  A umask of 027 gives new files 640 and new directories 750, no access at all for others." \
        "umask 027: the umask value is SUBTRACTED from full permissions, it's a mask of what to deny, not what to grant." \
        'chk "^umask 0?27$"' 15

    cleanup_game_env
    level_complete 36
}

run_level_37() {
    level_intro 37 "Samba File Sharing" \
        "Samba is how a Linux box speaks the SMB protocol, so Windows machines (and everyone else) can see it as a normal network share. It's still the standard way to hand a folder to a mixed-OS office, decades on." \
        "🗂️   testparm  |  smbpasswd  |  smbclient  |  mount -t cifs"
    setup_game_env

    run_challenge "Validate the Samba Config" \
        "Before restarting Samba, check that ${YELLOW}/etc/samba/smb.conf${NC} has no syntax errors.\n\n  Restarting Samba on a broken config takes down every existing share. Always test first." \
        "testparm: parses smb.conf and reports any syntax problems before you commit to a restart." \
        'exact "testparm"' 15

    run_challenge "Set a Samba Password" \
        "Create a Samba password for the existing Linux user ${YELLOW}alice${NC}.\n\n  Samba keeps its own separate password database from the system's. A Linux user needs a Samba password added before they can authenticate to a share." \
        "sudo smbpasswd -a alice: -a adds the user to Samba's password database and prompts for a new password." \
        'chk "^sudo smbpasswd -a alice"' 20

    run_challenge "Apply a Config Change" \
        "You've edited smb.conf and confirmed it's valid. Apply the change.\n\n  Like most daemons, Samba doesn't reread its config until told to." \
        "sudo systemctl restart smbd: restart applies config changes. reload works too if smbd supports it for a lighter-touch apply." \
        'chk "^sudo systemctl re(start|load) smbd"' 15

    run_challenge "List Shares from a Client" \
        "See what shares are available on ${YELLOW}fileserver${NC} as the user ${YELLOW}alice${NC}, without mounting anything yet.\n\n  Always worth doing before you mount blind, confirms the share name and that credentials work." \
        "smbclient -L fileserver -U alice: -L lists shares, -U sets the username, it'll prompt for the password." \
        'chk "^smbclient -L fileserver"' 20

    run_challenge "Mount a Samba Share" \
        "Mount ${YELLOW}//fileserver/data${NC} at ${YELLOW}/mnt/win${NC} as the user ${YELLOW}alice${NC}.\n\n  cifs is the modern name for the SMB client filesystem module, smbfs is the old deprecated one." \
        "sudo mount -t cifs //fileserver/data /mnt/win -o username=alice: -t cifs selects the filesystem type, -o passes mount options." \
        'chk "^sudo mount -t cifs"' 20

    cleanup_game_env
    level_complete 37
}

run_level_38() {
    level_intro 38 "NFS Sharing" \
        "NFS is the native way Unix and Linux machines share filesystems with each other: lighter weight than Samba, and the default choice when every box on both ends is Linux or Unix, not Windows." \
        "📡   /etc/exports  |  exportfs  |  showmount  |  mount -t nfs"
    setup_game_env

    run_challenge "Review Current Exports" \
        "Show every filesystem currently being exported by this NFS server, and who it's exported to.\n\n  exportfs -v reads the live kernel export table, not just what's written in the config file, so it reflects reality even if /etc/exports was edited but not yet applied." \
        "exportfs -v: -v adds verbose output, showing each export's options alongside the path and client list." \
        'chk "^exportfs -v"' 15

    run_challenge "Apply /etc/exports Changes" \
        "You edited ${YELLOW}/etc/exports${NC} to add a new share. Apply it without restarting the NFS service.\n\n  -r re-exports everything listed in the file, adding new entries and dropping removed ones, all without an interruption to existing clients." \
        "sudo exportfs -ra: -r re-exports all, -a applies to all entries in /etc/exports." \
        'chk "^sudo exportfs -ra"' 20

    run_challenge "See What a Server Exports" \
        "From a client machine, check what ${YELLOW}192.168.1.10${NC} is exporting, before you try to mount anything." \
        "showmount -e 192.168.1.10: -e lists the export list of the given NFS server." \
        'chk "^showmount -e"' 15

    run_challenge "Mount an NFS Share" \
        "Mount the export ${YELLOW}/data${NC} from ${YELLOW}192.168.1.10${NC} at ${YELLOW}/mnt/nfs${NC} locally." \
        "sudo mount -t nfs 192.168.1.10:/data /mnt/nfs: server:/export-path as a single argument, same as any other mount." \
        'chk "^sudo mount -t nfs"' 20

    run_challenge "Unmount It" \
        "Unmount the NFS share at ${YELLOW}/mnt/nfs${NC}.\n\n  If it hangs on a dead server, -f forces it and -l does a lazy unmount that detaches immediately and cleans up once nothing references it anymore." \
        "sudo umount /mnt/nfs: same umount you already know, NFS mounts don't need anything special to remove." \
        'chk "^sudo umount"' 15

    cleanup_game_env
    level_complete 38
}

run_level_39() {
    level_intro 39 "Sync &amp; Backup with rsync" \
        "rsync is the workhorse behind more backup systems than almost any other single tool: it only transfers what changed, it can run over SSH with no extra setup, and it can mirror a destination exactly or just add to it. Learn this one properly." \
        "🔁   rsync -avz  |  --delete  |  -e ssh  |  --dry-run"
    setup_game_env

    run_challenge "Basic Archive Copy" \
        "Copy the contents of ${YELLOW}home/${NC} into ${YELLOW}/mnt/backup/${NC}, preserving permissions, timestamps, and symlinks.\n\n  -a (archive) bundles up the flags you almost always want: recursive, preserve permissions, timestamps, symlinks, and ownership where possible." \
        "rsync -av home/ /mnt/backup/: -a for archive mode, -v for verbose so you can see what's transferring." \
        'chk "^rsync -a?v?[a-z]* home/ /mnt/backup/?$|^rsync -[a-z]*a[a-z]*v[a-z]* home/ /mnt/backup/?$"' 20

    run_challenge "Mirror Exactly, Including Deletions" \
        "Sync ${YELLOW}home/${NC} to ${YELLOW}/mnt/backup/${NC} again, but this time also remove anything from the destination that no longer exists in the source.\n\n  Without --delete, rsync only ever adds and updates, files removed from the source pile up forever at the destination." \
        "rsync -av --delete home/ /mnt/backup/: --delete makes the destination an exact mirror of the source, not just a superset." \
        'chk "^rsync.*--delete"' 20

    run_challenge "Sync Over SSH" \
        "Sync ${YELLOW}home/${NC} to ${YELLOW}/data/${NC} on the remote host ${YELLOW}backup${NC}, as user ${YELLOW}alice${NC}, over SSH.\n\n  rsync over SSH needs no extra daemon running on the remote end, it just needs SSH access, the same as scp." \
        "rsync -avz -e ssh home/ alice@backup:/data/: -z compresses data in transit, -e ssh selects the remote shell to tunnel through." \
        'chk "^rsync.*-e ssh"' 20

    run_challenge "Preview Before You Commit" \
        "Before running a sync for real, preview exactly what rsync WOULD do, without actually copying or deleting anything.\n\n  Always dry-run a sync with --delete before trusting it against anything that matters." \
        "rsync -avzn home/ /mnt/backup/: n (or --dry-run) shows every action rsync would take without touching a single file." \
        'chk "^rsync.*(-[a-z]*n[a-z]*|--dry-run)"' 20

    run_challenge "Track Progress on a Large Transfer" \
        "Run the same backup sync, but this time show a live progress indicator for each file as it copies.\n\n  On a large transfer over a slow link, --progress is the difference between watching it work and wondering if it's hung." \
        "rsync -avz --progress home/ /mnt/backup/: --progress prints a live percentage and transfer rate for the file currently copying." \
        'chk "^rsync.*--progress"' 20

    cleanup_game_env
    tier_complete 39 "File Editing & Sharing" \
        "Modal editing in vim, fine-grained ACLs, and both major file-sharing protocols, Samba for Windows clients, NFS for Unix ones, plus rsync for everything in between. You can now edit anything and share it with anyone." \
        "Tier 8: Networking: IP addressing, routing, DNS, firewalls, and VLANs."
}

# ---- TIER 8: NETWORKING ----

run_level_40() {
    level_intro 40 "IP Addressing" \
        "curl and ping get you through the basics, but real network administration starts one layer down: seeing exactly which addresses are assigned to which interfaces, and being able to change that yourself. ip is the modern tool for all of it, ifconfig is legacy." \
        "🧭   ip addr  |  ip link  |  hostname -I"
    setup_game_env

    run_challenge "Show All Addresses" \
        "Show every IP address assigned to every interface on this machine." \
        "ip addr: ip a is the common shorthand. Shows every interface with its addresses, state, and MTU." \
        'chk "^ip a(ddr)?( show)?$"' 10

    run_challenge "Show Interface Link State" \
        "Show just the link-layer state of every interface: up, down, and MAC address, without the IP address noise." \
        "ip link show: link is layer 2, addr is layer 3. Same tool, different layer of detail." \
        'chk "^ip link( show)?$"' 15

    run_challenge "Assign an IP Address" \
        "Add the address ${YELLOW}192.168.1.50/24${NC} to interface ${YELLOW}eth0${NC}.\n\n  This is temporary, it won't survive a reboot unless it's also written into the network config for your distro." \
        "sudo ip addr add 192.168.1.50/24 dev eth0: add takes the address in CIDR notation, dev specifies the interface." \
        'chk "^sudo ip addr add"' 20

    run_challenge "Bring an Interface Up" \
        "The interface ${YELLOW}eth0${NC} is currently down. Bring it up.\n\n  A newly added interface, or one after a driver reload, often comes up in a down state and needs this explicitly." \
        "sudo ip link set eth0 up: set changes a link property, up brings it online. down takes it offline the same way." \
        'chk "^sudo ip link set eth0 up"' 15

    run_challenge "Quick Own-IP Check" \
        "You just need your own IP address for a one-liner, nothing else. Get it as fast as possible." \
        "hostname -I: prints just the IP addresses, space-separated, no other noise. Perfect for scripting." \
        'chk "^hostname -I"' 10

    cleanup_game_env
    level_complete 40
}

run_level_41() {
    level_intro 41 "Routing &amp; Gateways" \
        "An address without a route is just a number. Every packet leaving this box for another network has to go somewhere, and the routing table decides exactly where. This is also where you diagnose 'I can ping the gateway but nothing past it.'" \
        "🛣️   ip route  |  traceroute  |  mtr"
    setup_game_env

    run_challenge "Show the Routing Table" \
        "Show the current routing table for this machine." \
        "ip route: ip r is the common shorthand. The default route is what everything without a more specific match uses." \
        'chk "^ip r(oute)?( show)?$"' 10

    run_challenge "Set a Default Gateway" \
        "Set ${YELLOW}192.168.1.1${NC} as the default gateway for all outbound traffic that doesn't match a more specific route." \
        "sudo ip route add default via 192.168.1.1: default matches anything, via specifies the next-hop router." \
        'chk "^sudo ip route add default via"' 20

    run_challenge "Add a Static Route" \
        "Add a route so traffic to ${YELLOW}10.0.0.0/24${NC} goes via ${YELLOW}192.168.1.254${NC} instead of the default gateway.\n\n  More specific routes always win over the default, this is how you reach a second subnet without changing your main gateway." \
        "sudo ip route add 10.0.0.0/24 via 192.168.1.254: destination network first, via the specific next-hop for that network." \
        'chk "^sudo ip route add 10\\.0\\.0\\.0/24 via"' 20

    run_challenge "Trace the Path to a Host" \
        "See every hop your traffic takes on the way to ${YELLOW}google.com${NC}.\n\n  Invaluable for spotting exactly where a connection is dying: your gateway, your ISP, or somewhere further out." \
        "traceroute google.com: shows each router hop and its round-trip time, one line per hop." \
        'chk "^traceroute"' 15

    run_challenge "Live Combined Trace" \
        "Do the same thing as traceroute, but continuously, with live loss and latency stats updating per hop, instead of a single one-shot report." \
        "mtr google.com: combines traceroute and ping into one continuously updating view, the single best tool for diagnosing intermittent path issues." \
        'chk "^mtr"' 20

    cleanup_game_env
    level_complete 41
}

run_level_42() {
    level_intro 42 "DNS Tools" \
        "Half of 'the network is down' tickets are actually DNS. Knowing how to query a record directly, bypassing whatever's cached in the browser or the OS, is how you tell the difference between a real outage and a stale cache in about ten seconds." \
        "🧾   dig  |  nslookup  |  /etc/resolv.conf  |  /etc/hosts"
    setup_game_env

    run_challenge "Query a Domain" \
        "Look up the DNS record for ${YELLOW}google.com${NC}.\n\n  dig's output is dense but precise: it shows the query, the answer section, and exactly which server answered." \
        "dig google.com: returns the A record by default, along with query time and the responding server." \
        'chk "^dig google\\.com"' 15

    run_challenge "Query a Specific Record Type" \
        "Look up the mail server (MX) records for ${YELLOW}google.com${NC} specifically, not the default A record." \
        "dig google.com MX: the record type goes after the domain. Try NS, TXT, or AAAA the same way." \
        'chk "^dig google\\.com MX"' 15

    run_challenge "Simple Lookup" \
        "Do a quick, simpler DNS lookup for ${YELLOW}google.com${NC}, less detailed than dig but faster to read." \
        "nslookup google.com: older and less flexible than dig, but its terse output is sometimes exactly what you want." \
        'chk "^nslookup google\\.com"' 15

    run_challenge "Check the Resolver Config" \
        "Show which DNS servers this machine is actually configured to query.\n\n  If DNS lookups are slow or failing entirely, this file is one of the first things worth checking." \
        "cat /etc/resolv.conf: lists the nameserver entries this machine queries, in priority order." \
        'chk "^cat /etc/resolv\\.conf"' 15

    run_challenge "Reverse Lookup" \
        "Find out what hostname resolves to the IP address ${YELLOW}8.8.8.8${NC}." \
        "dig -x 8.8.8.8: -x performs a reverse lookup, IP to hostname instead of the usual hostname to IP." \
        'chk "^dig -x"' 20

    cleanup_game_env
    level_complete 42
}

run_level_43() {
    level_intro 43 "Firewalls" \
        "A server with every port wide open is a server waiting for something to go wrong. iptables and its modern replacement nftables give you precise, rule-by-rule control over what traffic is allowed in and out. ufw wraps either one in a friendlier syntax for simpler cases." \
        "🧱   iptables  |  nft  |  ufw"
    setup_game_env

    run_challenge "List Current Rules" \
        "Show the current iptables ruleset, with numeric output instead of resolving hostnames.\n\n  -n skips DNS resolution on every listed address, which is both faster and avoids leaking the query to whatever DNS server you use." \
        "sudo iptables -L -n: -L lists rules, -n keeps addresses and ports numeric instead of resolved." \
        'chk "^sudo iptables -L"' 15

    run_challenge "Allow SSH Through" \
        "Add a rule allowing incoming TCP traffic on port 22 (SSH).\n\n  Get SSH access wrong on a remote box and you've locked yourself out. Always double, then triple-check this rule before applying anything stricter around it." \
        "sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT: -A appends the rule, -p sets protocol, --dport the destination port, -j the action." \
        'chk "^sudo iptables -A INPUT.*22.*ACCEPT"' 25

    run_challenge "List the Modern Ruleset" \
        "Show the current ruleset using nftables, the modern replacement for iptables.\n\n  Most current distros ship nftables under the hood even when you're typing iptables commands, translated automatically." \
        "sudo nft list ruleset: shows every table, chain, and rule currently configured." \
        'chk "^sudo nft list ruleset"' 15

    run_challenge "Allow a Port with ufw" \
        "Using ufw's simpler syntax, allow incoming traffic on port 22.\n\n  ufw exists specifically so you don't have to remember iptables' full syntax for the common cases." \
        "sudo ufw allow 22: one word, one port, done. ufw allow 22/tcp is more explicit if you only want TCP." \
        'chk "^sudo ufw allow 22"' 15

    run_challenge "Turn the Firewall On" \
        "You've configured your rules. Enable ufw so they actually take effect.\n\n  ${LRED}Confirm your SSH rule is in place BEFORE enabling, or you can lock yourself out of a remote box instantly.${NC}" \
        "sudo ufw enable: activates the firewall with the current ruleset. sudo ufw status verifies what's active afterward." \
        'chk "^sudo ufw enable"' 20

    cleanup_game_env
    level_complete 43
}

run_level_44() {
    level_intro 44 "VLANs &amp; Trunking" \
        "A single physical switch port can carry traffic for multiple isolated VLANs at once, tagged with an 802.1Q header, if it's configured as a trunk port instead of a plain access port. Linux hosts can speak that same tagged traffic directly with a VLAN subinterface." \
        "🔀   ip link add ... type vlan  |  802.1Q  |  trunk vs access"
    setup_game_env

    run_challenge "Create a VLAN Subinterface" \
        "Create a VLAN subinterface for VLAN ID 10 on top of ${YELLOW}eth0${NC}, named ${YELLOW}eth0.10${NC}.\n\n  This is how a Linux box participates in a specific VLAN over a trunk port: the physical NIC carries every tagged VLAN, the subinterface picks out just one." \
        "sudo ip link add link eth0 name eth0.10 type vlan id 10: link is the parent interface, id is the 802.1Q VLAN tag." \
        'chk "^sudo ip link add link eth0 name eth0\\.10 type vlan id 10"' 25

    run_challenge "Bring the VLAN Interface Up" \
        "Bring ${YELLOW}eth0.10${NC} online.\n\n  Same as any other interface, a VLAN subinterface needs to be explicitly brought up before it passes traffic." \
        "sudo ip link set eth0.10 up: identical syntax to bringing up any physical interface." \
        'chk "^sudo ip link set eth0\\.10 up"' 15

    run_challenge "Address the VLAN Interface" \
        "Assign ${YELLOW}10.10.10.5/24${NC} to ${YELLOW}eth0.10${NC}, so this host has a real address inside VLAN 10." \
        "sudo ip addr add 10.10.10.5/24 dev eth0.10: identical to addressing any interface, just pointed at the VLAN subinterface instead of the physical one." \
        'chk "^sudo ip addr add 10\\.10\\.10\\.5/24 dev eth0\\.10"' 20

    run_challenge "Confirm the VLAN Tag" \
        "Show detailed link information for ${YELLOW}eth0.10${NC}, including the VLAN ID it's tagged with.\n\n  The switch port facing this host needs to be configured as a trunk carrying VLAN 10, tagged, or none of this traffic arrives. An access port only ever carries one untagged VLAN." \
        "ip -d link show eth0.10: -d adds detail output, which for a VLAN interface includes the protocol and VLAN ID." \
        'chk "^ip -d link show eth0\\.10"' 20

    run_challenge "Remove the VLAN Interface" \
        "This VLAN subinterface is no longer needed. Remove it cleanly." \
        "sudo ip link delete eth0.10: delete removes a virtual interface entirely. Physical interfaces can only be brought down, never deleted this way." \
        'chk "^sudo ip link delete eth0\\.10"' 15

    cleanup_game_env
    level_complete 44
}

run_level_45() {
    level_intro 45 "Bonding &amp; Troubleshooting" \
        "The final networking skill is diagnosis: capturing packets to see exactly what's on the wire, checking interface error counters, and bonding multiple physical links into one for redundancy or throughput. When something's actually broken, these are the tools that tell you why." \
        "🩺   tcpdump  |  bonding  |  ip -s link"
    setup_game_env

    run_challenge "Capture Live Traffic" \
        "Start capturing packets on interface ${YELLOW}eth0${NC}.\n\n  Without a filter this shows everything, which gets noisy fast on a busy interface. Ctrl+C to stop capturing." \
        "sudo tcpdump -i eth0: -i selects the interface to listen on." \
        'chk "^sudo tcpdump -i eth0"' 20

    run_challenge "Filter to a Single Port" \
        "Capture traffic on ${YELLOW}eth0${NC} again, but this time only show packets on port 443.\n\n  Filtering at capture time, rather than scrolling through everything afterward, is how you keep a live capture actually readable." \
        "sudo tcpdump -i eth0 port 443: filter expressions go after the interface, port, host, and net are the most common." \
        'chk "^sudo tcpdump -i eth0 port 443"' 20

    run_challenge "Check Bond Status" \
        "You have a bonded interface named ${YELLOW}bond0${NC}. Check its current status: active mode, which slave interfaces are up, and which one is primary.\n\n  The kernel exposes this directly as a virtual file, no extra tool needed." \
        "cat /proc/net/bonding/bond0: shows bonding mode, MII status, and every slave interface's individual state." \
        'chk "^cat /proc/net/bonding/bond0"' 20

    run_challenge "Create a Bond Interface" \
        "Create a new bonded interface named ${YELLOW}bond0${NC} in active-backup mode, where one link is active and the other stands by as failover.\n\n  Active-backup is the simplest bonding mode: zero configuration needed on the switch side, unlike LACP modes which require switch cooperation." \
        "sudo ip link add bond0 type bond mode active-backup: add ... type bond creates the virtual interface, mode sets the bonding behavior." \
        'chk "^sudo ip link add bond0 type bond"' 25

    run_challenge "Check Interface Error Counters" \
        "Show detailed statistics for ${YELLOW}eth0${NC}, including RX/TX errors and dropped packets, not just its up/down state.\n\n  Rising error or drop counts on an otherwise 'up' interface are a classic sign of a bad cable, a duplex mismatch, or a failing NIC." \
        "ip -s link show eth0: -s adds packet, byte, error, and drop statistics for the interface." \
        'chk "^ip -s link show eth0"' 20

    cleanup_game_env
    tier_complete 45 "Networking" \
        "Addressing, routing, DNS, firewalls, VLANs and trunking, bonding, and packet capture. You can now stand up, segment, secure, and troubleshoot a real network, not just talk to one." \
        "Tier 9: Storage Networking & SAN: iSCSI, multipath, and enterprise storage."
}

# ---- TIER 9: STORAGE NETWORKING & SAN ----

run_level_46() {
    level_intro 46 "iSCSI Initiators &amp; Targets" \
        "iSCSI puts SCSI storage commands over an ordinary IP network, turning a remote disk into something that shows up locally like any other block device. The initiator is the client asking for storage, the target is the server offering it. Enterprise storage arrays speak this constantly." \
        "🔗   iscsiadm  |  targetcli  |  discovery / login / logout"
    setup_game_env

    run_challenge "Discover Targets on a Portal" \
        "Discover what iSCSI targets are available from the storage portal at ${YELLOW}192.168.1.20${NC}, before connecting to any of them.\n\n  Discovery just asks 'what do you have', it doesn't establish a session yet." \
        "sudo iscsiadm -m discovery -t sendtargets -p 192.168.1.20: -m selects discovery mode, -t the discovery type, -p the portal address." \
        'chk "^sudo iscsiadm -m discovery"' 20

    run_challenge "Log Into a Target" \
        "Log into the discovered target ${YELLOW}iqn.2026-01.com.example:storage${NC} on portal ${YELLOW}192.168.1.20${NC}, establishing the session that exposes it as a local device." \
        "sudo iscsiadm -m node -T iqn.2026-01.com.example:storage -p 192.168.1.20 --login: -m node targets a specific discovered node, --login establishes the session." \
        'chk "^sudo iscsiadm -m node.*--login"' 25

    run_challenge "List Active Sessions" \
        "Show every active iSCSI session on this initiator right now.\n\n  Once logged in, the target's LUNs appear as ordinary /dev/sdX devices, check lsblk or dmesg to see which ones just arrived." \
        "sudo iscsiadm -m session: lists every currently connected iSCSI session with its target IQN and portal." \
        'chk "^sudo iscsiadm -m session"' 15

    run_challenge "Log Out of a Target" \
        "Cleanly disconnect from ${YELLOW}iqn.2026-01.com.example:storage${NC}, ending the session.\n\n  Always log out cleanly rather than yanking the connection, an abrupt disconnect can leave the filesystem on that LUN in an inconsistent state." \
        "sudo iscsiadm -m node -T iqn.2026-01.com.example:storage --logout: same node targeting as login, --logout instead of --login." \
        'chk "^sudo iscsiadm -m node.*--logout"' 20

    run_challenge "Name the Server-Side Tool" \
        "Discovery and login happen on the initiator (client) side. What's the standard tool for configuring an iSCSI TARGET, the server side that actually exports the storage?" \
        "targetcli: an interactive shell for creating backstores, iSCSI targets, LUNs, and access control lists." \
        'exact "targetcli"' 15

    cleanup_game_env
    level_complete 46
}

run_level_47() {
    level_intro 47 "NFS/SMB at Scale + autofs" \
        "Manually mounting shares doesn't scale past a handful of machines. autofs mounts a share the instant something accesses it, and unmounts it again after a timeout, so a hundred workstations can reference hundreds of shares without any of them staying permanently mounted." \
        "🗺️   autofs  |  /etc/auto.master  |  on-demand mount/unmount"
    setup_game_env

    run_challenge "Check autofs Status" \
        "Check whether the autofs service is running.\n\n  If a share that should auto-mount on access isn't appearing, this is the first thing worth checking." \
        "sudo systemctl status autofs: same systemctl status pattern you already know, just pointed at autofs specifically." \
        'chk "^sudo systemctl status autofs"' 15

    run_challenge "Apply New Map Entries" \
        "You've added a new entry to autofs's maps. Apply the change without a full restart.\n\n  reload picks up new map entries without dropping any shares that are currently auto-mounted." \
        "sudo systemctl reload autofs: reload re-reads the maps in place, restart would also work but is heavier-handed." \
        'chk "^sudo systemctl reload autofs"' 20

    run_challenge "Check the Master Map" \
        "Show the contents of autofs's master map, which lists every mount point autofs manages and which map file controls each one." \
        "cat /etc/auto.master: the top-level map, each line points a mount point at a further map file defining the actual shares." \
        'chk "^cat /etc/auto\\.master"' 15

    run_challenge "See What's Currently Mounted" \
        "List every currently mounted filesystem, autofs-triggered mounts included, to confirm a share actually mounted after being accessed." \
        "mount: with no arguments, lists every mounted filesystem, exactly the same command whether the mount was manual or autofs-triggered." \
        'exact "mount"' 15

    run_challenge "Force-Unmount a Stuck Share" \
        "An NFS share at ${YELLOW}/mnt/nfs${NC} has gone stale, the server's unreachable and a normal umount just hangs. Force it.\n\n  -f forces the unmount even though the server isn't responding, essential when a share's server has gone down or been decommissioned." \
        "sudo umount -f /mnt/nfs: -f forces an unmount of an unreachable NFS share instead of waiting indefinitely." \
        'chk "^sudo umount -f"' 20

    cleanup_game_env
    level_complete 47
}

run_level_48() {
    level_intro 48 "Multipath &amp; SAN Concepts" \
        "In a real SAN, a server is rarely connected to storage over just one path, it's normally two or more, through separate switches, for redundancy and throughput. Multipathing is what makes those redundant paths look like a single reliable device instead of confusing the OS with duplicates." \
        "🧵   multipath -ll  |  WWNs  |  zoning  |  multipathd"
    setup_game_env

    run_challenge "List Multipath Devices" \
        "Show every multipath device currently configured, along with the state of each underlying path.\n\n  Each physical path shows as active, faulty, or ghost, one glance tells you if a SAN fabric has degraded." \
        "sudo multipath -ll: -ll shows full detail on every multipath map and every path feeding it." \
        'chk "^sudo multipath -ll"' 20

    run_challenge "Identify Devices by WWN" \
        "List block devices by their World Wide Name instead of their changeable /dev/sdX names.\n\n  A WWN is a globally unique identifier burned into the storage hardware itself, it never changes even if Linux renames /dev/sdb to /dev/sdc after a reboot. SAN zoning is configured against WWNs for exactly this reason." \
        "ls -la /dev/disk/by-id/: symlinks named by WWN, pointing at whatever /dev/sdX name the kernel currently assigned." \
        'chk "^ls -la? /dev/disk/by-id"' 20

    run_challenge "Restart the Multipath Daemon" \
        "Restart multipathd after changing its configuration in /etc/multipath.conf." \
        "sudo systemctl restart multipathd: same systemctl pattern as any other daemon, multipathd just happens to manage path failover." \
        'chk "^sudo systemctl restart multipathd"' 20

    run_challenge "Flush a Specific Device" \
        "Remove the multipath device map named ${YELLOW}mpatha${NC}, for example because the LUN behind it has been decommissioned.\n\n  ${LRED}Confirm nothing is still using the device first, unmount and check for open handles.${NC}" \
        "sudo multipath -f mpatha: -f flushes a single named multipath device map." \
        'chk "^sudo multipath -f mpatha"' 20

    cleanup_game_env
    level_complete 48
}

run_level_49() {
    level_intro 49 "Fibre Channel &amp; Storage Troubleshooting" \
        "Fibre Channel is the older, dedicated-fabric sibling of iSCSI: purpose-built switches, HBAs instead of NICs, and its own addressing scheme. The tools differ from IP storage, but the troubleshooting instinct is identical: find the device, check the path, rescan if something's missing." \
        "🔬   lsscsi  |  systool  |  SCSI rescan  |  multipath -F"
    setup_game_env

    run_challenge "List SCSI/FC Devices" \
        "List every SCSI device visible to this host, iSCSI and Fibre Channel LUNs included, with their type and vendor.\n\n  From the OS's point of view, an iSCSI LUN and a Fibre Channel LUN both just show up as SCSI devices, lsscsi doesn't care which transport carried them." \
        "lsscsi: lists every SCSI device with its host/channel/target/LUN address, type, and vendor/model." \
        'exact "lsscsi"' 15

    run_challenge "Rescan for New LUNs" \
        "Storage just presented a new LUN to SCSI host 0, but Linux hasn't noticed yet since it was added after boot. Trigger a rescan of that host without rebooting." \
        "echo \"- - -\" | sudo tee /sys/class/scsi_host/host0/scan: the three dashes tell the kernel to scan every channel, target, and LUN on that host." \
        'chk "scsi_host/host0/scan"' 25

    run_challenge "Check FC HBA Port Status" \
        "Check whether Fibre Channel host adapter 0's port is currently online.\n\n  An FC HBA's port state lives directly under sysfs, the same way most modern hardware state does on Linux." \
        "cat /sys/class/fc_host/host0/port_state: Online means the fabric link is up, Linkdown means a cable, SFP, or switch port problem." \
        'chk "fc_host/host0/port_state"' 20

    run_challenge "Clean Up Unused Multipath Maps" \
        "Remove every multipath device map that no longer has any active, in-use paths behind it, in one command.\n\n  Handy after decommissioning several LUNs at once, cleans up every stale map instead of flushing them one at a time." \
        "sudo multipath -F: -F (capital) flushes every unused multipath map at once, lowercase -f targets just one by name." \
        'chk "^sudo multipath -F"' 20

    cleanup_game_env
    tier_complete 49 "Storage Networking & SAN" \
        "iSCSI initiators and targets, autofs at scale, multipathing, WWN-based device identification, and Fibre Channel fundamentals. Enterprise storage that used to be a black box is now just another set of tools you know." \
        "Tier 10: Boot Process & Kernel: GRUB, boot managers, kernel panics, and building a kernel."
}

# ---- TIER 10: BOOT PROCESS & KERNEL ----

run_level_50() {
    level_intro 50 "Boot Process Overview" \
        "Between power-on and a login prompt, a lot happens: firmware, bootloader, kernel, then systemd bringing services up in dependency order toward a target. Knowing which stage you're in when something's slow, or won't come up at all, is half of diagnosing it." \
        "🥾   systemctl get-default  |  systemd-analyze  |  targets"
    setup_game_env

    run_challenge "Check the Default Target" \
        "Show which systemd target this machine boots into by default.\n\n  multi-user.target is a normal server, no GUI. graphical.target adds a display manager on top of it." \
        "systemctl get-default: prints the default target's name." \
        'chk "^systemctl get-default"' 15

    run_challenge "Set a Headless Default Target" \
        "Set the default boot target to multi-user, text-mode only, no graphical desktop.\n\n  Common on a server that had a desktop environment installed for troubleshooting and no longer needs it starting automatically." \
        "sudo systemctl set-default multi-user.target: changes what systemd boots into by default, effective from the next boot." \
        'chk "^sudo systemctl set-default multi-user\\.target"' 20

    run_challenge "List Every Available Target" \
        "Show every systemd target unit currently loaded on this system." \
        "systemctl list-units --type=target: filters the unit list down to just targets, the systemd equivalent of old SysV runlevels." \
        'chk "^systemctl list-units --type=target"' 15

    run_challenge "See the Full Boot Timeline" \
        "Show a breakdown of how long the last boot took: firmware, loader, kernel, and userspace, each broken out separately.\n\n  The first thing to run when someone says 'this box takes forever to boot now.'" \
        "systemd-analyze: prints total boot time split into firmware, bootloader, kernel, and userspace phases." \
        'chk "^systemd-analyze$"' 15

    run_challenge "Find the Slowest Service to Start" \
        "Show every systemd unit ranked by how long it took to initialize, slowest first.\n\n  This is how you find the one misbehaving service adding ten seconds to every single boot." \
        "systemd-analyze blame: lists every unit and its individual startup time, sorted slowest first." \
        'chk "^systemd-analyze blame"' 20

    cleanup_game_env
    level_complete 50
}

run_level_51() {
    level_intro 51 "GRUB2" \
        "GRUB is the bootloader most Linux systems use to get from firmware to kernel. Most of the time it's invisible, but when it isn't, when a boot entry is wrong, a kernel won't load, or a hand edit is needed, knowing your way around it is the difference between a five-minute fix and a reinstall." \
        "🐧   update-grub  |  grub-install  |  /etc/default/grub  |  grub rescue"
    setup_game_env

    run_challenge "Regenerate the GRUB Config" \
        "You edited /etc/default/grub. Regenerate the actual grub.cfg so the change takes effect." \
        "sudo update-grub: Debian/Ubuntu's wrapper. On RHEL-based systems the equivalent is grub2-mkconfig -o /boot/grub2/grub.cfg." \
        'chk "^sudo update-grub|^sudo grub2-mkconfig"' 20

    run_challenge "Reinstall GRUB to a Disk" \
        "Reinstall the GRUB bootloader itself onto ${YELLOW}/dev/sda${NC}.\n\n  Different from regenerating the config: this rewrites GRUB's actual boot code into the disk's boot sector or EFI partition, needed after a disk swap or a bootloader that's gone missing entirely." \
        "sudo grub-install /dev/sda: installs GRUB onto the specified disk. On UEFI systems this targets the EFI system partition instead." \
        'chk "^sudo grub-install"' 20

    run_challenge "Check the GRUB Defaults File" \
        "Show the contents of GRUB's own configuration source, the human-edited file, not the generated grub.cfg.\n\n  This is what you actually edit: timeout, default entry, kernel command-line parameters. update-grub then compiles it into the real grub.cfg." \
        "cat /etc/default/grub: the source of truth for GRUB settings, always edit this file, never grub.cfg directly." \
        'chk "^cat /etc/default/grub"' 15

    run_challenge "GRUB Rescue: List Partitions" \
        "The system dropped to a grub rescue> prompt, no menu, no boot. Type the command that lists every partition GRUB can currently see, the first step to finding where your kernel actually lives." \
        "ls: at a grub rescue> prompt, ls lists partitions like (hd0,gpt1). ls (hd0,gpt1)/ lists files inside one." \
        'exact "ls"' 20

    run_challenge "GRUB Menu: Edit an Entry" \
        "At the normal GRUB boot menu (not rescue), what single key opens the boot entry editor, so you can temporarily change kernel parameters for just this one boot?" \
        "e: opens the editor for the highlighted entry. Ctrl+X or F10 boots the edited entry, Esc discards the edit." \
        'exact "e"' 15

    cleanup_game_env
    level_complete 51
}

run_level_52() {
    level_intro 52 "Alternative Boot Managers" \
        "GRUB isn't the only option. systemd-boot is a minimal, fast UEFI boot manager that ships with systemd itself, and rEFInd is a graphical alternative popular for multi-OS and multi-kernel machines that want a visual picker instead of a text menu." \
        "🔁   bootctl  |  systemd-boot  |  rEFInd"
    setup_game_env

    run_challenge "Check systemd-boot Status" \
        "Check the current status of systemd-boot: which entries it knows about and which one is default.\n\n  bootctl is systemd-boot's management tool, the same way grub-install and update-grub manage GRUB." \
        "bootctl status: shows the firmware, current boot loader, and every configured boot entry." \
        'chk "^bootctl status"' 15

    run_challenge "Update systemd-boot" \
        "Update the systemd-boot binaries on the EFI system partition to match the currently installed systemd version.\n\n  Run this after a systemd package upgrade, the on-disk boot loader binary doesn't update itself automatically." \
        "sudo bootctl update: copies the current systemd-boot binaries onto the EFI system partition." \
        'chk "^sudo bootctl update"' 20

    run_challenge "List Boot Entries" \
        "List every boot entry systemd-boot currently knows about." \
        "bootctl list: shows every .conf entry found under the loader/entries directory on the ESP." \
        'chk "^bootctl list"' 15

    run_challenge "Install systemd-boot for the First Time" \
        "This machine has never had systemd-boot installed. Install it onto the EFI system partition now." \
        "sudo bootctl install: writes the systemd-boot binary to the ESP and registers it with UEFI firmware, first-time setup." \
        'chk "^sudo bootctl install"' 20

    run_challenge "Name the Graphical Alternative" \
        "What's the name of the popular graphical boot manager, often used on multi-OS or multi-kernel machines, that shows a themed visual picker instead of a plain text menu?" \
        "rEFInd: an EFI boot manager known for auto-detecting OSes and kernels and presenting them as clickable icons." \
        'chk "^[Rr][Ee][Ff][Ii][Nn][Dd]$"' 15

    cleanup_game_env
    level_complete 52
}

run_level_53() {
    level_intro 53 "Kernel Panics &amp; Recovery" \
        "A kernel panic is the worst-case message a Linux box can show you, and also one of the most diagnosable, if you know where to look. The kernel dumps everything it knows right before it dies. Reading that output, and getting the box back up, is a core sysadmin skill you hope to rarely need and always have ready." \
        "💥   rescue mode  |  journalctl -b -1  |  dmesg  |  initramfs rebuild"
    setup_game_env

    run_challenge "Boot Straight to Rescue Mode" \
        "The system won't boot normally. At the GRUB kernel command line, what do you append to boot directly into a minimal rescue shell instead of the full system?" \
        "systemd.unit=rescue.target: appended to the kernel line at the GRUB edit screen. The older single also still works on most systems." \
        'chk "systemd\\.unit=rescue\\.target|^single$"' 20

    run_challenge "Read the Previous Boot's Logs" \
        "The system just crashed and rebooted. Read the kernel and service logs from the boot BEFORE this one, where the actual panic happened.\n\n  The current boot's logs won't show you the crash, by definition it happened on the previous boot. This is the single most useful command after any unexpected reboot." \
        "journalctl -b -1: -b selects a specific boot, -1 means one boot before the current one." \
        'chk "^journalctl -b -1"' 25

    run_challenge "Check the Kernel Ring Buffer" \
        "Show the kernel's own message buffer directly, hardware detection, driver errors, and any panic messages still held in memory.\n\n  dmesg is lower-level than journalctl, it's talking to the kernel's ring buffer directly, useful even in a minimal rescue environment with no full logging stack running." \
        "dmesg: prints the kernel ring buffer. dmesg -T adds human-readable timestamps." \
        'exact "dmesg"' 15

    run_challenge "Rebuild the initramfs" \
        "You fixed a driver or module configuration issue that was causing panics at boot. Rebuild the initramfs so the fix is actually included in what loads before the real root filesystem mounts." \
        "sudo update-initramfs -u: Debian/Ubuntu's rebuild command. RHEL-based systems use sudo dracut -f instead." \
        'chk "^sudo update-initramfs -u|^sudo dracut"' 20

    run_challenge "Force a Filesystem Check on Next Boot" \
        "You suspect filesystem corruption is behind these panics. Force fsck to run automatically on the next boot, without an interactive prompt.\n\n  This classic trick works because most init systems check for this specific file's existence before deciding whether to run a full fsck." \
        "sudo touch /forcefsck: the presence of this file at the root of the filesystem triggers a forced fsck on the next boot." \
        'chk "^sudo touch /forcefsck"' 20

    cleanup_game_env
    level_complete 53
}

run_level_54() {
    level_intro 54 "Building a Kernel" \
        "Almost nobody builds a kernel from source for daily use anymore, distros handle that. But knowing how, adding a missing driver, enabling a feature flag, patching for hardware nobody else supports yet, is the deepest possible level of Linux mastery, and it demystifies everything above it." \
        "🧬   menuconfig  |  make  |  modules_install  |  make install"
    setup_game_env

    run_challenge "Configure Kernel Options" \
        "Open the interactive configuration menu to choose which kernel features, drivers, and modules to build.\n\n  This is where you'd enable a new filesystem, a new driver, or tune options for your exact hardware, hundreds of options organized into a searchable menu tree." \
        "make menuconfig: an ncurses-based configuration UI. make xconfig is the graphical Qt equivalent." \
        'chk "^make menuconfig"' 20

    run_challenge "Compile the Kernel" \
        "Build the kernel using every CPU core available, instead of a single-threaded build that could take hours.\n\n  A full kernel build can compile thousands of files, -j with a core count is the difference between minutes and hours." \
        "make -j\$(nproc): -j sets parallel jobs, \$(nproc) fills in your actual CPU core count automatically." \
        'chk "^make( -j.*)?$"' 20

    run_challenge "Install the Kernel Modules" \
        "Install every module the build just produced into the system's module directory, so the kernel can load them at runtime." \
        "sudo make modules_install: copies built modules into /lib/modules/<version>/, where the kernel expects to find them." \
        'chk "^sudo make modules_install"' 20

    run_challenge "Install the Kernel Itself" \
        "Install the newly built kernel image, and let the build system handle registering it as a new boot entry." \
        "sudo make install: copies the kernel image into /boot and typically triggers an initramfs build and bootloader config update automatically." \
        'chk "^sudo make install"' 20

    run_challenge "Make the New Kernel Bootable" \
        "The new kernel is installed, but the bootloader doesn't know about it yet. Make sure it shows up as a selectable boot entry.\n\n  Every kernel build ends the same way it started this tier: at the bootloader. Nothing you build is usable until it's reachable at boot." \
        "sudo update-grub: regenerates grub.cfg, picking up the newly installed kernel as a boot entry." \
        'chk "^sudo update-grub|^sudo grub2-mkconfig"' 20

    cleanup_game_env
    tier_complete 54 "Boot Process & Kernel" \
        "The full boot timeline, GRUB and alternative boot managers, kernel panic recovery, and building a kernel from source. There is nothing left on this box, from power-on to a running shell, that you can't explain or fix." \
        "Tier 11: Media Management: ffmpeg, library organization, and home media servers."
}

# ---- TIER 11: MEDIA MANAGEMENT ----

run_level_55() {
    level_intro 55 "ffmpeg Basics" \
        "ffmpeg is the tool underneath nearly every media server, converter, and streaming pipeline on Linux, whether or not the front-end app admits it. Transcoding, extracting audio, and pulling a single frame out of a video are all the same tool, just different flags." \
        "🎞️   ffmpeg -i  |  -vn  |  -c:v  |  -ss  |  ffprobe"
    setup_game_env

    run_challenge "Convert a Container Format" \
        "Convert ${YELLOW}input.mp4${NC} to ${YELLOW}output.mkv${NC}.\n\n  With no codec flags, ffmpeg just repackages the existing streams into the new container, fast, no quality loss, because nothing is actually re-encoded." \
        "ffmpeg -i input.mp4 output.mkv: -i specifies the input, the output filename's extension tells ffmpeg the target container." \
        'chk "^ffmpeg -i input\\.mp4 output\\.mkv"' 15

    run_challenge "Extract Just the Audio" \
        "Pull the audio track out of ${YELLOW}input.mp4${NC} and save it as ${YELLOW}audio.mp3${NC}, discarding the video entirely." \
        "ffmpeg -i input.mp4 -vn audio.mp3: -vn (no video) strips the video stream, leaving just audio to encode into the output." \
        'chk "^ffmpeg -i input\\.mp4 -vn audio\\.mp3"' 15

    run_challenge "Re-encode with a Specific Codec" \
        "Re-encode ${YELLOW}input.mp4${NC} to ${YELLOW}output.mp4${NC} using the H.264 codec at quality level 23.\n\n  ${CYAN}-crf${NC} (constant rate factor) controls quality vs file size, lower is higher quality and bigger files. 18-28 is the normal usable range." \
        "ffmpeg -i input.mp4 -c:v libx264 -crf 23 output.mp4: -c:v sets the video codec, -crf sets quality." \
        'chk "^ffmpeg -i input\\.mp4 -c:v libx264"' 20

    run_challenge "Grab a Thumbnail Frame" \
        "Extract a single frame at the 10-second mark of ${YELLOW}input.mp4${NC} and save it as ${YELLOW}thumb.jpg${NC}." \
        "ffmpeg -i input.mp4 -ss 00:00:10 -vframes 1 thumb.jpg: -ss seeks to a timestamp, -vframes 1 grabs exactly one frame from that point." \
        'chk "^ffmpeg -i input\\.mp4 -ss.*-vframes 1"' 20

    run_challenge "Inspect a Media File" \
        "Before transcoding ${YELLOW}input.mp4${NC}, check its codec, resolution, duration, and bitrate without converting anything." \
        "ffprobe input.mp4: ffmpeg's companion inspection tool, reports everything about a media file's streams without touching it." \
        'chk "^ffprobe input\\.mp4"' 15

    cleanup_game_env
    level_complete 55
}

run_level_56() {
    level_intro 56 "Media Library Organization" \
        "A media library with a few hundred files stays manageable by memory. A media library with tens of thousands needs the same discipline any large filesystem does: find things by pattern, verify integrity, and never trust a manual rename spree not to break something." \
        "🗃️   find -iname  |  sha256sum  |  find -size  |  batch rename"
    setup_game_env

    run_challenge "Find Files by Pattern" \
        "Find every .mkv file anywhere under the current directory, regardless of case.\n\n  -iname matches case-insensitively, useful since media file extensions arrive in every capitalization imaginable depending on where they came from." \
        "find . -iname \"*.mkv\": -iname is the case-insensitive version of -name." \
        'chk "^find \\. -iname"' 15

    run_challenge "Generate Checksums" \
        "Generate SHA-256 checksums for every .mkv file in the current directory and save them to ${YELLOW}checksums.sha256${NC}.\n\n  This is how you prove a file wasn't silently corrupted during a copy, transfer, or years of sitting on aging storage." \
        "sha256sum *.mkv > checksums.sha256: writes one hash line per matched file, redirected into the checksum file." \
        'chk "^sha256sum \\*\\.mkv"' 20

    run_challenge "Verify Checksums Later" \
        "Some time later, verify every file listed in ${YELLOW}checksums.sha256${NC} still matches its recorded hash.\n\n  -c reports OK or FAILED for every file, immediately obvious which ones changed or corrupted." \
        "sha256sum -c checksums.sha256: -c checks every listed file against its stored hash instead of generating new ones." \
        'chk "^sha256sum -c"' 20

    run_challenge "Find Unusually Large Files" \
        "Find every file in the current directory tree larger than 5GB.\n\n  Handy for spotting a corrupted download that inflated to an absurd size, or just finding what's actually eating the disk." \
        "find . -size +5G: -size with a + matches anything larger than the given size." \
        'chk "^find \\. -size \\+5G"' 15

    run_challenge "Batch Rename an Extension" \
        "Rename every .avi file in the current directory to the same name with a .mp4 extension instead, in one loop.\n\n  \${f%.avi} strips the .avi suffix from the variable, letting you rebuild the new name from what's left." \
        "for f in *.avi; do mv \"\$f\" \"\${f%.avi}.mp4\"; done: loops every .avi file, strips the suffix, appends the new one." \
        'chk "^for f in \\*\\.avi.*done$"' 25

    cleanup_game_env
    level_complete 56
}

run_level_57() {
    level_intro 57 "Home Media Server Concepts" \
        "Running Jellyfin, Plex, or any home media server well comes down to a handful of sysadmin fundamentals: confirming hardware transcoding is actually available, laying out a library sanely, and watching resource usage while a dozen things transcode at once." \
        "📺   /dev/dri  |  nvidia-smi  |  library layout  |  iotop"
    setup_game_env

    run_challenge "Check for Hardware Transcode Support" \
        "Check whether this machine has an Intel Quick Sync (or similar) hardware video encoder available for transcoding.\n\n  If /dev/dri has render nodes present, hardware transcoding is possible, letting the CPU sit mostly idle even while multiple streams transcode at once." \
        "ls /dev/dri: lists render device nodes. No output usually means no hardware transcode acceleration is available." \
        'chk "^ls /dev/dri"' 15

    run_challenge "Check an NVIDIA GPU" \
        "This box has an NVIDIA card instead. Check its status and confirm it's available for hardware transcoding.\n\n  Also shows temperature, memory usage, and which processes currently have the GPU open, invaluable while diagnosing a transcode that's running hot or stuck." \
        "nvidia-smi: NVIDIA's own status and monitoring tool, works the same for a media server GPU as it does for anything else." \
        'exact "nvidia-smi"' 15

    run_challenge "Lay Out a Media Library" \
        "Create a standard media library directory structure under ${YELLOW}media/${NC}, with separate movies, tv, and music folders, in one command.\n\n  Brace expansion creates all three subdirectories in a single call, no separate mkdir per folder needed." \
        "mkdir -p media/{movies,tv,music}: -p creates parent directories as needed, brace expansion creates all three siblings at once." \
        'chk "^mkdir -p media/\\{movies,tv,music\\}"' 20

    run_challenge "Confirm Space Before a Big Import" \
        "Before importing a large batch of new media, confirm there's enough free space on ${YELLOW}/mnt/media${NC}." \
        "df -h /mnt/media: the same df you already know, pointed at the specific mount your library lives on." \
        'chk "^df -h /mnt/media"' 10

    run_challenge "Watch Disk I/O During Heavy Transcoding" \
        "Several streams are transcoding at once and the server feels sluggish. Watch live disk I/O per process to see what's actually hammering the disk.\n\n  top and htop show CPU and memory well, but a transcode job that's disk-bound rather than CPU-bound only shows up clearly here." \
        "sudo iotop: live per-process disk read/write rates, the disk equivalent of top." \
        'chk "^sudo iotop"' 20

    cleanup_game_env
    tier_complete 57 "Media Management" \
        "ffmpeg for transcoding and extraction, library organization and integrity checking at scale, and the sysadmin side of running a real home media server. The nerdy home-lab half of this job is just as covered as the corporate half." \
        "Tier 12: Desktop Ricing: window managers, i3, awesomewm, and dotfiles."
}

# ---- TIER 12: DESKTOP RICING (FINAL) ----

run_level_58() {
    level_intro 58 "X11, Wayland &amp; Window Managers" \
        "Everything below this line has been servers and infrastructure. This last tier is the reward: making your OWN desktop look and feel exactly the way you want. It starts with knowing what you're actually running, X11 or Wayland, and what window managers are available to you." \
        "🖼️   XDG_SESSION_TYPE  |  loginctl  |  xsessions  |  wayland-sessions"
    setup_game_env

    run_challenge "Identify Your Session Type" \
        "Check whether your current graphical session is running on X11 or Wayland.\n\n  Most tiling window managers support one or the other, occasionally both, this decides which ones are even an option for you." \
        "echo \$XDG_SESSION_TYPE: reads the environment variable the session manager sets, prints either x11 or wayland." \
        'chk "^echo \\\$XDG_SESSION_TYPE"' 15

    run_challenge "List Active Sessions" \
        "List every active login session on this machine, graphical or otherwise." \
        "loginctl list-sessions: shows every session systemd-logind knows about, with user, TTY, and session type." \
        'chk "^loginctl list-sessions"' 15

    run_challenge "List Available X11 Window Managers" \
        "List every X11 session available to choose from at your display manager's login screen." \
        "ls /usr/share/xsessions: each .desktop file here becomes a selectable session at login, one per installed X11 window manager or desktop environment." \
        'chk "^ls /usr/share/xsessions"' 15

    run_challenge "List Available Wayland Sessions" \
        "Do the same thing, but for Wayland-native sessions instead of X11 ones." \
        "ls /usr/share/wayland-sessions: identical idea to xsessions, just the Wayland-native equivalent directory." \
        'chk "^ls /usr/share/wayland-sessions"' 15

    run_challenge "Check if a Window Manager Is Running" \
        "Check whether the ${YELLOW}i3${NC} process is currently running on this system." \
        "pgrep -l i3: -l prints the matched process's name alongside its PID, quick confirmation a specific WM or daemon is actually alive." \
        'chk "^pgrep -l i3"' 15

    cleanup_game_env
    level_complete 58
}

run_level_59() {
    level_intro 59 "i3 Window Manager" \
        "i3 is a tiling window manager: no dragging windows around, everything snaps into a grid you control entirely from the keyboard. It's one config file, one language (plain key=value-style bindings), and it's the single most common gateway drug into the whole ricing hobby." \
        "🪟   i3-msg reload  |  bindsym  |  workspace  |  move container"
    setup_game_env

    run_challenge "Reload the Config Live" \
        "You just edited i3's config file. Apply the change immediately, without restarting i3 or losing your current window layout.\n\n  reload is safe and near-instant, it re-reads the config and applies it to the running session." \
        "i3-msg reload: sends the reload command to the running i3 instance over its IPC socket." \
        'chk "^i3-msg reload"' 15

    run_challenge "Restart i3 In Place" \
        "Something's gone wrong with i3's internal state, more than reload can fix. Restart i3 entirely, but keep your layout and running applications exactly where they are." \
        "i3-msg restart: unlike reload, this restarts the i3 process itself, but preserves the current layout in memory across the restart." \
        'chk "^i3-msg restart"' 15

    run_challenge "Bind a Terminal Shortcut" \
        "Write the config line that binds ${YELLOW}\$mod+Return${NC} to launch the alacritty terminal.\n\n  \$mod is normally set to the Super/Windows key earlier in the config. Almost every i3 config's very first bindsym is exactly this one." \
        "bindsym \$mod+Return exec alacritty: bindsym binds a key combo, exec runs a program when it's pressed." \
        'chk "^bindsym \\\$mod\\+Return exec"' 20

    run_challenge "Bind a Workspace Switch" \
        "Write the config line that switches to workspace 2 when ${YELLOW}\$mod+2${NC} is pressed." \
        "bindsym \$mod+2 workspace 2: same bindsym pattern, workspace <n> is the built-in command that switches to a numbered workspace." \
        'chk "^bindsym \\\$mod\\+2 workspace 2"' 20

    run_challenge "Bind Moving a Window to a Workspace" \
        "Write the config line that moves the currently focused window to workspace 2 when ${YELLOW}\$mod+Shift+2${NC} is pressed, without switching your own view to it.\n\n  The Shift-modifier convention (move the window) alongside the plain version (switch to the workspace) is standard across almost every i3 config you'll ever see." \
        "bindsym \$mod+Shift+2 move container to workspace 2: same key combo pattern as switching, move container to workspace <n> relocates the focused window instead." \
        'chk "^bindsym \\\$mod\\+Shift\\+2 move container to workspace 2"' 25

    cleanup_game_env
    level_complete 59
}

run_level_60() {
    level_intro 60 "AwesomeWM &amp; Compositors" \
        "AwesomeWM takes the tiling idea further: the entire window manager is configured and scriptable in Lua, not a static config file. Pair any tiling WM with a compositor like picom and you get the transparency, shadows, and smooth animations that turn a functional desktop into a genuinely nice-looking one." \
        "🎨   rc.lua  |  Lua  |  picom  |  compositor"
    setup_game_env

    run_challenge "Name AwesomeWM's Config Language" \
        "AwesomeWM's entire configuration, rc.lua, isn't a static config format like i3's. What programming language is it actually written in?" \
        "Lua: a small, fast scripting language. AwesomeWM's config is executable Lua code, not just key=value settings." \
        'chk "^[Ll]ua$"' 15

    run_challenge "Launch a Compositor" \
        "Start the picom compositor in the background, giving your window manager transparency, shadows, and smooth rendering it doesn't provide on its own.\n\n  A tiling WM handles window placement, nothing about how they're rendered. A compositor is a separate process layered on top for exactly that." \
        "picom &: launches picom in the background so your shell (or startup script) isn't blocked waiting on it." \
        'chk "^picom &"' 15

    run_challenge "Launch with a Specific Config" \
        "Launch picom using a config file at ${YELLOW}~/.config/picom.conf${NC} instead of its defaults.\n\n  This is where blur, shadow radius, fade duration, and opacity rules for individual applications all live." \
        "picom --config ~/.config/picom.conf: --config points picom at a specific configuration file." \
        'chk "^picom --config"' 20

    run_challenge "Check for a Running Compositor" \
        "Before launching picom, check whether an instance is already running, so you don't end up with two competing compositors fighting over the same windows." \
        "pgrep picom: same pgrep pattern as checking for a window manager, just pointed at picom's process name instead." \
        'chk "^pgrep picom"' 15

    run_challenge "Cleanly Restart the Compositor" \
        "Kill any running picom instance and relaunch it as a proper background daemon, in one line.\n\n  -b daemonizes picom itself, so you don't need the shell's own & backgrounding on top of it." \
        "pkill picom && picom -b: pkill ends the old instance, && only proceeds to relaunch if that succeeded, -b daemonizes the new one." \
        'chk "^pkill picom && picom -b"' 20

    cleanup_game_env
    level_complete 60
}

run_level_61() {
    level_intro 61 "Dotfiles &amp; Theming" \
        "The final skill, and the one that ties the whole rice together: managing every config file you've just spent three levels tuning, so a single command reproduces your entire setup on a brand new machine. Then the fun part, making it actually look good." \
        "🌈   bare git repo  |  stow  |  gsettings  |  feh"
    setup_game_env

    run_challenge "Initialize a Bare Dotfiles Repo" \
        "Set up a bare git repository at ${YELLOW}\$HOME/.dotfiles${NC} to track your config files directly from your home directory, without a separate checked-out copy sitting alongside the originals.\n\n  This is the classic 'dotfiles as a bare repo' trick: no symlinks, no separate folder, git just tracks files that are already exactly where they need to be." \
        "git init --bare \$HOME/.dotfiles: --bare creates a repo with no working directory of its own, since your actual home directory IS the working tree." \
        'chk "^git init --bare"' 20

    run_challenge "Create the Management Alias" \
        "Create the shell alias that lets you run git commands against that bare repo, using your home directory as the working tree, without it being your normal git repo for everything else in \$HOME.\n\n  Every dotfiles-as-bare-repo guide starts with exactly this alias. From here, ${CYAN}config add ~/.vimrc${NC} and ${CYAN}config commit${NC} work like any other git repo." \
        "alias config='/usr/bin/git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME': --git-dir points at the bare repo, --work-tree overrides it to your actual home directory." \
        'chk "^alias config="' 25

    run_challenge "Deploy Dotfiles with Stow" \
        "You keep dotfiles organized in package subfolders instead, and want to symlink the ${YELLOW}nvim${NC} package into your home directory.\n\n  GNU Stow is the other popular dotfiles approach: real files live in a package folder, stow symlinks them into place, and removing them cleanly is one command away too." \
        "stow nvim: symlinks every file inside the nvim/ folder into the parent directory, preserving the relative structure." \
        'exact "stow nvim"' 20

    run_challenge "Set a GTK Theme" \
        "Set your GTK theme to ${YELLOW}Nordic${NC} using gsettings.\n\n  This is the GNOME/GTK equivalent of what a window manager's own config handles for window borders and bars, the theme for GTK applications themselves." \
        "gsettings set org.gnome.desktop.interface gtk-theme \"Nordic\": gsettings reads and writes the same settings a GNOME settings panel would." \
        'chk "^gsettings set org\\.gnome\\.desktop\\.interface gtk-theme"' 20

    run_challenge "Set the Wallpaper" \
        "Set your desktop wallpaper to ${YELLOW}~/Pictures/wallpaper.jpg${NC}, scaled to fill the screen.\n\n  feh is the classic lightweight image viewer that doubles as the standard wallpaper setter across nearly every tiling WM setup." \
        "feh --bg-fill ~/Pictures/wallpaper.jpg: --bg-fill scales and crops the image to fill the screen without distorting its aspect ratio." \
        'chk "^feh --bg-fill"' 20

    cleanup_game_env
    graduation_ceremony
}

# The final beat of the game. Not just a banner: a certificate written to
# disk the player can actually keep, plus a closing speech that says the
# quiet part out loud: this was never a game, it was onboarding.
graduation_ceremony() {
    local elapsed_min=0 now
    now=$(date +%s 2>/dev/null || echo 0)
    [ "$RUN_START_TS" -gt 0 ] && [ "$now" -gt "$RUN_START_TS" ] && \
        elapsed_min=$(( (now - RUN_START_TS) / 60 ))

    local earned=0
    [ "$TOTAL_HINTS_USED" -eq 0 ] && earned=$((earned + 1))
    [ "$TOTAL_SKIPS_USED" -eq 0 ] && earned=$((earned + 1))
    [ "$TOTAL_LIVES_LOST" -eq 0 ] && earned=$((earned + 1))
    [ "$PLAYER_BEST_STREAK" -ge 5 ] && earned=$((earned + 1))
    [ "$PLAYER_BEST_STREAK" -ge 10 ] && earned=$((earned + 1))
    earned=$((earned + 1))  # Graduate, always true by this point

    local award_date
    award_date=$(date "+%Y-%m-%d" 2>/dev/null || echo "today")

    clear_screen
    printf '%b\n' "${YELLOW}"
    echo ' ██████╗ ██████╗ ███╗   ██╗ ██████╗ ██████╗  █████╗ ████████╗███████╗██╗'
    echo '██╔════╝██╔═══██╗████╗  ██║██╔════╝ ██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██║'
    echo '██║     ██║   ██║██╔██╗ ██║██║  ███╗██████╔╝███████║   ██║   ███████╗██║'
    echo '██║     ██║   ██║██║╚██╗██║██║   ██║██╔══██╗██╔══██║   ██║   ╚════██║╚═╝'
    echo '╚██████╗╚██████╔╝██║ ╚████║╚██████╔╝██║  ██║██║  ██║   ██║   ███████║██╗'
    echo ' ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝'
    printf '%b\n' "${NC}"

    printf '%b\n' "${YELLOW}╔═══════════════════════════════════════════════════════════════════════╗"
    printf '║%b%-75s%b║\n' "${WHITE}${BOLD}" "$(printf '%*s%s' 24 '' "CERTIFICATE OF COMPLETION")" "${NC}${YELLOW}"
    printf '║%75s║\n' ""
    printf '║%b%-75s%b║\n' "${WHITE}" "  This certifies that" "${YELLOW}"
    printf '║%b%-75s%b║\n' "${LCYAN}${BOLD}" "  ${PLAYER_NAME}" "${NC}${YELLOW}"
    printf '║%75s║\n' ""
    printf '║%b%-75s%b║\n' "${WHITE}" "  has completed all ${TOTAL_LEVELS} levels across all twelve tiers, from" "${YELLOW}"
    printf '║%b%-75s%b║\n' "${WHITE}" "  basic navigation to storage, networking, SAN, kernels, and ricing," "${YELLOW}"
    printf '║%75s║\n' ""
    printf '║%b%-75s%b║\n' "${LGREEN}${BOLD}" "  and is certified ready to administrate a corporate network AND" "${NC}${YELLOW}"
    printf '║%b%-75s%b║\n' "${LGREEN}${BOLD}" "  run a genuinely great-looking home setup." "${NC}${YELLOW}"
    printf '║%75s║\n' ""
    printf '║%b%-75s%b║\n' "${DIM}" "  XP: ${PLAYER_XP}  Best streak: ${PLAYER_BEST_STREAK}  Badges: ${earned}/6  Awarded: ${award_date}" "${YELLOW}"
    printf '║%b%-75s%b║\n' "${DIM}" "  BashQuest by Tony \"Hardlygospel\" Hosaroygard, github.com/hardlygospel" "${YELLOW}"
    printf '%b\n' "╚═══════════════════════════════════════════════════════════════════════╝${NC}"

    local cert_file="$SAVE_DIR/${PLAYER_NAME}.certificate.txt"
    {
        echo "BASHQUEST - CERTIFICATE OF COMPLETION"
        echo ""
        echo "This certifies that ${PLAYER_NAME}"
        echo "has completed all ${TOTAL_LEVELS} levels of BashQuest across all twelve tiers:"
        echo "Beginner, Intermediate, Pipes & Patterns, Power Tools, Expert,"
        echo "Storage & Filesystems, File Editing & Sharing, Networking,"
        echo "Storage Networking & SAN, Boot Process & Kernel, Media Management,"
        echo "and Desktop Ricing."
        echo ""
        echo "Certified ready to administrate a corporate network AND run a"
        echo "genuinely great-looking home setup."
        echo ""
        echo "Final XP: ${PLAYER_XP}"
        echo "Best streak: ${PLAYER_BEST_STREAK}"
        echo "Achievements: ${earned}/6"
        echo "Time played: ${elapsed_min} minutes"
        echo "Awarded: ${award_date}"
        echo ""
        echo "BashQuest by Tony \"Hardlygospel\" Hosaroygard"
        echo "github.com/hardlygospel/bashquest"
        echo "Copyright (C) 2026 Tony Hosaroygard. GPL-3.0."
    } > "$cert_file" 2>/dev/null

    printf '\n'
    root_speech \
        "${TOTAL_LEVELS} levels. Twelve tiers. Every fire I put in front of you, lit on purpose." \
        "You started at ls and pwd. You're finishing having built and grown storage" \
        "with LVM, shared it over Samba and NFS, run a real network with VLANs and" \
        "a firewall, connected to a SAN over iSCSI, recovered from a kernel panic," \
        "and built a kernel from source. Hand you a login prompt on a server you've" \
        "never seen, in a datacenter you've never visited, and you'd know exactly" \
        "where to start. That's not a course anymore. That's the job." \
        "And when the pager's finally quiet, you now also know how to make your own" \
        "desktop look genuinely good instead of just functional. That part matters too." \
        "A copy of this is saved at ${cert_file}." \
        "I'm Tony Hosaroygard, github.com/hardlygospel, and this is everything I know." \
        "Go build something, ${PLAYER_NAME}."

    PLAYER_LEVEL=$((TOTAL_LEVELS + 1)); save_progress
    press_enter; main_menu
}

# ---- ROUTER ----

dispatch_level() {
    case $1 in
         1) run_level_1  ;;  2) run_level_2  ;;  3) run_level_3  ;;  4) run_level_4  ;;
         5) run_level_5  ;;  6) run_level_6  ;;  7) run_level_7  ;;  8) run_level_8  ;;
         9) run_level_9  ;; 10) run_level_10 ;; 11) run_level_11 ;; 12) run_level_12 ;;
        13) run_level_13 ;; 14) run_level_14 ;; 15) run_level_15 ;; 16) run_level_16 ;;
        17) run_level_17 ;; 18) run_level_18 ;; 19) run_level_19 ;; 20) run_level_20 ;;
        21) run_level_21 ;; 22) run_level_22 ;; 23) run_level_23 ;; 24) run_level_24 ;;
        25) run_level_25 ;; 26) run_level_26 ;; 27) run_level_27 ;; 28) run_level_28 ;;
        29) run_level_29 ;; 30) run_level_30 ;; 31) run_level_31 ;; 32) run_level_32 ;;
        33) run_level_33 ;; 34) run_level_34 ;; 35) run_level_35 ;; 36) run_level_36 ;;
        37) run_level_37 ;; 38) run_level_38 ;; 39) run_level_39 ;; 40) run_level_40 ;;
        41) run_level_41 ;; 42) run_level_42 ;; 43) run_level_43 ;; 44) run_level_44 ;;
        45) run_level_45 ;; 46) run_level_46 ;; 47) run_level_47 ;; 48) run_level_48 ;;
        49) run_level_49 ;; 50) run_level_50 ;; 51) run_level_51 ;; 52) run_level_52 ;;
        53) run_level_53 ;; 54) run_level_54 ;; 55) run_level_55 ;; 56) run_level_56 ;;
        57) run_level_57 ;; 58) run_level_58 ;; 59) run_level_59 ;; 60) run_level_60 ;;
        61) run_level_61 ;;
        *) printf '%b\n' "\n${LGREEN}  🏆 All ${TOTAL_LEVELS} levels complete, true master!${NC}"; press_enter; main_menu ;;
    esac
}

run_current_level() {
    dispatch_level "$PLAYER_LEVEL"
}

# ---- ENTRY ----

trap 'cleanup_game_env' EXIT
trap 'printf '%b\n' "\n${YELLOW}Use option [5] Logout or [3] Quit to exit cleanly.${NC}"' INT

boot_sequence
startup_screen
