#!/bin/bash
# BashQuest — The Linux Command Learning Adventure
# Copyright (C) 2026 Tony Hosaroygard <tasmaniamate@gmail.com>
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

RED=$'\033[0;31m';    LRED=$'\033[1;31m'
GREEN=$'\033[0;32m';  LGREEN=$'\033[1;32m'
YELLOW=$'\033[1;33m'
BLUE=$'\033[0;34m';   LBLUE=$'\033[1;34m'
MAGENTA=$'\033[0;35m';LMAGENTA=$'\033[1;35m'
CYAN=$'\033[0;36m';   LCYAN=$'\033[1;36m'
WHITE=$'\033[1;37m'
BOLD=$'\033[1m';      DIM=$'\033[2m'
BG_RED=$'\033[41m';   BG_GREEN=$'\033[42m'
BG_BLUE=$'\033[44m';  BG_MAGENTA=$'\033[45m'
NC=$'\033[0m'

SAVE_DIR="$HOME/.bashquest"
USERS_FILE="$SAVE_DIR/users.db"
mkdir -p "$SAVE_DIR"

PLAYER_NAME=""
PLAYER_LEVEL=1
PLAYER_XP=0
PLAYER_LIVES=3
GAME_DIR=""

# ---- DISPLAY ----

clear_screen() { clear; }

print_banner() {
    clear_screen
    echo -e "${LCYAN}"
    echo ' ██████╗  █████╗ ███████╗██╗  ██╗ ██████╗ ██╗   ██╗███████╗███████╗████████╗'
    echo ' ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔═══██╗██║   ██║██╔════╝██╔════╝╚══██╔══╝'
    echo ' ██████╔╝███████║███████╗███████║██║   ██║██║   ██║█████╗  ███████╗   ██║   '
    echo ' ██╔══██╗██╔══██║╚════██║██╔══██║██║▄▄ ██║██║   ██║██╔══╝  ╚════██║   ██║   '
    echo ' ██████╔╝██║  ██║███████║██║  ██║╚██████╔╝╚██████╔╝███████╗███████║   ██║   '
    echo ' ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚══▀▀╝  ╚═════╝ ╚══════╝╚══════╝   ╚═╝   '
    echo -e "${NC}${YELLOW}              ⚡  The Ultimate Linux Command Learning Adventure  ⚡${NC}"
    echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

status_bar() {
    echo -e "\n${BG_BLUE}${WHITE}  👤 ${PLAYER_NAME}  ${NC}${BG_MAGENTA}${WHITE}  ⭐ Level ${PLAYER_LEVEL}  ${NC}${BG_GREEN}${WHITE}  ✨ XP: ${PLAYER_XP}  ${NC}${BG_RED}${WHITE}  ❤  Lives: ${PLAYER_LIVES}  ${NC}"
    echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

press_enter() {
    echo -e "\n${DIM}Press ${YELLOW}[ENTER]${NC}${DIM} to continue...${NC}"
    read -r
}

type_text() {
    local text="$1" delay="${2:-0.025}" i
    for ((i=0; i<${#text}; i++)); do
        printf "%s" "${text:$i:1}"
        sleep "$delay"
    done
    echo
}

show_xp_gain() {
    local amount="$1"
    PLAYER_XP=$((PLAYER_XP + amount))
    echo -e "\n${BG_GREEN}${WHITE}  ✨ +${amount} XP!  Total: ${PLAYER_XP}  ${NC}"
    save_progress
}

wrong_answer() {
    PLAYER_LIVES=$((PLAYER_LIVES - 1))
    save_progress
    if [ "$PLAYER_LIVES" -le 0 ]; then
        game_over
        return 1
    fi
    echo -e "\n${LRED}  ✗  Incorrect!${NC}  Lives remaining: ${YELLOW}${PLAYER_LIVES} ❤${NC}"
    return 0
}

game_over() {
    clear_screen
    echo -e "${LRED}"
    echo '  ██████╗  █████╗ ███╗   ███╗███████╗     ██████╗ ██╗   ██╗███████╗██████╗ '
    echo ' ██╔════╝ ██╔══██╗████╗ ████║██╔════╝    ██╔═══██╗██║   ██║██╔════╝██╔══██╗'
    echo ' ██║  ███╗███████║██╔████╔██║█████╗      ██║   ██║██║   ██║█████╗  ██████╔╝'
    echo ' ██║   ██║██╔══██║██║╚██╔╝██║██╔══╝      ██║   ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗'
    echo ' ╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗    ╚██████╔╝ ╚████╔╝ ███████╗██║  ██║'
    echo '  ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝     ╚═════╝   ╚═══╝  ╚══════╝╚═╝  ╚═╝'
    echo -e "${NC}"
    echo -e "${YELLOW}  You ran out of lives, ${BOLD}${PLAYER_NAME}${NC}${YELLOW}. Better luck next time!${NC}"
    echo -e "${CYAN}  Final XP: ${PLAYER_XP}  |  Level reached: ${PLAYER_LEVEL}${NC}"
    PLAYER_LIVES=3
    save_progress
    press_enter
    main_menu
}

# ---- SAVE / LOAD ----

save_progress() {
    printf 'PLAYER_LEVEL=%s\nPLAYER_XP=%s\nPLAYER_LIVES=%s\n' \
        "$PLAYER_LEVEL" "$PLAYER_XP" "$PLAYER_LIVES" \
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
    echo -e "\n${LCYAN}╔═══════════════════════════════╗"
    echo -e "║     CREATE YOUR ACCOUNT       ║"
    echo -e "╚═══════════════════════════════╝${NC}\n"
    local username password confirm hashed
    while true; do
        printf "${YELLOW}Choose a username: ${NC}"; read -r username
        username="${username//[[:space:]]/}"
        [ -z "$username" ] && echo -e "${RED}Username cannot be empty.${NC}" && continue
        grep -q "^${username}:" "$USERS_FILE" 2>/dev/null && echo -e "${RED}Username taken.${NC}" && continue
        break
    done
    while true; do
        printf "${YELLOW}Choose a password: ${NC}"; read -rs password; echo
        [ ${#password} -lt 4 ] && echo -e "${RED}Minimum 4 characters.${NC}" && continue
        printf "${YELLOW}Confirm password: ${NC}";  read -rs confirm; echo
        [ "$password" != "$confirm" ] && echo -e "${RED}Passwords do not match.${NC}" && continue
        break
    done
    hashed=$(hash_pw "$password")
    echo "${username}:${hashed}" >> "$USERS_FILE"
    PLAYER_NAME="$username"; PLAYER_LEVEL=1; PLAYER_XP=0; PLAYER_LIVES=3
    save_progress
    echo -e "\n${LGREEN}  ✓ Account created! Welcome, ${BOLD}${username}${NC}${LGREEN}!${NC}"
    sleep 1; main_menu
}

login_user() {
    clear_screen; print_banner
    echo -e "\n${LCYAN}╔═══════════════════════════════╗"
    echo -e "║       TERMINAL LOGIN          ║"
    echo -e "╚═══════════════════════════════╝${NC}\n"
    echo -e "${GREEN}BashQuest OS v2.4.1 LTS (GNU/Linux 5.15.0-amd64)${NC}"
    echo -e "${DIM}$(date)${NC}\n"
    local attempts=0 username password hashed
    while [ $attempts -lt 3 ]; do
        printf "${WHITE}login: ${NC}";    read -r username
        printf "${WHITE}Password: ${NC}"; read -rs password; echo
        hashed=$(hash_pw "$password")
        if grep -q "^${username}:${hashed}$" "$USERS_FILE" 2>/dev/null; then
            PLAYER_NAME="$username"; load_progress
            echo -e "\n${LGREEN}  ✓ Authentication successful.${NC}"
            sleep 0.6; main_menu; return
        fi
        attempts=$((attempts + 1))
        echo -e "${RED}  Login incorrect.${NC}\n"
    done
    echo -e "${LRED}  Too many failed attempts.${NC}"; sleep 2; startup_screen
}

# ---- MENUS ----

main_menu() {
    clear_screen; print_banner; status_bar
    echo -e "\n${LCYAN}╔══════════════════════════════════════╗"
    echo -e "║             MAIN MENU                ║"
    echo -e "╠══════════════════════════════════════╣"
    echo -e "║  ${LGREEN}[1]${LCYAN} Continue Adventure              ║"
    echo -e "║  ${YELLOW}[2]${LCYAN} Level Select                    ║"
    echo -e "║  ${BLUE}[3]${LCYAN} Command Reference               ║"
    echo -e "║  ${MAGENTA}[4]${LCYAN} Leaderboard                    ║"
    echo -e "║  ${RED}[5]${LCYAN} Logout                         ║"
    echo -e "╚══════════════════════════════════════╝${NC}\n"
    printf "${YELLOW}Choice: ${NC}"; read -r choice
    case $choice in
        1) run_current_level ;;
        2) level_select ;;
        3) command_reference ;;
        4) leaderboard ;;
        5) startup_screen ;;
        *) main_menu ;;
    esac
}

level_select() {
    clear_screen; print_banner; status_bar
    echo -e "\n${LCYAN}╔══════════════════════════════════════════════════════╗"
    echo -e "║                   LEVEL SELECT                      ║"
    echo -e "╠══════════════════════════════════════════════════════╣${NC}"
    local -a levels=(
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
    )
    for entry in "${levels[@]}"; do
        IFS='|' read -r num name cmds icon <<< "$entry"
        local n
        n=$(echo "$num" | tr -d ' ')
        if [ "$n" -le "$PLAYER_LEVEL" ]; then
            echo -e "${LCYAN}║ ${LGREEN}[${num}]${NC} ${icon} ${WHITE}${BOLD}${name}${NC} ${DIM}${cmds}${NC}"
        else
            echo -e "${LCYAN}║ ${DIM}[${num}] ${icon} ${name} ${cmds} [LOCKED]${NC}"
        fi
    done
    echo -e "${LCYAN}╚══════════════════════════════════════════════════════╝${NC}"
    printf "\n${YELLOW}Enter level (1-28) or 0 to go back: ${NC}"; read -r choice
    [ "$choice" = "0" ] && main_menu && return
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le 28 ] && [ "$choice" -le "$PLAYER_LEVEL" ]; then
        dispatch_level "$choice"
    else
        echo -e "${RED}  Locked or invalid!${NC}"; sleep 1; level_select
    fi
}

command_reference() {
    clear_screen; print_banner
    echo -e "\n${LCYAN}╔══════════════════════════════════════════════════════════════════╗"
    echo -e "║                      COMMAND REFERENCE                          ║"
    echo -e "╚══════════════════════════════════════════════════════════════════╝${NC}\n"
    echo -e "  ${LGREEN}NAVIGATION ${NC}  ls  cd  pwd  mkdir  rmdir  tree"
    echo -e "  ${YELLOW}FILES      ${NC}  cat  touch  cp  mv  rm  ln  tar  gzip  zip  less"
    echo -e "  ${CYAN}SEARCH     ${NC}  grep  grep -E  grep -v  grep -r  find  locate"
    echo -e "  ${MAGENTA}PERMISSIONS${NC}  chmod  chown  whoami  id  su  sudo"
    echo -e "  ${BLUE}PROCESSES  ${NC}  ps  kill  jobs  bg  fg  nohup  lsof"
    echo -e "  ${LRED}TEXT PROC  ${NC}  awk  sed  cut  tr  sort  uniq  head  tail  tee"
    echo -e "  ${LCYAN}NETWORKING ${NC}  curl  wget  ping  ssh  scp  ssh-keygen  ss"
    echo -e "  ${WHITE}SCRIPTING  ${NC}  echo  read  if  for  while  case  function  trap"
    echo -e "  ${LMAGENTA}DISK/SYS   ${NC}  df  du  lsblk  mount  uname  uptime  free  lscpu"
    echo -e "  ${YELLOW}USERS/SVCS ${NC}  useradd  usermod  passwd  systemctl  journalctl"
    echo -e "  ${LGREEN}REDIRECT   ${NC}  >  >>  <  2>  2>&1  /dev/null  |  tee  xargs"
    echo -e "  ${CYAN}CRON       ${NC}  crontab  at  * * * * *  (min hr day mon wday)"
    echo -e "  ${MAGENTA}STRINGS    ${NC}  \${#v}  \${v:0:n}  \${v%p}  \${v//f/r}  printf"
    echo -e "  ${BLUE}PACKAGES   ${NC}  apt  dnf  yum  brew  pacman  pip  snap"
    echo -e "\n${DIM}  In-game: type '${YELLOW}hint${NC}${DIM}' for a clue, '${YELLOW}skip${NC}${DIM}' to skip (costs 1 life).${NC}"
    echo -e "${DIM}  Platform notes: macOS uses md5/vm_stat/sysctl/brew vs Linux md5sum/free/lscpu/apt.${NC}"
    press_enter; main_menu
}

leaderboard() {
    clear_screen; print_banner
    echo -e "\n${YELLOW}╔══════════════════════════════════════╗"
    echo -e "║            LEADERBOARD               ║"
    echo -e "╚══════════════════════════════════════╝${NC}\n"
    echo -e "${BOLD}${WHITE}  #    Player            Level   XP${NC}"
    echo -e "${DIM}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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

startup_screen() {
    PLAYER_NAME=""; PLAYER_LEVEL=1; PLAYER_XP=0; PLAYER_LIVES=3
    clear_screen; print_banner
    echo -e "\n${LCYAN}╔══════════════════════════════════════╗"
    echo -e "║      WELCOME TO BASHQUEST  🐧         ║"
    echo -e "╠══════════════════════════════════════╣"
    echo -e "║  ${LGREEN}[1]${LCYAN} Login                          ║"
    echo -e "║  ${YELLOW}[2]${LCYAN} Create Account                 ║"
    echo -e "║  ${RED}[3]${LCYAN} Quit                           ║"
    echo -e "╚══════════════════════════════════════╝${NC}\n"
    printf "${YELLOW}Choice: ${NC}"; read -r choice
    case $choice in
        1) login_user ;;
        2) register_user ;;
        3) echo -e "\n${CYAN}Thanks for playing BashQuest! Keep hacking! 🐧${NC}\n"; exit 0 ;;
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
    echo "Welcome to BashQuest — your Linux adventure begins!"  > "$GAME_DIR/home/welcome.txt"
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
        echo -e "\n${LCYAN}┌──────────────────────────────────────────────────┐"
        printf "│  ${YELLOW}%-48s${LCYAN}│\n" "CHALLENGE: $title"
        echo -e "└──────────────────────────────────────────────────┘${NC}"
        echo -e "\n${WHITE}${desc}${NC}\n"
        printf "${LGREEN}bashquest${NC}${CYAN}@terminal${NC}:${YELLOW}~\$${NC} "
        read -r user_input
        case "$user_input" in
            hint)
                echo -e "\n${YELLOW}  💡 HINT: ${hint}${NC}"
                continue ;;
            skip)
                echo -e "\n${DIM}  Skipped. -1 life.${NC}"
                PLAYER_LIVES=$((PLAYER_LIVES - 1))
                save_progress
                [ "$PLAYER_LIVES" -le 0 ] && game_over
                return ;;
        esac
        if eval "$check" 2>/dev/null; then
            echo -e "\n${LGREEN}  ✓  Correct! Well done!${NC}"
            show_xp_gain "$xp"
            sleep 0.5
            return
        else
            wrong_answer || return
            echo -e "${DIM}  Type '${YELLOW}hint${NC}${DIM}' for help or '${YELLOW}skip${NC}${DIM}' to skip.${NC}"
        fi
    done
}

level_intro() {
    local num="$1" title="$2" desc="$3" badge="$4"
    clear_screen; print_banner; status_bar
    echo -e "\n${BG_MAGENTA}${WHITE}  LEVEL ${num}: ${BOLD}${title}  ${NC}\n"
    echo -e "  ${badge}\n"
    type_text "  ${CYAN}${desc}${NC}" 0.018
    press_enter
}

level_complete() {
    local num="$1"
    clear_screen
    echo -e "${LGREEN}"
    echo ' ██╗     ███████╗██╗   ██╗███████╗██╗         ██████╗  ██████╗ ███╗   ██╗███████╗'
    echo ' ██║     ██╔════╝██║   ██║██╔════╝██║         ██╔══██╗██╔═══██╗████╗  ██║██╔════╝'
    echo ' ██║     █████╗  ██║   ██║█████╗  ██║         ██║  ██║██║   ██║██╔██╗ ██║█████╗  '
    echo ' ██║     ██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║         ██║  ██║██║   ██║██║╚██╗██║██╔══╝  '
    echo ' ███████╗███████╗ ╚████╔╝ ███████╗███████╗    ██████╔╝╚██████╔╝██║ ╚████║███████╗'
    echo ' ╚══════╝╚══════╝  ╚═══╝  ╚══════╝╚══════╝    ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝'
    echo -e "${NC}"
    echo -e "  ${YELLOW}⭐ Level ${num} Complete!${NC}   ${CYAN}XP: ${PLAYER_XP}${NC}"
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
        "The command is 'ls' — two letters, List fileS" \
        'chk "^ls( -[a-zA-Z]+)*$"' 10

    run_challenge "Where Am I?" \
        "Before navigating anywhere, you need to know WHERE you are right now.\nPrint the full path of your current working directory." \
        "pwd — Print Working Directory" \
        'exact "pwd"' 10

    run_challenge "Long Listing" \
        "List files with DETAILED info: permissions, owner, size, and date.\n\n  The ls command has a flag for this." \
        "ls -l  — long format. Also try ls -lh for human-readable sizes" \
        'chk "^ls -[a-zA-Z]*l[a-zA-Z]*$|^ls -l"' 15

    run_challenge "Show Hidden Files" \
        "Linux hides files that start with a dot (.). List ALL files including hidden ones.\n\n  You need a flag after ls to show ALL files." \
        "ls -a  — show ALL, including hidden .dotfiles  (ls -la for both)" \
        'chk "^ls -[a-zA-Z]*a[a-zA-Z]*"' 15

    run_challenge "Make a Directory" \
        "Create a new directory called ${YELLOW}projects${NC} in the current location.\n\n  Build your workspace!" \
        "mkdir projects  — MaKe DIRectory" \
        'chk "^mkdir [a-zA-Z0-9_-]+"' 20

    run_challenge "Navigate Into It" \
        "Change into the ${YELLOW}projects${NC} directory you just created." \
        "cd projects  — Change Directory" \
        'chk "^cd [a-zA-Z0-9_.~/-]+"' 15

    run_challenge "Go Home" \
        "Navigate back to your home directory. Every user has one.\n\n  There are multiple correct ways to do this!" \
        "cd ~  OR just  cd  (no argument) — both go home" \
        'chk "^cd( ~|$)"' 15

    run_challenge "Remove a Directory" \
        "Remove the empty directory called ${YELLOW}tmp${NC}.\n\n  Note: only works on EMPTY directories." \
        "rmdir tmp  — ReMove DIRectory (empty dirs only). Use rm -r for non-empty" \
        'chk "^(rmdir|rm -r) [a-zA-Z0-9_-]+"' 20

    cleanup_game_env
    level_complete 1
}

# ---- LEVEL 2: FILE OPERATIONS ----

run_level_2() {
    level_intro 2 "File Operations" \
        "You can navigate — now work WITH files. Creating, reading, copying, moving, deleting. These are the daily bread of any Linux user. Master these and you'll be flying." \
        "📁   Commands: cat  |  touch  |  cp  |  mv  |  rm  |  tar"
    setup_game_env

    run_challenge "Read a File" \
        "Read the contents of ${YELLOW}home/welcome.txt${NC} and print it to the terminal." \
        "cat home/welcome.txt  — conCATenate files to stdout" \
        'chk "^cat .+"' 10

    run_challenge "View First Lines" \
        "The log file ${YELLOW}var/log/error.log${NC} could be huge. Show just the first 2 lines." \
        "head -n 2 var/log/error.log  — shows first N lines (default 10)" \
        'chk "^head .+"' 15

    run_challenge "View Last Lines" \
        "Show the LAST 2 lines of ${YELLOW}var/log/error.log${NC}.\n\n  Like head but from the bottom." \
        "tail -n 2 var/log/error.log  — shows last N lines. tail -f follows live logs" \
        'chk "^tail .+"' 15

    run_challenge "Create an Empty File" \
        "Create a new empty file called ${YELLOW}notes.txt${NC}.\n\n  You're not writing to it yet, just creating it." \
        "touch notes.txt  — creates empty file or updates timestamps" \
        'chk "^touch .+"' 15

    run_challenge "Copy a File" \
        "Back up ${YELLOW}home/welcome.txt${NC} as ${YELLOW}home/welcome.bak${NC}." \
        "cp home/welcome.txt home/welcome.bak  — CoPy source destination" \
        'chk "^cp .+ .+"' 20

    run_challenge "Move / Rename" \
        "Rename ${YELLOW}notes.txt${NC} to ${YELLOW}mynotes.txt${NC}.\n\n  On Linux, rename and move are the SAME command!" \
        "mv notes.txt mynotes.txt  — MoVe (also used for renaming)" \
        'chk "^mv .+ .+"' 20

    run_challenge "Delete a File" \
        "Delete ${YELLOW}home/welcome.bak${NC} — we no longer need it.\n\n  ${LRED}Warning: rm is permanent. No recycle bin!${NC}" \
        "rm home/welcome.bak  — ReMove (permanent, use with care!)" \
        'chk "^rm( -[a-zA-Z]*)? .+"' 20

    run_challenge "Remove a Directory Recursively" \
        "Delete the ${YELLOW}tmp${NC} directory AND everything inside it." \
        "rm -r tmp  — -r means recursive (also rm -rf to skip confirmation)" \
        'chk "^rm -r[f]? .+|^rm -rf .+"' 20

    run_challenge "Create a tar Archive" \
        "Archive the ${YELLOW}home${NC} directory into a compressed file called ${YELLOW}home.tar.gz${NC}.\n\n  tar is the standard way to bundle files on Linux — like zip but better." \
        "tar -czf home.tar.gz home/  — c=create, z=gzip compress, f=filename" \
        'chk "^tar .*-[czf]*c[czf]*.* .+|^tar -czf .+ .+"' 25

    run_challenge "List Archive Contents" \
        "Without extracting it, list what's inside ${YELLOW}home.tar.gz${NC}.\n\n  Preview the archive before unpacking." \
        "tar -tzf home.tar.gz  — t=list contents, z=gzip, f=filename. No extraction." \
        'chk "^tar .*t.* .+"' 20

    run_challenge "Extract a tar Archive" \
        "Extract ${YELLOW}home.tar.gz${NC} into the current directory.\n\n  Unpack the archive in place." \
        "tar -xzf home.tar.gz  — x=extract, z=gzip, f=filename" \
        'chk "^tar .*x.* .+"' 20

    run_challenge "Extract to a Specific Directory" \
        "Extract ${YELLOW}home.tar.gz${NC} into the ${YELLOW}tmp${NC} directory instead of the current one." \
        "tar -xzf home.tar.gz -C tmp/  — -C sets the destination directory" \
        'chk "^tar .*x.*-C .+|^tar .*-C .+.*x"' 25

    cleanup_game_env
    level_complete 2
}

# ---- LEVEL 3: TEXT & SEARCH ----

run_level_3() {
    level_intro 3 "Text & Search" \
        "Data is everywhere. Finding what you need inside files and directories is a critical skill. grep and find are two of the most powerful commands in Linux — you'll use them constantly as a sysadmin or developer." \
        "🔍   Commands: grep  |  find  |  wc  |  sort  |  uniq  |  pipes"
    setup_game_env

    run_challenge "Search in a File" \
        "The file ${YELLOW}var/log/error.log${NC} has multiple lines. Show only lines containing the word ${YELLOW}ERROR${NC}." \
        "grep ERROR var/log/error.log  — Global Regular Expression Print" \
        'chk "^grep .+"' 15

    run_challenge "Case-Insensitive Search" \
        "Search for ${YELLOW}warning${NC} (any case) in ${YELLOW}var/log/error.log${NC}." \
        "grep -i warning var/log/error.log  — -i = ignore case" \
        'chk "^grep -[a-zA-Z]*i[a-zA-Z]* .+|^grep -i .+"' 20

    run_challenge "Find Files by Name" \
        "Find all ${YELLOW}.txt${NC} files in the current directory tree." \
        "find . -name '*.txt'  — search from . (here) by filename pattern" \
        'chk "^find .+"' 20

    run_challenge "Find by Type" \
        "Find all DIRECTORIES under the current path." \
        "find . -type d  — type d=directory, f=file, l=symlink" \
        'chk "^find .+-type .+"' 20

    run_challenge "Count Lines" \
        "Count how many lines are in ${YELLOW}home/scores.txt${NC}." \
        "wc -l home/scores.txt  — Word Count: -l=lines, -w=words, -c=bytes" \
        'chk "^wc .+"' 15

    run_challenge "Sort a File" \
        "Sort ${YELLOW}home/scores.txt${NC} alphabetically and print to screen." \
        "sort home/scores.txt  — sorts alphabetically by default. -n for numeric, -r reverse" \
        'chk "^sort .+"' 15

    run_challenge "Your First Pipe" \
        "PIPES connect commands! Count only the ERROR lines in ${YELLOW}var/log/error.log${NC}.\n\n  Combine grep and wc using the pipe symbol ${YELLOW}|${NC}" \
        "grep ERROR var/log/error.log | wc -l  — pipe sends grep's output INTO wc" \
        'chk ".*\|.*"' 25

    run_challenge "Search Recursively" \
        "Search for the word ${YELLOW}bash${NC} in ALL files under the current directory." \
        "grep -r bash .  — -r = recursive search through all files" \
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
        "whoami  — prints current username" \
        'exact "whoami"' 10

    run_challenge "Your Identity" \
        "Show your full user and group identity information." \
        "id  — shows uid, gid, and all group memberships" \
        'exact "id"' 10

    run_challenge "Read Permissions" \
        "List the ${YELLOW}home${NC} directory with full permission details.\n\n  You need the long format flag." \
        "ls -l home/  — shows permissions like: -rwxr-xr-x  owner group size date name" \
        'chk "^ls -[a-zA-Z]*l[a-zA-Z]* .+|^ls -l .+"' 15

    run_challenge "Make a Script Executable" \
        "You have ${YELLOW}deploy.sh${NC} that needs execute permission for everyone.\n\n  Permissions: owner=rwx(7), group=rx(5), others=rx(5)" \
        "chmod 755 deploy.sh  OR  chmod +x deploy.sh  — CHange MODe" \
        'chk "^chmod .+ .+"' 25

    run_challenge "Owner-Only Read" \
        "Lock down ${YELLOW}home/secret.txt${NC} so ONLY the owner can read it — no group, no others.\n\n  Owner=read(4), Group=none(0), Others=none(0)" \
        "chmod 400 home/secret.txt  — OR chmod 600 for read+write owner only" \
        'chk "^chmod [0-7]{3,4} .+|^chmod [ugoa][+-=].+ .+"' 25

    run_challenge "Understanding Permissions" \
        "What does the permission string ${YELLOW}-rwxr-xr--${NC} mean?\nType the numeric (octal) equivalent.\n\n  r=4, w=2, x=1. Add them for each group: owner|group|others" \
        "754  — owner: rwx=7, group: r-x=5, others: r--=4" \
        'exact "754"' 20

    cleanup_game_env
    level_complete 4
}

# ---- LEVEL 5: PROCESSES ----

run_level_5() {
    level_intro 5 "Process Management" \
        "Linux runs hundreds of processes simultaneously. As a sysadmin, you MUST be able to view, control, and manage them. A runaway process can bring down a server — knowing how to kill it fast is essential." \
        "⚙    Commands: ps  |  kill  |  top  |  jobs  |  bg  |  fg"
    setup_game_env

    run_challenge "List All Processes" \
        "Show ALL running processes from ALL users on the system." \
        "ps aux  — a=all users, u=user-friendly format, x=include background processes" \
        'chk "^ps( [auxef]+| -[ef]+)?$"' 20

    run_challenge "Find a Process" \
        "Check if a process named ${YELLOW}nginx${NC} is running.\n\n  Use ps combined with a pipe." \
        "ps aux | grep nginx  — pipe ps output into grep to filter by name" \
        'chk ".*ps.*\|.*grep.*|.*grep.*\|.*ps.*"' 20

    run_challenge "Kill a Process" \
        "A process with PID ${YELLOW}1337${NC} is hanging. Send the default termination signal." \
        "kill 1337  — sends SIGTERM (15). Politely asks the process to terminate" \
        'chk "^kill( -15)? [0-9]+"' 25

    run_challenge "Force Kill" \
        "PID ${YELLOW}9999${NC} ignored the kill signal. Force-terminate it immediately.\n\n  Use a signal that CANNOT be caught or ignored." \
        "kill -9 9999  — SIGKILL: instant termination, no cleanup. Nuclear option." \
        'chk "^kill -9 [0-9]+"' 25

    run_challenge "Background a Job" \
        "You're running a long process. Send it to the background so you can keep using the terminal.\n\n  Type the command that moves the current foreground job to background." \
        "bg  — sends current (stopped) job to background. Start with cmd & for direct background" \
        'chk "^bg|^.+ &$"' 20

    run_challenge "List Background Jobs" \
        "Show all jobs running in the background in this shell session." \
        "jobs  — lists background jobs with their job numbers" \
        'exact "jobs"' 15

    cleanup_game_env
    level_complete 5
}

# ---- LEVEL 6: TEXT PROCESSING ----

run_level_6() {
    level_intro 6 "Text Processing Power" \
        "The real superpower of Linux is transforming text. awk, sed, cut — these tools process data that would take hours in a GUI in milliseconds on the command line. Every senior engineer uses these daily." \
        "✂    Commands: awk  |  sed  |  cut  |  tr  |  head  |  tail"
    setup_game_env

    run_challenge "Cut a Field" \
        "Extract ONLY the usernames (field 1) from ${YELLOW}etc/passwd${NC}.\n\n  The file uses ${YELLOW}:${NC} as the field separator." \
        "cut -d: -f1 etc/passwd  — -d sets delimiter, -f selects field number" \
        'chk "^cut .+"' 25

    run_challenge "awk Column Extraction" \
        "Print only the first word (score name) from each line of ${YELLOW}home/scores.txt${NC} using awk." \
        'awk '"'"'{print $1}'"'"' home/scores.txt  — $1=first field, $2=second, $NF=last' \
        'chk "^awk .+"' 30

    run_challenge "awk with Condition" \
        "Use awk to print lines from ${YELLOW}home/scores.txt${NC} where the score (field 2) is greater than 50." \
        'awk -F: '"'"'$2 > 50'"'"' home/scores.txt  OR  awk '"'"'$2 > 50'"'"' home/scores.txt' \
        'chk "^awk .+"' 30

    run_challenge "sed Substitution" \
        "Replace every occurrence of ${YELLOW}ERROR${NC} with ${YELLOW}RESOLVED${NC} in ${YELLOW}var/log/error.log${NC} output." \
        "sed 's/ERROR/RESOLVED/g' var/log/error.log  — s/find/replace/g (g=global, all occurrences)" \
        'chk "^sed .+"' 30

    run_challenge "sed Delete Lines" \
        "Print ${YELLOW}var/log/error.log${NC} with the lines containing ${YELLOW}INFO${NC} removed." \
        "sed '/INFO/d' var/log/error.log  — /pattern/d deletes matching lines" \
        'chk "^sed .+"' 25

    run_challenge "tr - Translate Characters" \
        "Convert all lowercase letters in ${YELLOW}home/welcome.txt${NC} to uppercase.\n\n  Pipe cat into tr." \
        "cat home/welcome.txt | tr 'a-z' 'A-Z'  — tr translates character sets" \
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
        "ping -c 4 google.com  — -c COUNT limits packets. Without it, ping runs forever." \
        'chk "^ping .+"' 20

    run_challenge "Fetch a URL" \
        "Make an HTTP GET request to ${YELLOW}https://example.com${NC} and print the response." \
        "curl https://example.com  — Client URL. Default: GET request, print to stdout" \
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
        "ss -tlnp  — t=TCP, l=listening, n=numeric ports, p=process info" \
        'chk "^(ss|netstat) .+"' 25

    run_challenge "SSH Into a Server" \
        "Connect via SSH to the server ${YELLOW}webserver.example.com${NC} as user ${YELLOW}admin${NC}.\n\n  Standard SSH syntax." \
        "ssh admin@webserver.example.com  — Secure SHell: user@host" \
        'chk "^ssh .+"' 20

    run_challenge "Copy File Over SSH" \
        "Copy ${YELLOW}home/scores.txt${NC} to the remote server ${YELLOW}192.168.1.10${NC} at path ${YELLOW}/tmp/${NC} as user ${YELLOW}admin${NC}." \
        "scp home/scores.txt admin@192.168.1.10:/tmp/  — Secure CoPy: like cp but over SSH" \
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
        "#!/bin/bash  — #! is the shebang, /bin/bash is the interpreter path" \
        'chk "^#!/(bin/bash|usr/bin/env bash)"' 15

    run_challenge "Set a Variable" \
        "Declare a variable called ${YELLOW}HOSTNAME${NC} with value ${YELLOW}webserver01${NC}.\n\n  No spaces around the = sign!" \
        "HOSTNAME=webserver01  — variable assignment. NO spaces around =" \
        'chk "^[A-Z_][A-Z0-9_]*=[a-zA-Z0-9_.-]+"' 20

    run_challenge "Use a Variable" \
        "Print the value of the ${YELLOW}HOSTNAME${NC} variable.\n\n  Variables are accessed with \$ prefix." \
        "echo \$HOSTNAME  — use \$ to expand/dereference a variable" \
        'chk "^echo \\\$[A-Z_][A-Z0-9_]*$"' 20

    run_challenge "Command Substitution" \
        "Store the output of ${YELLOW}date${NC} into a variable called ${YELLOW}NOW${NC}.\n\n  Capture command output with \$() syntax." \
        'NOW=$(date)  — $() captures command output. Old style: `date` (backticks)' \
        'chk "^[A-Z_]+=\\\$\(.+\)"' 25

    run_challenge "For Loop" \
        "Write a for loop that iterates over the values ${YELLOW}1 2 3${NC} and echoes each.\n\n  All on one line using semicolons." \
        "for i in 1 2 3; do echo \$i; done  — basic for..in loop syntax" \
        'chk "^for .+do .+done$"' 25

    run_challenge "While Loop" \
        "Write a while loop that runs while a condition is true.\n\n  Use while true to make an infinite loop (common in servers)." \
        "while true; do echo running; sleep 1; done  — while condition; do ... done" \
        'chk "^while .+do .+done$"' 25

    run_challenge "If Statement" \
        "Write an if statement that checks if ${YELLOW}home/welcome.txt${NC} exists and echoes 'found'." \
        "if [ -f home/welcome.txt ]; then echo found; fi  — -f=file exists, -d=dir, -z=string empty" \
        'chk "^if \[.+\]; then .+fi$"' 30

    run_challenge "Function" \
        "Define a bash function called ${YELLOW}greet${NC} that echoes 'Hello World'." \
        "greet() { echo 'Hello World'; }  — function syntax: name() { commands; }" \
        'chk "^[a-z_]+\(\) \{.+\}$"' 30

    cleanup_game_env

    # GAME COMPLETE
    clear_screen
    echo -e "${YELLOW}"
    echo ' ██████╗ ██████╗ ███╗   ██╗ ██████╗ ██████╗  █████╗ ████████╗███████╗██╗'
    echo '██╔════╝██╔═══██╗████╗  ██║██╔════╝ ██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██║'
    echo '██║     ██║   ██║██╔██╗ ██║██║  ███╗██████╔╝███████║   ██║   ███████╗██║'
    echo '██║     ██║   ██║██║╚██╗██║██║   ██║██╔══██╗██╔══██║   ██║   ╚════██║╚═╝'
    echo '╚██████╗╚██████╔╝██║ ╚████║╚██████╔╝██║  ██║██║  ██║   ██║   ███████║██╗'
    echo ' ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝'
    echo -e "${NC}"
    echo -e "  ${LCYAN}You have mastered BashQuest, ${BOLD}${PLAYER_NAME}${NC}${LCYAN}! You are a true Linux warrior! 🐧⚔️${NC}"
    echo -e "  ${WHITE}Final XP: ${YELLOW}${PLAYER_XP}${NC}   ${WHITE}All 8 Levels Complete!${NC}"
    PLAYER_LEVEL=9; save_progress
    press_enter; main_menu
}

# ============================================================
# LEVEL 9: ADVANCED PIPING
# ============================================================

run_level_9() {
    level_intro 9 "Advanced Piping" \
        "The pipe | is the beating heart of Unix philosophy: each small tool does ONE thing well, and you chain them together. Data flows left to right — the STDOUT of each command becomes the STDIN of the next. Mastering pipes lets you build powerful one-liners that would take dozens of lines in any other language." \
        "🔗   |  tee  chaining  multi-pipe  sort|uniq  grep|wc"
    setup_game_env

    run_challenge "Your First Chain" \
        "Count how many UNIQUE users are defined in ${YELLOW}etc/passwd${NC}.\n\n  Chain four commands:\n  ${CYAN}cut${NC} → extract field 1 (username)\n  ${CYAN}sort${NC} → put them in order (uniq needs sorted input!)\n  ${CYAN}uniq${NC} → remove duplicates\n  ${CYAN}wc -l${NC} → count the lines" \
        "cut -d: -f1 etc/passwd | sort | uniq | wc -l  — four pipes, four tools, one answer" \
        'chk ".*\|.*\|.*\|.*"' 30

    run_challenge "tee — Branch the Stream" \
        "Search ${YELLOW}var/log/error.log${NC} for ${YELLOW}ERROR${NC} lines, display them on screen AND save them to ${YELLOW}errors.txt${NC} simultaneously.\n\n  ${CYAN}tee${NC} is named after a plumbing T-junction: it splits the stream in two directions at once. Perfect for logging pipeline output while still watching it." \
        "grep ERROR var/log/error.log | tee errors.txt  — tee writes to the file AND passes the data downstream unchanged" \
        'chk ".*\| *tee .+"' 25

    run_challenge "Count Non-matching Lines" \
        "Count how many lines in ${YELLOW}var/log/error.log${NC} do NOT contain ${YELLOW}INFO${NC}.\n\n  ${CYAN}grep -v${NC} inverts the match (shows lines that do NOT match). Pipe that into ${CYAN}wc -l${NC} to count." \
        "grep -v INFO var/log/error.log | wc -l  — -v inverts grep: shows every line that does NOT match the pattern" \
        'chk "grep -[a-zA-Z]*v[a-zA-Z]* .+ .+\| *wc|grep -v .+\| *wc"' 25

    run_challenge "Sort + Deduplicate" \
        "From ${YELLOW}home/scores.txt${NC}, extract the names (first word on each line), sort them, and remove duplicates.\n\n  ${CYAN}Key insight${NC}: uniq only removes ADJACENT duplicates — so you must sort first, then uniq." \
        "cut -d' ' -f1 home/scores.txt | sort | uniq  — always sort before uniq, otherwise non-adjacent duplicates survive" \
        'chk ".*cut .+\| *sort.*\| *uniq|.*sort .+\| *uniq"' 25

    run_challenge "Pipe to a Pager" \
        "The output of ${YELLOW}cat etc/passwd${NC} is long. Pipe it through a pager so you can scroll it.\n\n  ${CYAN}less${NC} lets you scroll up/down (j/k or arrow keys), search with /, quit with q. On servers with huge outputs, always use a pager." \
        "cat etc/passwd | less  — less is a pager. Also: q=quit, G=end, g=start, /pattern=search" \
        'chk ".*\| *(less|more)$"' 15

    run_challenge "Extract, Sort, Count" \
        "From ${YELLOW}var/log/error.log${NC}, find the most common log level (ERROR/INFO/WARNING).\n\n  Pipeline: ${CYAN}grep -oE${NC} (extract the word) → ${CYAN}sort${NC} → ${CYAN}uniq -c${NC} (count each) → ${CYAN}sort -rn${NC} (highest count first)" \
        "grep -oE 'ERROR|INFO|WARNING' var/log/error.log | sort | uniq -c | sort -rn  — uniq -c prepends count. sort -rn = reverse numeric sort" \
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
        "ls -l home/ > listing.txt  — > redirects stdout. WARNING: overwrites existing file without warning. Use >> to append." \
        'chk ".+ > [a-zA-Z0-9_./-]+"' 20

    run_challenge "Append to a File" \
        "Append the current date and time to ${YELLOW}listing.txt${NC} without erasing what's already there.\n\n  ${CYAN}>>${NC} vs ${CYAN}>${NC}: one appends, one overwrites. Getting this wrong in a cron script can silently destroy log history." \
        "date >> listing.txt  — >> appends without overwriting. Cron jobs and log scripts always use >> for safety." \
        'chk ".+ >> [a-zA-Z0-9_./-]+"' 20

    run_challenge "Redirect stderr" \
        "Run ${YELLOW}ls /doesnotexist${NC} but send the error message to ${YELLOW}err.log${NC} instead of the screen.\n\n  ${CYAN}2>${NC} redirects file descriptor 2 (stderr). Normal output (stdout) still goes to the screen. Separating error streams is essential in production scripts." \
        "ls /doesnotexist 2> err.log  — 2> redirects stderr only. stdout remains on screen (or wherever it was going)." \
        'chk ".+ 2> [a-zA-Z0-9_./-]+"' 25

    run_challenge "Merge stdout and stderr" \
        "Run ${YELLOW}ls -l home/ /doesnotexist${NC} and send BOTH normal output AND errors to ${YELLOW}all.log${NC}.\n\n  ${CYAN}2>&1${NC} means 'send file descriptor 2 to wherever fd 1 is currently pointing'. Order matters: redirect stdout first, then merge stderr into it." \
        "ls -l home/ /doesnotexist > all.log 2>&1  — OR: ls ... &> all.log  (&> is bash shorthand for both streams)" \
        'chk ".+ > .+ 2>&1|.+ &> .+"' 25

    run_challenge "Discard All Output" \
        "Run ${YELLOW}ls home/${NC} and throw away ALL output — stdout and stderr — completely silently.\n\n  ${CYAN}/dev/null${NC} is the 'black hole' device: anything written there disappears. In scripts you often only care if a command SUCCEEDS, not what it prints." \
        "ls home/ > /dev/null 2>&1  OR  ls home/ &> /dev/null  — /dev/null discards everything written to it" \
        'chk ".+ > /dev/null 2>&1|.+ &> /dev/null"' 20

    run_challenge "Feed a File as Input" \
        "Use ${YELLOW}sort${NC} to sort ${YELLOW}home/scores.txt${NC} by redirecting the file as stdin rather than passing it as an argument.\n\n  ${CYAN}<${NC} redirects a file to a command's stdin. Both forms work for sort, but < is essential for commands that only read stdin." \
        "sort < home/scores.txt  — < redirects file content to stdin. Equivalent here, but some commands ONLY read stdin." \
        'chk "sort < .+"' 20

    run_challenge "Here Document" \
        "Write two lines to ${YELLOW}note.txt${NC} using a here-document — inline multi-line input.\n\n  ${CYAN}<<EOF${NC} starts a heredoc: the shell reads lines until it sees EOF on its own line. Heredocs are used everywhere: Dockerfiles, Ansible, scripts, SSH remote commands." \
        "cat > note.txt <<EOF  (type your lines, then EOF alone on a line)  — heredoc syntax. The delimiter can be any word, not just EOF." \
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
        "Show lines from ${YELLOW}var/log/error.log${NC} that START with the word ${YELLOW}ERROR${NC}.\n\n  ${CYAN}^${NC} anchors the match to the very start of a line. Without it, 'ERROR' would match anywhere in the line — even inside a URL or filename." \
        "grep '^ERROR' var/log/error.log  — ^ means 'must match here at the start'. Essential for structured log parsing." \
        'chk "grep.*\^[A-Za-z].+ .+"' 25

    run_challenge "Anchor: End of Line" \
        "Find lines in ${YELLOW}etc/passwd${NC} that END with ${YELLOW}/bash${NC}.\n\n  ${CYAN}\$${NC} anchors the match to the end of a line. This ensures '/bash' is the final thing on the line, not just somewhere in the middle." \
        "grep '/bash\$' etc/passwd  — \$ means 'end of line'. Combine with ^ for exact full-line matches: grep '^root:' " \
        'chk "grep.*\\\$.+ .+|grep.*/bash\\\$.+"' 25

    run_challenge "Character Class" \
        "Find lines in ${YELLOW}home/scores.txt${NC} that contain at least one digit.\n\n  ${CYAN}[0-9]${NC} matches any single character in that range. ${CYAN}[a-zA-Z]${NC} matches any letter. ${CYAN}[^0-9]${NC} (with ^) matches anything EXCEPT a digit." \
        "grep '[0-9]' home/scores.txt  — [chars] is a character class. [0-9]=digit, [a-z]=lowercase, [^x]=not x" \
        'chk "grep.*\[.+\]"' 20

    run_challenge "Extended Regex: one or more (+)" \
        "Use ${YELLOW}grep -E${NC} to find lines in ${YELLOW}var/log/error.log${NC} containing one or more consecutive digits.\n\n  ${CYAN}+${NC} means 'one or more of the preceding'. It requires ${CYAN}-E${NC} (extended regex) — in basic regex you need \\+ which is ugly. ${CYAN}*${NC} means zero or more. ${CYAN}?${NC} means zero or one." \
        "grep -E '[0-9]+' var/log/error.log  — -E enables ERE (Extended Regular Expressions). Always prefer -E over escaping." \
        'chk "grep -[a-zA-Z]*E[a-zA-Z]* .+ .+"' 25

    run_challenge "Alternation — OR" \
        "Show lines from ${YELLOW}var/log/error.log${NC} that contain either ${YELLOW}ERROR${NC} or ${YELLOW}WARNING${NC} (one grep command).\n\n  ${CYAN}|${NC} inside a regex means OR. With ${CYAN}-E${NC}: pattern1|pattern2. Without -E you need \\| which is messier." \
        "grep -E 'ERROR|WARNING' var/log/error.log  — alternation: matches if EITHER pattern is found on the line" \
        'chk "grep -[a-zA-Z]*E[a-zA-Z]*.+\|.+ .+"' 25

    run_challenge "Wildcard: any character (.)" \
        "Find lines in ${YELLOW}var/log/error.log${NC} that contain any 3-letter word starting with ${YELLOW}E${NC} and ending with ${YELLOW}R${NC}.\n\n  ${CYAN}.${NC} matches ANY single character (except newline). ${CYAN}E.R${NC} would match 'EAR', 'EOR', 'E R', etc." \
        "grep -E 'E.R' var/log/error.log  — . is the wildcard: matches any single character. .* matches any sequence." \
        'chk "grep -[a-zA-Z]*E[a-zA-Z]* .E.R. .+|grep .E.R. .+"' 20

    run_challenge "Match Whole Word" \
        "Find lines in ${YELLOW}var/log/error.log${NC} containing the whole word ${YELLOW}disk${NC} but NOT ${YELLOW}diskspace${NC} or ${YELLOW}disks${NC}.\n\n  ${CYAN}-w${NC} matches whole words only — it won't match if the pattern is part of a longer word. Equivalent to surrounding with word boundaries \\b in -E mode." \
        "grep -w 'disk' var/log/error.log  OR  grep -E '\\bdisk\\b' var/log/error.log  — -w is the clean approach" \
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
        "Search for ${YELLOW}ERROR${NC} in ${YELLOW}var/log/error.log${NC} and show the line number of each match.\n\n  ${CYAN}-n${NC} is invaluable in scripts — you can jump directly to the problem line in vim with :123 or sed -n '123p'." \
        "grep -n 'ERROR' var/log/error.log  — -n prints: linenum:matchedline. Combine with -r for cross-file line numbers." \
        'chk "grep -[a-zA-Z]*n[a-zA-Z]* .+ .+"' 20

    run_challenge "Show Context Around a Match" \
        "Find ${YELLOW}WARNING${NC} in ${YELLOW}var/log/error.log${NC} and show 2 lines of context BEFORE and AFTER each match.\n\n  Errors rarely happen in isolation. The lines around a match often reveal the root cause — a failed connection, a timeout, a missing file." \
        "grep -C 2 'WARNING' var/log/error.log  — -C N = N lines of Context (both sides). -A N = After. -B N = Before." \
        'chk "grep -[ABC] [0-9] .+ .+"' 25

    run_challenge "Count Matching Lines" \
        "Count how many lines in ${YELLOW}var/log/error.log${NC} contain ${YELLOW}ERROR${NC}.\n\n  ${CYAN}-c${NC} is faster than piping to wc -l because grep itself does the counting — one less process spawned." \
        "grep -c 'ERROR' var/log/error.log  — -c prints the count of matching lines only, not the lines themselves" \
        'chk "grep -[a-zA-Z]*c[a-zA-Z]* .+ .+"' 20

    run_challenge "List Files with Matches" \
        "Recursively search ${YELLOW}.${NC} for the word ${YELLOW}bash${NC} and list only the FILENAMES that contain it.\n\n  ${CYAN}-l${NC} (list files) is the right tool when you have hundreds of files and just need to know WHICH ones to look at — not see every individual match." \
        "grep -rl 'bash' .  — -r=recursive, -l=list filenames only (not the matching lines)" \
        'chk "grep -[a-zA-Z]*r[a-zA-Z]*l[a-zA-Z]* .+ .+|grep -[a-zA-Z]*l[a-zA-Z]*r[a-zA-Z]* .+ .+"' 25

    run_challenge "Limit to File Types" \
        "Recursively search ${YELLOW}.${NC} for ${YELLOW}root${NC} but only look inside ${YELLOW}.txt${NC} files.\n\n  ${CYAN}--include${NC} drastically speeds up large directory searches by skipping irrelevant files. Always use it when you know the file extension." \
        "grep -r --include='*.txt' 'root' .  — --include='*.txt' filters which files grep opens. --exclude skips files." \
        'chk "grep -r.*--include.* .+ .+|grep.*--include.* -r .+ .+"' 25

    run_challenge "Extract Only the Match" \
        "From ${YELLOW}var/log/error.log${NC}, extract ONLY the words in ALL CAPS (not the whole line, just the matching text).\n\n  ${CYAN}-o${NC} prints only the matched portion of each line — one match per line. Extremely useful for extracting IP addresses, emails, version numbers, etc." \
        "grep -oE '[A-Z]{2,}' var/log/error.log  — -o=only matching text. Each match on its own line. Great for feeding into sort|uniq|wc." \
        'chk "grep -[a-zA-Z]*o[a-zA-Z]* .+ .+"' 25

    cleanup_game_env
    level_complete 12
}

# ============================================================
# LEVEL 13: ADVANCED SED
# ============================================================

run_level_13() {
    level_intro 13 "Advanced sed — Stream Editor" \
        "sed reads input line by line and applies editing commands. Think of it as find-and-replace on steroids: it handles ranges, patterns, in-place file editing, line deletion, and extraction. sed is in every sysadmin's deployment script, every CI/CD pipeline, and every config management tool." \
        "📝   s/find/replace/flags  -i  /pattern/d  -n 'Np'  addr1,addr2  y///"
    setup_game_env

    run_challenge "Replace First Match per Line" \
        "Replace only the FIRST occurrence of ${YELLOW}ERROR${NC} per line with ${YELLOW}FIXED${NC} in ${YELLOW}var/log/error.log${NC}.\n\n  Without the ${CYAN}/g${NC} flag, sed's substitution stops after the first match on each line. Use this when later occurrences are intentional." \
        "sed 's/ERROR/FIXED/' var/log/error.log  — no /g = first match per line only. The /g flag makes it global." \
        'chk "^sed .*s/.+/.+/"' 20

    run_challenge "Global Replace" \
        "Replace ALL occurrences of ${YELLOW}ERROR${NC} with ${YELLOW}FIXED${NC} on every line.\n\n  ${CYAN}/g${NC} (global flag) replaces every occurrence on each line, not just the first. This is what most people mean when they say 'find and replace'." \
        "sed 's/ERROR/FIXED/g' var/log/error.log  — /g = global: all occurrences on every line" \
        'chk "^sed .*s/.+/.+/g"' 20

    run_challenge "Delete Lines by Pattern" \
        "Print ${YELLOW}var/log/error.log${NC} with all ${YELLOW}INFO${NC} lines removed entirely.\n\n  ${CYAN}/pattern/d${NC} — the d command deletes lines matching the address. Lines not matching pass through unchanged. Use this to strip noise from logs." \
        "sed '/INFO/d' var/log/error.log  — /pattern/ is the address (which lines to act on). d = delete those lines." \
        'chk "^sed .*/.+/d"' 25

    run_challenge "Print a Specific Line" \
        "Print only line 2 of ${YELLOW}var/log/error.log${NC} using sed.\n\n  ${CYAN}sed -n '2p'${NC}: -n suppresses default output (sed normally prints every line), then p explicitly prints the addressed line. Together they print only what you select." \
        "sed -n '2p' var/log/error.log  — -n suppresses auto-print. p = print this line. Alternative: awk 'NR==2'" \
        'chk "^sed -n .+[0-9]+p.+ .+"' 25

    run_challenge "Print a Line Range" \
        "Print lines 2 through 4 of ${YELLOW}var/log/error.log${NC}.\n\n  ${CYAN}addr1,addr2${NC} defines a range — from the first address to the second. Addresses can be line numbers, patterns, or a mix: '/START/,/END/'." \
        "sed -n '2,4p' var/log/error.log  — 2,4 = from line 2 to line 4 inclusive. Try: sed -n '/ERROR/,/WARNING/p'" \
        'chk "^sed -n .+[0-9]+,[0-9]+p.+ .+"' 25

    run_challenge "In-place Edit" \
        "Edit ${YELLOW}var/log/error.log${NC} directly — replace ${YELLOW}ERROR${NC} with ${YELLOW}RESOLVED${NC} inside the file itself.\n\n  ${CYAN}-i.bak${NC} edits in-place and creates a backup (.bak suffix). On macOS, ${CYAN}-i.bak${NC} (no space) works on both BSD and GNU sed. ${CYAN}-i ''${NC} on macOS or ${CYAN}-i${NC} on Linux for no backup." \
        "sed -i.bak 's/ERROR/RESOLVED/g' var/log/error.log  — -i.bak works on macOS AND Linux. For no backup: -i '' (macOS) or -i (Linux)" \
        'chk "^sed -i.* .+s/.+/.+/.* .+"' 30

    run_challenge "Target Specific Line" \
        "Replace ${YELLOW}INFO${NC} with ${YELLOW}DEBUG${NC} ONLY on line 2 of ${YELLOW}var/log/error.log${NC} — leave all other lines alone.\n\n  Prefix the s command with a line-number address to scope it. This is how sed replaces things surgically in config files." \
        "sed '2s/INFO/DEBUG/' var/log/error.log  — 2s/find/replace/ = apply substitution only on line 2" \
        'chk "^sed .*[0-9]+s/.+/.+/"' 25

    cleanup_game_env
    level_complete 13
}

# ============================================================
# LEVEL 14: ADVANCED AWK
# ============================================================

run_level_14() {
    level_intro 14 "Advanced awk" \
        "awk is a complete text-processing language. It splits each line into numbered fields, runs your program on every line, and has built-in variables, math, string functions, and printf. awk is what you reach for when a shell pipeline gets complicated — it handles things cleanly that would take multiple sed and cut commands." \
        "⚡   NR  NF  \$0  \$1  FS  BEGIN{}  END{}  printf  conditions  math"
    setup_game_env

    run_challenge "NR and \$0 — Line Number + Full Line" \
        "Print the line number and full content of every line in ${YELLOW}etc/passwd${NC}.\n\n  ${CYAN}NR${NC} = Number of Records (current line number). ${CYAN}\$0${NC} = the entire current line. ${CYAN}\$1, \$2...${NC} = individual fields split by the separator." \
        "awk '{print NR, \$0}' etc/passwd  — NR auto-increments. \$0 is the whole line before field splitting." \
        'chk "^awk .+NR.+ .+"' 25

    run_challenge "NF — Number of Fields" \
        "For each line of ${YELLOW}etc/passwd${NC} (colon-separated), print how many fields it contains.\n\n  ${CYAN}NF${NC} = Number of Fields on the current line. ${CYAN}\$NF${NC} = the LAST field (handy for getting filenames from paths)." \
        "awk -F: '{print NF}' etc/passwd  — -F: sets field separator to colon. NF tells you the count of fields." \
        'chk "^awk -F.* .+NF.+ .+"' 25

    run_challenge "Conditional Filter" \
        "Print only lines from ${YELLOW}home/scores.txt${NC} where the score (2nd field) is above 50.\n\n  ${CYAN}awk 'condition { action }'${NC} — if no action, the default is {print \$0}. Conditions can use ==, !=, >, <, >=, <=, && and ||." \
        "awk '\$2 > 50' home/scores.txt  — condition without {action} defaults to printing the whole line. Clean and readable." \
        'chk "^awk .\\\$[0-9]+ *[><=!]+ *[0-9]+. .+"' 25

    run_challenge "Sum a Column" \
        "Calculate the total of all scores in ${YELLOW}home/scores.txt${NC} (2nd field).\n\n  ${CYAN}END{}${NC} runs once after ALL lines have been processed — perfect for totals, averages, and summaries. Variables in awk start at 0 automatically." \
        "awk '{sum += \$2} END {print \"Total:\", sum}' home/scores.txt  — accumulate in sum each line, print once at END" \
        'chk "^awk .+END.+print.+ .+"' 30

    run_challenge "BEGIN Header" \
        "Print a header line ${YELLOW}NAME  SCORE${NC} before listing all lines of ${YELLOW}home/scores.txt${NC}.\n\n  ${CYAN}BEGIN{}${NC} runs once BEFORE any input is read. Use it for: printing headers, initialising variables, setting the field separator (FS=\":\")." \
        "awk 'BEGIN{print \"NAME  SCORE\"} {print}' home/scores.txt  — BEGIN runs before line 1. END runs after the last line." \
        'chk "^awk .+BEGIN.+print.+ .+"' 25

    run_challenge "printf — Formatted Output" \
        "Print name and score from ${YELLOW}home/scores.txt${NC} in a neat fixed-width table using awk's printf.\n\n  ${CYAN}printf \"%-10s %4d\\n\", \$1, \$2${NC} — %-10s = left-aligned 10-char string, %4d = right-aligned 4-digit integer. Identical syntax to C's printf." \
        "awk '{printf \"%-10s %4d\\n\", \$1, \$2}' home/scores.txt  — printf controls exact column widths. Essential for readable reports." \
        'chk "^awk .+printf.+ .+"' 30

    run_challenge "Field Separator — Parsing CSV/config" \
        "Extract just the usernames (field 1) and shells (last field) from ${YELLOW}etc/passwd${NC} in a clean two-column format.\n\n  Set ${CYAN}-F:${NC} for the colon separator, use ${CYAN}\$NF${NC} for the last field regardless of how many fields there are." \
        "awk -F: '{print \$1, \$NF}' etc/passwd  — \$NF = last field. Works for any number of fields. Combine with printf for alignment." \
        'chk "^awk -F.+ .+\\\$NF.+ .+"' 25

    cleanup_game_env
    level_complete 14
}

# ============================================================
# LEVEL 15: XARGS & FIND -EXEC
# ============================================================

run_level_15() {
    level_intro 15 "xargs & find -exec" \
        "find locates files. But what do you DO with them once found? Two patterns: find -exec runs a command on each file one at a time. xargs batches them and passes them as arguments — far more efficient for large sets. xargs -I{} lets you place the filename anywhere in the command." \
        "🔧   find -exec {} \\;  find -exec {} +  xargs  xargs -I{}  -print0 | xargs -0"
    setup_game_env

    run_challenge "find -exec Basic" \
        "Find all ${YELLOW}.txt${NC} files under ${YELLOW}.${NC} and print their contents using find's -exec flag.\n\n  ${CYAN}-exec cmd {} \\;${NC} — {} is replaced with the found filename. \\; ends the -exec (runs command once per file). Use + instead of \\; to batch files into one command call." \
        "find . -name '*.txt' -exec cat {} \\;  — {} = placeholder for found file. \\; = one call per file. Use + for efficiency with many files." \
        'chk "^find .+ -exec .+ \{\} [\\\\;+]"' 30

    run_challenge "xargs basics" \
        "Find all ${YELLOW}.txt${NC} files and count the lines in all of them at once using xargs.\n\n  ${CYAN}xargs${NC} reads lines from stdin and appends them as arguments to a command. More efficient than -exec \\; because it passes many files in one invocation." \
        "find . -name '*.txt' | xargs wc -l  — xargs bundles stdin items as arguments. Better than -exec \\; for large file counts." \
        'chk ".*find .+\| *xargs .+"' 25

    run_challenge "xargs with a Placeholder" \
        "Copy every ${YELLOW}.txt${NC} file found under ${YELLOW}.${NC} to ${YELLOW}tmp/${NC} with ${YELLOW}.bak${NC} appended to its name.\n\n  ${CYAN}xargs -I{}${NC} lets you use {} as a placeholder ANYWHERE in the command — not just at the end. Essential when you need the filename in the middle of the command." \
        "find . -name '*.txt' | xargs -I{} cp {} tmp/{}.bak  — -I{} replaces {} everywhere in the command line" \
        'chk ".*xargs -I.* .+"' 30

    run_challenge "Handle Filenames with Spaces" \
        "Safely find all ${YELLOW}.txt${NC} files and pass them to wc -l, even if filenames have spaces.\n\n  ${CYAN}-print0${NC} separates filenames with null bytes (not newlines). ${CYAN}xargs -0${NC} reads null-separated input. Together they're the safe way to handle any filename." \
        "find . -name '*.txt' -print0 | xargs -0 wc -l  — -print0 and -0 use null bytes instead of newlines. Safe for ALL filenames." \
        'chk ".*-print0.*\|.*xargs -0.*|.*find .+-print0.*\| *xargs -0"' 30

    run_challenge "find by Size" \
        "Find all files under ${YELLOW}.${NC} larger than 10 bytes.\n\n  ${CYAN}-size +10c${NC} — c=bytes, k=kilobytes, M=megabytes, G=gigabytes. + means 'greater than', - means 'less than', no prefix means 'exactly'." \
        "find . -size +10c  — +10c = larger than 10 bytes. -size +1M = larger than 1 MB. Combine with -exec to act on results." \
        'chk "^find .+ -size .+"' 20

    run_challenge "find by Modification Time" \
        "Find files modified in the last 2 days under ${YELLOW}.${NC}.\n\n  ${CYAN}-mtime -2${NC} = modified less than 2 days ago. ${CYAN}-mtime +7${NC} = older than 7 days. ${CYAN}-mmin -60${NC} = modified in the last 60 minutes. Great for finding recently changed config files." \
        "find . -mtime -2  — -mtime -N = less than N days old. Useful: find /etc -mtime -1 to see recent config changes." \
        'chk "^find .+ -m(time|min) .+"' 25

    cleanup_game_env
    level_complete 15
}

# ============================================================
# LEVEL 16: DISK & STORAGE
# ============================================================

run_level_16() {
    level_intro 16 "Disk & Storage" \
        "A full disk silently kills services. Logs stop writing, databases corrupt, applications crash. Knowing how to quickly diagnose disk usage — which filesystem is full, which directory is the culprit — is one of the most time-critical sysadmin skills. These are your emergency tools." \
        "💾   df -h  |  du -sh  |  du -sh * | sort  |  lsblk  |  findmnt"
    setup_game_env

    run_challenge "Check Filesystem Usage" \
        "Show how much free space is available on all mounted filesystems in human-readable form.\n\n  ${CYAN}df -h${NC} is the first command you run when a server is slow or a service is dying — it tells you instantly if disk space is the culprit." \
        "df -h  — Disk Free, -h = human-readable (GB/TB instead of 512-byte blocks). Look for 'Use%' near 100%." \
        'chk "^df( -[a-zA-Z]+)?$"' 15

    run_challenge "Directory Total Size" \
        "Show the total disk usage of the ${YELLOW}var${NC} directory in human-readable form.\n\n  ${CYAN}du${NC} (Disk Usage) measures actual file sizes, not filesystem-level allocation. -s gives a summary total, not a per-file breakdown." \
        "du -sh var/  — -s = summary (total only, don't recurse into subdirectories), -h = human readable" \
        'chk "^du .+ .+"' 20

    run_challenge "Find the Space Hogs" \
        "List the sizes of all items in the current directory, sorted largest first.\n\n  This is the go-to command when a disk is full and you need to find the culprit quickly. ${CYAN}sort -rh${NC} sorts human-readable sizes in reverse order (largest first)." \
        "du -sh * | sort -rh  — du * gets size of each item, sort -rh = reverse human-readable sort. macOS: add -k for stability." \
        'chk "^du .+\| *sort .+"' 25

    run_challenge "Find Large Files" \
        "Find all files under ${YELLOW}.${NC} larger than 50 bytes and list them with their size.\n\n  On a real server you'd search from / for files > 100MB. The -ls flag outputs like 'ls -l' so you see size, owner, and path." \
        "find . -size +50c -ls  OR  find . -size +50c -exec ls -lh {} \\;  — -ls in find prints detailed info for each found file" \
        'chk "^find .+ -size .+"' 20

    run_challenge "List Block Devices" \
        "List all block devices (disks and their partitions) on the system in a tree view.\n\n  ${CYAN}lsblk${NC} shows the block device tree: physical disks, their partitions, and where they're mounted. Always check this before partitioning or mounting." \
        "lsblk  — List BLocK devices. Shows: NAME, MAJ:MIN, SIZE, TYPE (disk/part/lvm), MOUNTPOINT" \
        'chk "^lsblk( -[a-zA-Z]+)?$"' 15

    run_challenge "Show Mount Points" \
        "Show all currently mounted filesystems in a human-readable tree.\n\n  ${CYAN}findmnt${NC} is the modern tool — cleaner than parsing /proc/mounts or running mount | column -t. Shows filesystem type, source, and mount options." \
        "findmnt  OR  mount | column -t  — findmnt shows mount tree. On macOS: mount (no findmnt)" \
        'chk "^(findmnt|mount)( -[a-zA-Z]+)?$"' 15

    cleanup_game_env
    level_complete 16
}

# ============================================================
# LEVEL 17: SYSTEM INFORMATION
# ============================================================

run_level_17() {
    level_intro 17 "System Information" \
        "When you SSH into an unfamiliar server — or one that's misbehaving — you need to quickly establish situational awareness: what OS, what kernel, how much RAM, how many CPUs, how long has it been running, what's consuming resources. These commands build that picture in seconds." \
        "🖥️   uname  |  lscpu / sysctl  |  free / vm_stat  |  uptime  |  lsof  |  who"
    setup_game_env

    run_challenge "Kernel and Architecture" \
        "Print kernel name, hostname, kernel version, and hardware architecture all at once.\n\n  ${CYAN}uname -a${NC} is the first thing to run on an unfamiliar box. It tells you the OS family, kernel version, and CPU architecture (x86_64, arm64, etc.)." \
        "uname -a  — All fields: kernel name, node name, release, version, machine, OS. On macOS too." \
        'chk "^uname( -[a-zA-Z]+)?$"' 15

    run_challenge "CPU Details" \
        "Show detailed CPU information — architecture, core count, speed.\n\n  ${CYAN}lscpu${NC} is Linux only. On macOS use ${CYAN}sysctl -n machdep.cpu.brand_string${NC}. The game validates either answer." \
        "lscpu  OR  sysctl -n machdep.cpu.brand_string  — lscpu = Linux, sysctl = macOS/BSD. Know both." \
        'chk "^(lscpu|sysctl .+cpu.+)$"' 15

    run_challenge "Memory Usage" \
        "Show RAM usage — total, used, and free — in human-readable form.\n\n  ${CYAN}free -h${NC} is Linux only. On macOS use ${CYAN}vm_stat${NC} (different format, pages-based). The 'available' column in free -h is what matters — not 'free', which excludes cache." \
        "free -h  OR  vm_stat  — free -h = Linux. vm_stat = macOS. Look at 'available', not just 'free'." \
        'chk "^(free( -[a-zA-Z]+)?|vm_stat)$"' 15

    run_challenge "System Uptime and Load" \
        "Show how long the system has been running and the current CPU load averages.\n\n  Load average: three numbers = 1 min, 5 min, 15 min average. Rule of thumb: load > number of CPU cores = system is under pressure." \
        "uptime  — shows: current time, uptime duration, logged-in users, load averages (1/5/15 min)" \
        'exact "uptime"' 10

    run_challenge "List Open Files" \
        "List all open file descriptors on the system (what files/sockets are currently in use).\n\n  ${CYAN}lsof${NC} = List Open Files. Everything in Linux is a file — network connections, pipes, devices. lsof answers: 'what process has this port open?' or 'what's holding this file open?'" \
        "lsof  OR  lsof -i  — lsof lists all. -i = network connections only. -p PID = files for one process. -u user = files for one user." \
        'chk "^lsof( -[a-zA-Z0-9:@]+)?$"' 20

    run_challenge "Current Users" \
        "Show who is currently logged into this system and what they are doing.\n\n  On shared servers, multi-tenant systems, or after a security incident, seeing who's logged in is essential. ${CYAN}w${NC} gives more detail than ${CYAN}who${NC}." \
        "w  OR  who  — w shows logged-in users + their process, idle time, and load. who shows just the login details." \
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
        "Create a new system user called ${YELLOW}deploy${NC} with a home directory.\n\n  ${CYAN}-m${NC} creates the home directory. Without it, no home dir is made — services that expect ${CYAN}~/config${NC} will break. On macOS use ${CYAN}sysadminctl -addUser${NC} or ${CYAN}dscl${NC} instead." \
        "useradd -m deploy  — -m creates /home/deploy. Always use -m for human users. For system accounts: useradd -r -s /sbin/nologin serviceuser" \
        'chk "^useradd .+ [a-zA-Z0-9_-]+"' 25

    run_challenge "Set a Password" \
        "Set the password for the ${YELLOW}deploy${NC} user.\n\n  ${CYAN}passwd username${NC} prompts interactively. In scripts use ${CYAN}chpasswd${NC} or ${CYAN}echo 'user:pass' | chpasswd${NC} to avoid interactive prompts." \
        "passwd deploy  — interactive password set. In scripts: echo 'deploy:secretpass' | chpasswd" \
        'chk "^passwd [a-zA-Z0-9_-]+"' 20

    run_challenge "Add User to Group" \
        "Add user ${YELLOW}deploy${NC} to the ${YELLOW}sudo${NC} group.\n\n  ${CYAN}CRITICAL: always use -aG, NEVER just -G alone${NC}. The -a means APPEND — without it, -G replaces ALL the user's groups, locking them out of everything else they had access to." \
        "usermod -aG sudo deploy  — -a = append, -G = supplementary group. Missing -a removes ALL other group memberships!" \
        'chk "^usermod -[a-zA-Z]*a[a-zA-Z]*G[a-zA-Z]* [a-zA-Z0-9_-]+ [a-zA-Z0-9_-]+|^usermod -aG [a-zA-Z0-9_-]+ [a-zA-Z0-9_-]+"' 25

    run_challenge "Check Group Memberships" \
        "Show all groups that user ${YELLOW}bashuser${NC} belongs to.\n\n  Group membership explains access. If a user can't read a file or run a command, check their groups first." \
        "groups bashuser  OR  id bashuser  — groups lists names, id lists both names and GIDs. Try: id -nG username for just group names." \
        'chk "^(groups|id) [a-zA-Z0-9_-]+"' 15

    run_challenge "Switch User (Full Login)" \
        "Switch to the ${YELLOW}deploy${NC} user with a full login shell that loads their complete environment.\n\n  ${CYAN}su - username${NC} (with the dash): runs a login shell that sources .bashrc and .profile. Without the dash you keep your current environment — a common source of 'it works as me but not as deploy' bugs." \
        "su - deploy  — the dash matters: it gives a full login shell. su deploy (no dash) = same shell env, just different user." \
        'chk "^su - [a-zA-Z0-9_-]+"' 20

    run_challenge "Sudo a Single Command" \
        "Run the command ${YELLOW}apt update${NC} as root using sudo.\n\n  ${CYAN}sudo${NC} runs ONE command as root (or another user). It logs every command to the auth log. Prefer sudo over su — it provides an audit trail of who ran what." \
        "sudo apt update  — logs to /var/log/auth.log. sudo -u username cmd = run as specific user, not just root." \
        'chk "^sudo .+"' 15

    run_challenge "Lock an Account" \
        "Lock the ${YELLOW}deploy${NC} user account to prevent login immediately.\n\n  When an employee leaves or an account is compromised, lock first — it takes effect instantly. Review and delete later after data handover." \
        "usermod -L deploy  OR  passwd -l deploy  — -L prefixes ! to the password hash. Check with: passwd -S deploy" \
        'chk "^(usermod -[a-zA-Z]*L[a-zA-Z]* [a-zA-Z0-9_-]+|passwd -l [a-zA-Z0-9_-]+)"' 20

    cleanup_game_env
    level_complete 18
}

# ============================================================
# LEVEL 19: SSH & KEYS
# ============================================================

run_level_19() {
    level_intro 19 "SSH & Key-Based Auth" \
        "SSH is how you control remote servers securely. Password auth is convenient but brute-forceable — key auth is the industry standard and is required by most cloud providers. Your private key is the equivalent of a physical key to your server: protect it with a passphrase, never share it, set strict permissions." \
        "🔑   ssh-keygen -t ed25519  |  chmod 600  |  ssh-copy-id  |  -i key  |  -L tunnel"
    setup_game_env

    run_challenge "Generate an ED25519 Key Pair" \
        "Generate a new SSH key pair using the ${YELLOW}ed25519${NC} algorithm with your email as the comment.\n\n  ${CYAN}ED25519${NC} is the modern standard — smaller keys, faster operations, and stronger security than RSA 2048. Always add a comment (-C) so you can identify which key is which across multiple servers." \
        "ssh-keygen -t ed25519 -C 'you@example.com'  — creates ~/.ssh/id_ed25519 (private) and id_ed25519.pub (public). Add -f to specify filename." \
        'chk "^ssh-keygen .+"' 25

    run_challenge "Fix Key Permissions" \
        "Your private key ${YELLOW}~/.ssh/id_ed25519${NC} has permissions 644. SSH will refuse to use it. Fix them.\n\n  ${CYAN}SSH enforces strict permissions${NC} on key files. If the private key is readable by others, SSH considers it compromised and refuses to load it — a deliberate security feature." \
        "chmod 600 ~/.ssh/id_ed25519  — private keys must be 600 (owner read/write only). ~/.ssh dir should be 700." \
        'chk "^chmod 600 .+|^chmod 700 .ssh"' 20

    run_challenge "Copy Public Key to Server" \
        "Enable password-less login to ${YELLOW}admin@192.168.1.50${NC} by copying your public key there.\n\n  ${CYAN}ssh-copy-id${NC} appends your public key to the server's ${CYAN}~/.ssh/authorized_keys${NC} file, creating it with correct permissions if needed. Doing this manually is error-prone." \
        "ssh-copy-id admin@192.168.1.50  — reads ~/.ssh/id_ed25519.pub and appends it to the server's authorized_keys" \
        'chk "^ssh-copy-id .+"' 25

    run_challenge "Connect with a Specific Key" \
        "SSH to ${YELLOW}admin@192.168.1.50${NC} using a specific key file ${YELLOW}~/.ssh/deploy_key${NC} instead of the default.\n\n  ${CYAN}-i${NC} specifies which identity (private key) file to use. When you manage many servers, each gets its own key — use -i to select the right one." \
        "ssh -i ~/.ssh/deploy_key admin@192.168.1.50  — -i = identity file. Pair with ~/.ssh/config Host entries to avoid typing -i every time." \
        'chk "^ssh -i .+ .+@.+"' 25

    run_challenge "SSH Config Shortcut" \
        "Create an SSH config entry so ${YELLOW}ssh webserver${NC} connects to ${YELLOW}admin@192.168.1.50${NC} automatically.\n\n  ${CYAN}~/.ssh/config${NC} stores named host profiles: alias, hostname, user, port, and which key to use. This file saves enormous amounts of typing on systems with many servers." \
        "cat >> ~/.ssh/config  then add: Host webserver / Hostname 192.168.1.50 / User admin  — one block per host. Then: ssh webserver just works." \
        'chk "^(cat|echo).+~/.ssh/config|^ssh webserver$|^nano ~/.ssh/config$"' 20

    run_challenge "Local Port Forwarding (Tunnel)" \
        "Forward your local port ${YELLOW}8080${NC} to port ${YELLOW}80${NC} on server ${YELLOW}192.168.1.50${NC} through SSH.\n\n  ${CYAN}SSH tunnelling${NC} lets you securely access services behind firewalls. After this, ${CYAN}localhost:8080${NC} in your browser reaches the server's web server — through the encrypted SSH connection." \
        "ssh -L 8080:localhost:80 admin@192.168.1.50  — -L localport:remotehost:remoteport. After connecting, browse to localhost:8080." \
        'chk "^ssh -L .+:.+:.+ .+"' 30

    cleanup_game_env
    level_complete 19
}

# ============================================================
# LEVEL 20: ENVIRONMENT & SHELL CONFIG
# ============================================================

run_level_20() {
    level_intro 20 "Environment & Shell Configuration" \
        "Your shell environment controls how the terminal works — where commands are found (PATH), what shortcuts exist (aliases), what your prompt looks like (PS1), and which variables child processes inherit (export). These settings live in ~/.bashrc or ~/.zshrc and are loaded every time you open a terminal." \
        "🌍   PATH  |  export  |  alias  |  source  |  .bashrc  |  .profile  |  PS1"
    setup_game_env

    run_challenge "View PATH" \
        "Print your current PATH — the colon-separated list of directories where the shell searches for commands.\n\n  ${CYAN}'command not found'${NC} almost always means the program exists but isn't in a PATH directory. Knowing your PATH lets you diagnose this in 5 seconds." \
        "echo \$PATH  — PATH is colon-separated: /usr/local/bin:/usr/bin:/bin. Commands are found by searching each in order." \
        'chk "^echo \\\$PATH$"' 15

    run_challenge "Prepend to PATH" \
        "Add ${YELLOW}/usr/local/mytools${NC} to the BEGINNING of your PATH for this session.\n\n  ${CYAN}Prepend${NC} so your version takes priority over system versions. ${CYAN}Append${NC} if you want system defaults to win. Always include :\$PATH to preserve existing entries." \
        "export PATH=/usr/local/mytools:\$PATH  — prepend = your dir is searched first. export = available to child processes." \
        'chk "^export PATH=.+:\\\$PATH$|^PATH=.+:\\\$PATH"' 25

    run_challenge "Create an Alias" \
        "Create an alias ${YELLOW}ll${NC} that expands to ${YELLOW}ls -lah${NC}.\n\n  ${CYAN}Aliases${NC} are shell shortcuts — simple command replacements. For shortcuts needing arguments, use functions instead. Make aliases permanent by adding them to ~/.bashrc." \
        "alias ll='ls -lah'  — alias name='command'. Permanent: add to ~/.bashrc then source it. List all aliases: alias (no args)" \
        'chk "^alias [a-zA-Z_]+=.+"' 20

    run_challenge "Export a Variable" \
        "Set ${YELLOW}EDITOR=vim${NC} and export it so child processes (like git) can see it.\n\n  ${CYAN}export${NC} marks a variable for inheritance by child processes. Without export, variables are local to the current shell — git, make, and other tools won't see them." \
        "export EDITOR=vim  — without export: var is local shell only. With export: child processes inherit it." \
        'chk "^export [A-Z_]+=.+"' 20

    run_challenge "Source a Config File" \
        "Apply changes from ${YELLOW}~/.bashrc${NC} to the current session without logging out.\n\n  ${CYAN}source${NC} runs the file in the CURRENT shell — so new aliases, exports, and functions take effect immediately. The shorthand ${CYAN}. ~/.bashrc${NC} is identical. A subshell (bash ~/.bashrc) wouldn't affect the current session." \
        "source ~/.bashrc  OR  . ~/.bashrc  — dot and source are identical. Neither starts a subshell, so changes affect THIS session." \
        'chk "^(source|\.) ~/?.bash"' 15

    run_challenge "Customise the Prompt" \
        "Set your PS1 prompt to show ${YELLOW}user@host:dir\$${NC} format.\n\n  ${CYAN}PS1${NC} is the primary prompt variable. Escape sequences: \\u=username, \\h=short hostname, \\H=FQDN, \\w=working dir, \\W=basename only, \\$=$ for users, # for root." \
        "export PS1='\\u@\\h:\\w\\\$ '  — always wrap color codes in \\[ ... \\] to prevent line length miscalculation." \
        'chk "^export PS1=.+"' 20

    cleanup_game_env
    level_complete 20
}

# ============================================================
# LEVEL 21: CRON & SCHEDULING
# ============================================================

run_level_21() {
    level_intro 21 "Cron & Scheduling" \
        "Cron runs commands at set times automatically — every backup, cleanup, health check, and report on a server is cron-driven. The crontab format is: MIN HOUR DAY MONTH WEEKDAY command. Each field has wildcards (*), ranges (1-5), steps (*/15), and lists (1,3,5). Getting cron syntax wrong silently does nothing — so test carefully." \
        "⏰   crontab -l  -e  -r  |  * * * * *  |  at  |  /etc/cron.d"
    setup_game_env

    run_challenge "List Cron Jobs" \
        "List all cron jobs for the current user.\n\n  Before adding a new cron job, always list existing ones — to avoid duplication or conflicts. ${CYAN}crontab -l${NC} prints the current crontab. ${CYAN}crontab -e${NC} opens it in your editor. ${CYAN}crontab -r${NC} removes it entirely (dangerous — no confirmation!)." \
        "crontab -l  — list. crontab -e = edit. crontab -r = REMOVE ALL (no undo). crontab -u user = act on another user's crontab (root only)" \
        'chk "^crontab -[a-zA-Z]"' 15

    run_challenge "Every Minute" \
        "Write the crontab line to run ${YELLOW}/usr/local/bin/check.sh${NC} every minute.\n\n  ${CYAN}* * * * *${NC} — five stars = every minute of every hour of every day. Format: MIN HOUR DAY MONTH WEEKDAY. Cron's minimum resolution is 1 minute." \
        "* * * * * /usr/local/bin/check.sh  — * = any value in that field. Five stars = run every minute always." \
        'chk "^\* \* \* \* \* .+"' 25

    run_challenge "Daily at 2am" \
        "Write the crontab line to run ${YELLOW}/usr/local/bin/backup.sh${NC} every day at 2:00am.\n\n  ${CYAN}0 2 * * *${NC} — minute 0 (on the hour), hour 2, any day/month/weekday. Remember: minute comes FIRST, then hour — the opposite of how we speak ('2 o'clock' = hour 2, minute 0)." \
        "0 2 * * * /usr/local/bin/backup.sh  — 0 2 = minute:0, hour:2 = 02:00. The remaining * fields mean any day/month/weekday." \
        'chk "^0 2 \* \* \* .+"' 25

    run_challenge "Every 15 Minutes" \
        "Write the crontab line to run ${YELLOW}/usr/local/bin/sync.sh${NC} every 15 minutes.\n\n  ${CYAN}*/15${NC} means 'every 15 steps' — the / operator in cron defines a step. */15 in the minute field = minutes 0, 15, 30, 45." \
        "*/15 * * * * /usr/local/bin/sync.sh  — */N = every N units. */15 = at 0,15,30,45. */2 in hours = every 2 hours." \
        'chk "^\*/[0-9]+ \* \* \* \* .+"' 25

    run_challenge "Weekdays Only" \
        "Run ${YELLOW}/usr/local/bin/report.sh${NC} at 9:00am Monday through Friday only.\n\n  The 5th cron field is the day-of-week: 0=Sunday, 1=Monday, 5=Friday, 6=Saturday (0 and 7 both mean Sunday). Ranges work: 1-5 = Monday to Friday." \
        "0 9 * * 1-5 /usr/local/bin/report.sh  — weekday field 1-5 = Mon-Fri. Use 0 or 7 for Sunday. Use 1,3,5 for Mon/Wed/Fri." \
        'chk "^0 9 \* \* 1-5 .+"' 25

    run_challenge "One-Time Future Task" \
        "Schedule ${YELLOW}/usr/local/bin/restart.sh${NC} to run once at ${YELLOW}11pm tonight${NC}.\n\n  ${CYAN}at${NC} is for one-time scheduled commands — unlike cron which repeats. ${CYAN}atq${NC} lists pending at jobs. ${CYAN}atrm N${NC} removes one." \
        "echo '/usr/local/bin/restart.sh' | at 23:00  OR  at 11pm  — at schedules one-time tasks. atq = queue, atrm = remove." \
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
        "Watch ${YELLOW}var/log/error.log${NC} in real-time, seeing new lines as they're written.\n\n  ${CYAN}tail -f${NC} (follow) stays running and prints new lines as they arrive — it's how you watch a deployment, monitor a service restart, or watch for errors during a load test. Ctrl+C to stop." \
        "tail -f var/log/error.log  — -f = follow. The most-used command during incidents. Combine with grep for filtering." \
        'chk "^tail -[a-zA-Z]*f[a-zA-Z]* .+"' 20

    run_challenge "Follow with Live Filter" \
        "Watch ${YELLOW}var/log/error.log${NC} live but only show lines containing ${YELLOW}ERROR${NC}.\n\n  ${CYAN}grep --line-buffered${NC} is essential here — without it, grep buffers output and ERROR lines might not appear until the buffer fills. The flag forces line-by-line output." \
        "tail -f var/log/error.log | grep --line-buffered 'ERROR'  — --line-buffered prevents grep from holding output in its internal buffer" \
        'chk ".*tail -[a-zA-Z]*f[a-zA-Z]* .+\| *grep .+"' 25

    run_challenge "journalctl Overview" \
        "Show all system log entries from the systemd journal.\n\n  ${CYAN}journalctl${NC} is the modern replacement for reading /var/log/syslog or /var/log/messages on systemd distros. It's structured, searchable, persistent across reboots, and much faster to query than raw text files." \
        "journalctl  — shows all entries. -n 50 = last 50 lines. -f = follow live. --since '1 hour ago' = time filter. -b = this boot only." \
        'chk "^journalctl( -[a-zA-Z]+.*)?$"' 15

    run_challenge "Filter by Service" \
        "Show logs for the ${YELLOW}sshd${NC} service only.\n\n  ${CYAN}-u${NC} (unit) filters by systemd service name — far faster than grepping /var/log/auth.log manually. Includes service start/stop events that raw log files miss." \
        "journalctl -u sshd  — -u = unit (service name). Add -f to follow live: journalctl -fu sshd" \
        'chk "^journalctl -[a-zA-Z]*u[a-zA-Z]* [a-zA-Z0-9._-]+"' 20

    run_challenge "Time-Based Filter" \
        "Show journal entries from the last hour only.\n\n  ${CYAN}--since${NC} accepts natural language and ISO formats. Combine with ${CYAN}--until${NC} for a time window. Essential for incident investigation: 'show me everything that happened between 02:00 and 02:30'." \
        "journalctl --since '1 hour ago'  — --since accepts: 'today', 'yesterday', '2024-01-15 08:00', '1 hour ago'" \
        'chk "^journalctl --since .+"' 20

    run_challenge "Write to System Log" \
        "Write the message ${YELLOW}Deployment complete${NC} to the system log from a shell script.\n\n  ${CYAN}logger${NC} writes directly to syslog. Use it in your scripts so deployment events, backups, and custom health checks appear in journalctl alongside system events — one place to look for everything." \
        "logger 'Deployment complete'  — add -t TAG to label it (e.g. -t deploy). Visible in journalctl and /var/log/syslog." \
        'chk "^logger .+"' 15

    cleanup_game_env
    level_complete 22
}

# ============================================================
# LEVEL 23: PACKAGE MANAGEMENT
# ============================================================

run_level_23() {
    level_intro 23 "Package Management" \
        "Every Linux distro has a package manager — the system for safely installing, updating, and removing software with dependency resolution. apt for Debian/Ubuntu. dnf/yum for RHEL/Fedora/CentOS. pacman for Arch. brew for macOS. The concepts are the same; only the commands differ." \
        "📦   apt  |  dnf / yum  |  brew  |  update  install  remove  search  show"
    setup_game_env

    run_challenge "Update Package Index" \
        "Refresh the local list of available packages on a Debian/Ubuntu system.\n\n  ${CYAN}apt update${NC} fetches the latest package metadata from repositories — it does NOT install or upgrade anything. Always run it before installing, or you risk getting outdated versions." \
        "sudo apt update  — fetches package lists. Does NOT change installed packages. Run before every install or upgrade." \
        'chk "^sudo apt(-get)? update$"' 15

    run_challenge "Upgrade All Packages" \
        "Upgrade all installed packages to their latest available versions on Ubuntu.\n\n  ${CYAN}apt upgrade${NC} installs new versions of packages already installed. ${CYAN}full-upgrade${NC} also handles packages that need to be removed to complete an upgrade." \
        "sudo apt upgrade  OR  sudo apt full-upgrade  — upgrade = safe updates. full-upgrade = handles dependency changes too." \
        'chk "^sudo apt(-get)? (upgrade|full-upgrade|dist-upgrade)$"' 20

    run_challenge "Install a Package" \
        "Install the package ${YELLOW}htop${NC} non-interactively (no prompts) on Ubuntu.\n\n  ${CYAN}-y${NC} auto-answers yes — critical in scripts and Dockerfiles where you can't respond interactively. Without -y, apt pauses and waits, hanging your automation." \
        "sudo apt install -y htop  — -y = yes to all prompts. In Dockerfiles and scripts ALWAYS use -y." \
        'chk "^sudo apt(-get)? install( -y| -y)? [a-zA-Z0-9_.-]+"' 20

    run_challenge "Search for a Package" \
        "Search for packages related to the keyword ${YELLOW}network${NC}.\n\n  Before installing, search first — the package name isn't always what you'd expect. ${CYAN}apt search${NC} searches both package names and descriptions." \
        "apt search network  OR  apt-cache search network  — searches names and descriptions. Use grep to filter: apt search network | grep monitor" \
        'chk "^(apt|apt-cache) search [a-zA-Z0-9_.-]+"' 15

    run_challenge "Show Package Details" \
        "Show detailed information about the ${YELLOW}curl${NC} package — version, dependencies, size, description.\n\n  Check this before installing unfamiliar packages to understand their size, what they depend on, and whether they're the right tool." \
        "apt show curl  OR  apt-cache show curl  — shows version, installed-size, depends, description, maintainer, homepage" \
        'chk "^apt(-cache)? show [a-zA-Z0-9_.-]+"' 15

    run_challenge "Remove a Package" \
        "Remove ${YELLOW}htop${NC} but keep its configuration files (in case you reinstall later).\n\n  ${CYAN}remove${NC} deletes the binary but keeps config. ${CYAN}purge${NC} also removes config files. If you're troubleshooting and might reinstall, use remove — purge if you're done permanently." \
        "sudo apt remove htop  — keeps /etc config. Use 'purge' to also delete configs. 'autoremove' cleans orphaned dependencies." \
        'chk "^sudo apt(-get)? remove [a-zA-Z0-9_.-]+"' 20

    run_challenge "RHEL / Fedora Install" \
        "Install ${YELLOW}htop${NC} on a Red Hat Enterprise Linux or Fedora system.\n\n  ${CYAN}dnf${NC} is the modern replacement for ${CYAN}yum${NC} on RHEL 8+/Fedora. Same -y flag, same concepts, different package repositories." \
        "sudo dnf install -y htop  OR  sudo yum install -y htop  — dnf = RHEL 8+/Fedora. yum = RHEL 7/CentOS. brew = macOS." \
        'chk "^sudo (dnf|yum) install( -y)? [a-zA-Z0-9_.-]+"' 20

    cleanup_game_env
    level_complete 23
}

# ============================================================
# LEVEL 24: COMPRESSION DEEP DIVE
# ============================================================

run_level_24() {
    level_intro 24 "Compression Deep Dive" \
        "Different formats trade speed for compression ratio. gzip is the universal Linux standard — fast, widely supported. bzip2 compresses better but is slower. xz achieves the best ratio and is used for Linux kernel releases and package archives. zip for Windows compatibility. Know when to use each." \
        "🗜️   gzip  gunzip  zcat  |  bzip2  bunzip2  |  xz  |  zip  unzip  |  -k keep"
    setup_game_env

    run_challenge "gzip a File" \
        "Compress ${YELLOW}home/welcome.txt${NC} with gzip.\n\n  ${CYAN}gzip${NC} replaces the original with a .gz file. Use ${CYAN}-k${NC} to keep the original. Typical ratios: 60-70% reduction on text. Used for log rotation, web transfer (Content-Encoding: gzip), and data pipelines." \
        "gzip home/welcome.txt  — creates welcome.txt.gz, REMOVES original. Use -k to keep: gzip -k home/welcome.txt" \
        'chk "^gzip( -[a-zA-Z0-9]+)* .+"' 20

    run_challenge "Decompress gzip" \
        "Decompress ${YELLOW}home/welcome.txt.gz${NC} back to the original.\n\n  ${CYAN}gunzip${NC} and ${CYAN}gzip -d${NC} are identical. The -k flag works here too to keep the .gz file." \
        "gunzip home/welcome.txt.gz  OR  gzip -d home/welcome.txt.gz  — gunzip restores the original, removes the .gz" \
        'chk "^(gunzip|gzip -d) .+"' 15

    run_challenge "Read Compressed Without Extracting" \
        "Read the contents of a .gz file without decompressing it to disk.\n\n  ${CYAN}zcat${NC} pipes decompressed content to stdout — perfect for grepping compressed log archives without storing uncompressed data. Also: zgrep, zless work directly on .gz files." \
        "zcat home/welcome.txt.gz  OR  gzip -dc home/welcome.txt.gz  — zcat/zgrep/zless work on .gz files directly" \
        'chk "^(zcat|gzip -dc|zless|zgrep) .+"' 20

    run_challenge "bzip2" \
        "Compress ${YELLOW}home/scores.txt${NC} with bzip2.\n\n  ${CYAN}bzip2${NC} typically compresses 10-15% better than gzip but is 2-4x slower. Used for source code tarballs (.tar.bz2) and where compression ratio matters more than speed." \
        "bzip2 home/scores.txt  — creates scores.txt.bz2. bunzip2 or bzip2 -d to decompress. bzcat to read compressed." \
        'chk "^bzip2( -[a-zA-Z0-9]+)* .+"' 20

    run_challenge "xz Maximum Compression" \
        "Compress ${YELLOW}home/scores.txt${NC} with xz.\n\n  ${CYAN}xz${NC} achieves the best compression ratio of common Linux formats — the Linux kernel .tar.xz is ~30% smaller than .tar.gz. The trade-off is it's significantly slower. Use for archives you'll store long-term." \
        "xz home/scores.txt  OR  xz -9 home/scores.txt  — -9 = maximum compression (slowest). xzcat/unxz to decompress." \
        'chk "^xz( -[0-9a-zA-Z]+)* .+"' 20

    run_challenge "zip for Cross-Platform" \
        "Create a zip archive of the ${YELLOW}home${NC} directory named ${YELLOW}backup.zip${NC}.\n\n  ${CYAN}zip${NC} is the right choice when sharing with Windows users — they have built-in zip support but not tar.gz. ${CYAN}unzip${NC} to extract. ${CYAN}zip -e${NC} for encrypted archives." \
        "zip -r backup.zip home/  — -r = recursive. zip is cross-platform. unzip backup.zip to extract, unzip -l to list contents." \
        'chk "^zip -[a-zA-Z]*r[a-zA-Z]* .+ .+"' 20

    run_challenge "tar with xz (Best Practice)" \
        "Create a tar archive of the ${YELLOW}home${NC} directory compressed with xz, named ${YELLOW}home.tar.xz${NC}.\n\n  ${CYAN}tar -cJf${NC} — J flag selects xz compression (j = bzip2, z = gzip, J = xz). The .tar.xz format is the Linux gold standard for software distribution." \
        "tar -cJf home.tar.xz home/  — J = xz. z = gzip (.tar.gz). j = bzip2 (.tar.bz2). All combine archive+compress in one step." \
        'chk "^tar -[cJjz]*J[cJjz]* .+ .+|^tar .*-J.* .+"' 25

    cleanup_game_env
    level_complete 24
}

# ============================================================
# LEVEL 25: STRING PROCESSING
# ============================================================

run_level_25() {
    level_intro 25 "Bash String Processing" \
        "Bash has powerful built-in string manipulation — no external process needed, no subshell overhead. Substring extraction, length, pattern stripping, and search-and-replace are all built into the parameter expansion syntax \${...}. Combined with printf, you can format output precisely. These features make scripts lean and fast." \
        "🔡   \${#v}  \${v:off:len}  \${v%pat}  \${v%%pat}  \${v#pat}  \${v##pat}  \${v//f/r}  \${v^^}"
    setup_game_env

    run_challenge "String Length" \
        "Given the variable ${YELLOW}WORD=BashQuest${NC}, print the number of characters without calling any external command.\n\n  ${CYAN}\${#var}${NC} — the hash prefix gives the length. Pure shell, no subshell. Far faster than echo \$var | wc -c in a loop." \
        "WORD=BashQuest; echo \${#WORD}  — \${#varname} = character count. Works for any variable. \${#array[@]} = array element count." \
        'chk ".*\\\$\{#[a-zA-Z_][a-zA-Z0-9_]*\}"' 25

    run_challenge "Substring Extraction" \
        "Extract the first 4 characters of ${YELLOW}WORD=BashQuest${NC}.\n\n  ${CYAN}\${var:offset:length}${NC} — offset is zero-based. ${CYAN}\${var: -4}${NC} (space before minus) gives the last 4 chars. No external command needed." \
        "WORD=BashQuest; echo \${WORD:0:4}  — :0:4 = start at char 0, take 4 chars. \${var: -3} = last 3 chars (note the space)." \
        'chk ".*\\\$\{[a-zA-Z_][a-zA-Z0-9_]*:[0-9]"' 25

    run_challenge "Strip Suffix (short)" \
        "Given ${YELLOW}FILE=report.tar.gz${NC}, strip the ${YELLOW}.gz${NC} extension to get ${YELLOW}report.tar${NC}.\n\n  ${CYAN}\${var%pattern}${NC} strips the SHORTEST match from the END. ${CYAN}\${var%%pattern}${NC} strips the LONGEST. The % pattern is glob syntax (not regex)." \
        "FILE=report.tar.gz; echo \${FILE%.gz}  — % strips shortest suffix. %%.* would strip .tar.gz (longest .*)" \
        'chk ".*\\\$\{[a-zA-Z_][a-zA-Z0-9_]*%[^}]"' 25

    run_challenge "Strip Directory from Path" \
        "Given ${YELLOW}FULL=/home/tony/scripts/bashquest.sh${NC}, extract just the filename.\n\n  ${CYAN}\${var##pattern}${NC} strips the LONGEST match from the START. ${CYAN}##*/#{NC} removes everything up to and including the last slash — equivalent to basename." \
        "FULL=/home/tony/scripts/bashquest.sh; echo \${FULL##*/}  — ## strips longest prefix. ##*/ = everything up to last /." \
        'chk ".*\\\$\{[a-zA-Z_][a-zA-Z0-9_]*##[^}]"' 25

    run_challenge "Search and Replace (all)" \
        "Given ${YELLOW}TEXT='the cat sat on the cat mat'${NC}, replace ALL occurrences of ${YELLOW}cat${NC} with ${YELLOW}dog${NC}.\n\n  ${CYAN}\${var//find/replace}${NC} — double slash replaces ALL occurrences. Single slash ${CYAN}\${var/find/replace}${NC} replaces only the first." \
        "TEXT='the cat sat on the cat mat'; echo \${TEXT//cat/dog}  — // = all occurrences. / = first only." \
        'chk ".*\\\$\{[a-zA-Z_][a-zA-Z0-9_]*//"' 25

    run_challenge "Uppercase Conversion" \
        "Convert the value of ${YELLOW}NAME=bashquest${NC} to uppercase without using tr or awk.\n\n  ${CYAN}\${var^^}${NC} converts all characters to uppercase (bash 4+). ${CYAN}\${var,,}${NC} lowercases. ${CYAN}\${var^}${NC} capitalises the first character only.\n  ${DIM}Note: macOS ships bash 3.2 where ^^ is unavailable — use tr 'a-z' 'A-Z' there.${NC}" \
        "NAME=bashquest; echo \${NAME^^}  — bash 4+ only. macOS/bash3 alternative: echo \$NAME | tr 'a-z' 'A-Z'" \
        'chk ".*\\\$\{[a-zA-Z_][a-zA-Z0-9_]*\^\^?\}"' 20

    run_challenge "printf Formatting" \
        "Print the number ${YELLOW}3.14159265${NC} rounded to exactly 2 decimal places using printf.\n\n  ${CYAN}printf '%.2f'${NC} — printf gives precise output control. %.2f = float with 2 decimal places. %d = integer, %s = string, %10s = 10-char right-aligned, %-10s = left-aligned." \
        "printf '%.2f\\n' 3.14159265  — %.2f = 2 decimal places. printf is far more precise than echo for formatted output." \
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
        "Create an indexed array called ${YELLOW}SERVERS${NC} containing three values: ${YELLOW}web01 web02 db01${NC}.\n\n  ${CYAN}()${NC} groups elements, spaces separate them. No commas — bash uses spaces, not commas. Quote elements that contain spaces." \
        "SERVERS=(web01 web02 db01)  — parentheses + space-separated. No commas. Quote elements with spaces: ('web 01' 'web 02')" \
        'chk "^[A-Z_]+=\([a-zA-Z0-9_.\" -]+\)$"' 20

    run_challenge "Access One Element" \
        "Print the first element of ${YELLOW}SERVERS=(web01 web02 db01)${NC}.\n\n  ${CYAN}\${arr[0]}${NC} — zero-indexed. Curly braces are REQUIRED: \$arr[0] doesn't work (gives you literal '[0]' appended to \$arr's value)." \
        "SERVERS=(web01 web02 db01); echo \${SERVERS[0]}  — zero-indexed. Curly braces required for array access." \
        'chk ".*\\\$\{[A-Z_]+\[[0-9]+\]\}"' 20

    run_challenge "All Elements" \
        "Print ALL elements of ${YELLOW}SERVERS=(web01 web02 db01)${NC} as separate words.\n\n  ${CYAN}\${arr[@]}${NC} expands to all elements as separate words (safe for loops). ${CYAN}\${arr[*]}${NC} joins all into one string — dangerous in loops if elements have spaces. Always use @ in for loops." \
        "SERVERS=(web01 web02 db01); echo \${SERVERS[@]}  — @ = all as separate words. Always use @ not * in loops." \
        'chk ".*\\\$\{[A-Z_]+\[@\]\}"' 20

    run_challenge "Array Length" \
        "Print how many elements are in ${YELLOW}SERVERS=(web01 web02 db01)${NC}.\n\n  ${CYAN}\${#arr[@]}${NC} — combine the # (length) operator with [@] (all elements). This gives element count, not string length." \
        "SERVERS=(web01 web02 db01); echo \${#SERVERS[@]}  — \${#arr[@]} = element count. \${#arr[0]} = string length of first element." \
        'chk ".*\\\$\{#[A-Z_]+\[@\]\}"' 25

    run_challenge "Loop Over an Array" \
        "Loop over ${YELLOW}SERVERS=(web01 web02 db01)${NC} and print each server name.\n\n  ${CYAN}for item in \"\${arr[@]}\"${NC} — quoting \"\${arr[@]}\" is critical: it preserves elements with spaces as single items. Unquoted, spaces in elements would split them into separate words." \
        'SERVERS=(web01 web02 db01); for s in "${SERVERS[@]}"; do echo $s; done  — always quote "${arr[@]}" in for loops' \
        'chk "^for .+in .*\\\$\{[A-Z_]+\[@\]\}.*; *do .+done$"' 25

    run_challenge "Append to Array" \
        "Add ${YELLOW}db02${NC} to the end of ${YELLOW}SERVERS=(web01 web02 db01)${NC}.\n\n  ${CYAN}arr+=(element)${NC} appends without removing existing elements. You can append multiple at once: arr+=(e1 e2 e3)." \
        "SERVERS=(web01 web02 db01); SERVERS+=(db02)  — += appends element(s). Direct index: SERVERS[3]=db02 also works." \
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
        "Production-grade scripts don't silently fail. They catch errors, clean up temp files, and exit with meaningful status codes. set -e, set -u, set -o pipefail, and trap form the standard safety net. Functions encapsulate reusable logic and communicate success or failure through exit codes — exactly like commands." \
        "🛡️   function  \$?  return  set -euo pipefail  trap  exit  \$1 \$2 \$@"
    setup_game_env

    run_challenge "Define a Function" \
        "Define a bash function called ${YELLOW}greet${NC} that accepts a name argument and prints ${YELLOW}Hello, NAME!${NC}.\n\n  ${CYAN}\$1, \$2...${NC} inside a function are the FUNCTION's arguments, not the script's. Functions create their own positional parameter scope." \
        'greet() { echo "Hello, $1!"; }  — then call it: greet Tony. Functions share global variables but have their own $1 $2 $@' \
        'chk "^[a-z_]+\(\) *\{.+\}$"' 25

    run_challenge "Check Exit Code" \
        "Run ${YELLOW}ls /nonexistent 2>/dev/null${NC} and immediately check whether it succeeded.\n\n  ${CYAN}\$?${NC} holds the exit code of the last command: 0 = success, non-zero = failure. Check it IMMEDIATELY — it's overwritten after every command. Scripts use if \$? to branch on success/failure." \
        "ls /nonexistent 2>/dev/null; echo \$?  — \$?=0 means success. \$?=1 or higher means failure. Check right after the command." \
        'chk ".*echo \\\$\?"' 20

    run_challenge "Exit on Error" \
        "Add the shell option that makes the script exit immediately when any command returns a non-zero exit code.\n\n  ${CYAN}set -e${NC} is the most important script safety option. Without it, a script merrily continues after failures — deleting the wrong directory, deploying broken code, corrupting data." \
        "set -e  — exit immediately on any non-zero exit. Can cause issues with commands that intentionally return non-zero (like grep with no match). Use || true to allow those." \
        'chk "^set -[euo]*e[euo]*$"' 20

    run_challenge "Fail on Unset Variables" \
        "Enable the shell option that treats using an unset variable as an error and exits.\n\n  ${CYAN}set -u${NC} prevents the classic bash typo bug: a misspelled variable silently expands to empty string. \${TMPDIR:-/tmp} provides a default value and still works with -u." \
        "set -u  — unset variable = fatal error. Use \${var:-default} to provide safe defaults for optional variables." \
        'chk "^set -[euo]*u[euo]*$"' 20

    run_challenge "Catch Pipeline Failures" \
        "Enable the option that makes a pipeline fail if ANY command in it fails, not just the last.\n\n  ${CYAN}set -o pipefail${NC} — by default, 'false | true' returns 0 (success) because only the last command's exit code counts. pipefail catches failures anywhere in the pipe — critical for data pipelines where a corrupt grep result shouldn't look like success." \
        "set -o pipefail  — without it: 'false | true' exits 0. With it: 'false | true' exits 1. Always add alongside set -e." \
        'chk "^set -o pipefail$"' 25

    run_challenge "Cleanup with trap" \
        "Set a trap to print ${YELLOW}Cleaning up...${NC} and remove ${YELLOW}/tmp/workdir${NC} whenever the script exits.\n\n  ${CYAN}trap 'commands' EXIT${NC} fires on ANY exit: normal completion, set -e failure, SIGTERM, Ctrl+C. It's the reliable cleanup mechanism — more dependable than trying to clean up in every error path." \
        "trap 'echo Cleaning up...; rm -rf /tmp/workdir' EXIT  — EXIT fires on any exit. Also trap specific signals: INT TERM ERR." \
        'chk "^trap .+ EXIT$"' 25

    run_challenge "The Safety Header" \
        "Write the recommended safety header for any serious bash script (set flags on one line).\n\n  ${CYAN}set -euo pipefail${NC} is the industry-standard opening for production scripts: e=exit on error, u=error on unset var, o pipefail=catch pipe failures. Often paired with IFS=\$'\\n\\t' to avoid word-splitting surprises." \
        "set -euo pipefail  — the three most important bash safety options combined. Add to every script that runs in production." \
        'chk "^set -[euo]*euo[euo]* *pipefail|^set -euo pipefail$|^set -[euo]+ *&& *set -o pipefail"' 25

    cleanup_game_env
    level_complete 27
}

# ============================================================
# LEVEL 28: SYSTEMD & SERVICES
# ============================================================

run_level_28() {
    level_intro 28 "Systemd & Services" \
        "On modern Linux, systemd manages everything that runs as a service — web servers, databases, cron, SSH, even your desktop. systemctl controls services: start, stop, enable, disable, status, and restart. journalctl reads their logs. If you manage Linux servers, these are the commands you use every single day." \
        "⚙️   systemctl start/stop/enable/disable/status/restart  |  journalctl -u -f  |  unit files"
    setup_game_env

    run_challenge "Check Service Status" \
        "Check whether ${YELLOW}nginx${NC} is running and see its recent log output.\n\n  ${CYAN}systemctl status${NC} gives you: Active state (running/failed/inactive), how long it's been running, its PID and memory usage, and the last 10 log lines. First command to run when a service isn't working." \
        "systemctl status nginx  — shows: Active state, PID, memory, last log entries. Exit code: 0=active, 3=inactive, non-0=failed." \
        'chk "^systemctl status [a-zA-Z0-9_.-]+"' 15

    run_challenge "Start a Service" \
        "Start the ${YELLOW}nginx${NC} service right now.\n\n  ${CYAN}start${NC} runs the service immediately but does NOT enable it on boot. After a reboot it stays stopped. Use ${CYAN}enable --now${NC} to do both in one command." \
        "sudo systemctl start nginx  — starts now only. Does NOT survive reboot unless also enabled. Check with: systemctl status nginx" \
        'chk "^sudo systemctl start [a-zA-Z0-9_.-]+"' 20

    run_challenge "Enable on Boot" \
        "Enable ${YELLOW}nginx${NC} to start automatically every time the system boots.\n\n  ${CYAN}enable${NC} creates a symlink in the current target's 'wants' directory. ${CYAN}enable --now${NC} is the most common form — it enables AND starts in one command." \
        "sudo systemctl enable nginx  OR  sudo systemctl enable --now nginx  — enable = survives reboot. --now also starts immediately." \
        'chk "^sudo systemctl enable( --now)? [a-zA-Z0-9_.-]+"' 20

    run_challenge "Restart After Config Change" \
        "Restart ${YELLOW}nginx${NC} after you've edited its configuration file.\n\n  ${CYAN}restart${NC} = stop then start (brief downtime). ${CYAN}reload${NC} = send SIGHUP to re-read config without downtime (only works if the service supports it). For nginx: reload is preferred in production." \
        "sudo systemctl restart nginx  OR  sudo systemctl reload nginx  — reload is zero-downtime if the service supports it" \
        'chk "^sudo systemctl re(start|load) [a-zA-Z0-9_.-]+"' 20

    run_challenge "Stop and Disable" \
        "Stop ${YELLOW}nginx${NC} AND prevent it from starting on next boot in one efficient way.\n\n  Stopping alone leaves it enabled — it will restart on next reboot. ${CYAN}disable --now${NC} disables boot start AND stops immediately." \
        "sudo systemctl disable --now nginx  — --now also stops the service. Without --now: disabled but still running until next reboot." \
        'chk "^sudo systemctl disable( --now)? [a-zA-Z0-9_.-]+"' 20

    run_challenge "Live Service Logs" \
        "Follow the live log output of ${YELLOW}nginx${NC} as new entries arrive.\n\n  ${CYAN}-f${NC} (follow) + ${CYAN}-u${NC} (unit) is the most-used journalctl combination — watch a specific service's logs stream in real time during a deployment or incident." \
        "journalctl -fu nginx  — -f=follow live, -u=unit (service). Add --since '5 min ago' to start from recent history." \
        'chk "^journalctl -[a-zA-Z]*f[a-zA-Z]*u[a-zA-Z]* [a-zA-Z0-9_.-]+|^journalctl -[a-zA-Z]*u[a-zA-Z]*f[a-zA-Z]* [a-zA-Z0-9_.-]+"' 25

    run_challenge "List Failed Services" \
        "Show all systemd units that are currently in a FAILED state.\n\n  ${CYAN}--state=failed${NC} quickly shows everything that's broken on the system. After a reboot or deploy, run this as your first health check." \
        "systemctl --state=failed  OR  systemctl list-units --state=failed  — shows only failed units. Fix: systemctl reset-failed after resolving the issue." \
        'chk "^systemctl.*--state=failed|^systemctl list-units.*failed"' 20

    run_challenge "Write a Service Unit File" \
        "Show the command to create a systemd unit file for a service that runs ${YELLOW}/usr/local/bin/myapp${NC}.\n\n  Unit files live in ${YELLOW}/etc/systemd/system/${NC}. After creating/editing: ${CYAN}systemctl daemon-reload${NC} to pick up changes. A minimal unit needs [Unit], [Service] with ExecStart=, and [Install] with WantedBy=." \
        "cat > /etc/systemd/system/myapp.service <<EOF  — after writing: systemctl daemon-reload && systemctl enable --now myapp" \
        'chk ".*systemd/system/.+\\.service|.*daemon-reload"' 25

    cleanup_game_env

    clear_screen
    echo -e "${YELLOW}"
    echo ' ██████╗ ██████╗ ███╗   ██╗ ██████╗ ██████╗  █████╗ ████████╗███████╗██╗'
    echo '██╔════╝██╔═══██╗████╗  ██║██╔════╝ ██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██║'
    echo '██║     ██║   ██║██╔██╗ ██║██║  ███╗██████╔╝███████║   ██║   ███████╗██║'
    echo '██║     ██║   ██║██║╚██╗██║██║   ██║██╔══██╗██╔══██║   ██║   ╚════██║╚═╝'
    echo '╚██████╗╚██████╔╝██║ ╚████║╚██████╔╝██║  ██║██║  ██║   ██║   ███████║██╗'
    echo ' ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝'
    echo -e "${NC}"
    echo -e "  ${LCYAN}You have completed ALL 28 levels of BashQuest, ${BOLD}${PLAYER_NAME}${NC}${LCYAN}!${NC}"
    echo -e "  ${WHITE}You are a true Linux master. 🐧⚔️  Final XP: ${YELLOW}${PLAYER_XP}${NC}"
    PLAYER_LEVEL=29; save_progress
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
        *) echo -e "\n${LGREEN}  🏆 All 28 levels complete — true master!${NC}"; press_enter; main_menu ;;
    esac
}

run_current_level() {
    dispatch_level "$PLAYER_LEVEL"
}

# ---- ENTRY ----

trap 'cleanup_game_env' EXIT
trap 'echo -e "\n${YELLOW}Use option [5] Logout or [3] Quit to exit cleanly.${NC}"' INT

startup_screen
