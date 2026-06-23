# ~/.bashrc — santhan

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ----- PATHS -----
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/share/cargo/bin:$PATH"

# ----- ALIASES -----
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first'
alias lt='eza --tree --level=2 --icons'
alias cat='bat --style=header,grid --paging=never'
alias grep='grep --color=auto'
alias vim='nvim'
alias top='btop'
alias find='fd'
alias ps='procs' 2>/dev/null || alias ps='ps auxf'
alias ports='ss -tulanp'
alias serve='python -m http.server'

# Git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'

# Security tools
alias nmap-quick='nmap -sC -sV -oN scan.txt'
alias nmap-full='nmap -p- -sC -sV -oN full_scan.txt'
alias nmap-stealth='nmap -sS -sC -sV -oN stealth_scan.txt'
alias sniff='wireshark'
alias sniff-cli='tshark'
alias crack='john'
alias hashcrack='hashcat -m 0 -a 0'

# System
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias search='pacman -Ss'
alias remove='sudo pacman -Rns'
alias orphans='pacman -Qdtq'
alias cleanup='sudo pacman -Sc && paccache -r'

# ----- PROMPT -----
eval "$(starship init bash)"

# ----- HACKER GREETING -----
if [ -n "$PS1" ] && [ -z "$NO_HACKER_BANNER" ]; then
    clear
    figlet -f small "MSS Terminal" 2>/dev/null || echo "=========================================="
    echo -e "  \e[1;35m  user:\e[0m \e[1;36m$(whoami)\e[0m@\e[1;36m$(hostname)\e[0m"
    echo -e "  \e[1;35m  date:\e[0m \e[1;33m$(date '+%A, %d %B %Y — %H:%M:%S')\e[0m"
    echo -e "  \e[1;35m  uptime:\e[0m \e[1;32m$(uptime -p)\e[0m"
    echo -e "  \e[1;35m  kernel:\e[0m \e[1;34m$(uname -r)\e[0m"
    echo -e "  \e[1;35m  shell:\e[0m  \e[1;31m$SHELL\e[0m"
    echo "=========================================="
fi

# ----- TOOLS CHECK -----
# Warn if running as root
if [ "$EUID" -eq 0 ]; then
    echo -e "\e[1;31m[!] Running as root — be careful\e[0m"
fi

# ----- HISTORY -----
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth
shopt -s histappend