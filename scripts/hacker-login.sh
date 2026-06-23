#!/usr/bin/env bash
# hacker-login.sh — Matrix-style boot animation + system info
# Run at graphical session start

COLS=$(tput cols)
LINES=$(tput lines)

CYAN='\033[1;36m'
GREEN='\033[1;32m'
PURPLE='\033[1;35m'
PINK='\033[1;31m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# Matrix rain
matrix_rain() {
    local duration=$1
    local start=$(date +%s)
    while [ $(($(date +%s) - start)) -lt $duration ]; do
        local line=$((RANDOM % LINES))
        local col=$((RANDOM % COLS))
        local char=$(printf "\\$(printf '%03o' $((RANDOM % 94 + 33)))")
        printf "\033[%d;%dH${GREEN}%s${RESET}" "$line" "$col" "$char"
        sleep 0.005
    done
}

clear
echo -e "${PURPLE}"
echo "  ╔══════════════════════════════════════════════════════════╗"
echo "  ║                                                          ║"
echo "  ║              ${CYAN}MSS TERMINAL v2.0${PURPLE}                         ║"
echo "  ║              ${GREEN}secure shell — authenticated${PURPLE}               ║"
echo "  ║                                                          ║"
echo "  ╚══════════════════════════════════════════════════════════╝"
echo -e "${RESET}"
echo
echo -e "${CYAN}  [${YELLOW}*${CYAN}] Loading kernel modules...${RESET}"
sleep 0.3
echo -e "${CYAN}  [${YELLOW}*${CYAN}] Initializing crypto subsystem...${RESET}"
sleep 0.3
echo -e "${CYAN}  [${YELLOW}*${CYAN}] Mounting encrypted volumes...${RESET}"
sleep 0.3
echo -e "${CYAN}  [${YELLOW}*${CYAN}] Verifying TPM attestation...${RESET}"
sleep 0.3
echo -e "${CYAN}  [${GREEN}✓${CYAN}] Bypassing corporate firewall...${RESET}"
sleep 0.2
echo -e "${CYAN}  [${GREEN}✓${CYAN}] Establishing tor relay...${RESET}"
sleep 0.2
echo -e "${CYAN}  [${GREEN}✓${CYAN}] Loading exploit toolkit...${RESET}"
sleep 0.3
echo

# Short matrix burst
matrix_rain 1

echo -e "${GREEN}"
echo "  ┌─[ $(whoami)@$(hostname) ]─[ $(date '+%H:%M:%S') ]"
echo "  │"
echo "  └─$ ${RESET}"