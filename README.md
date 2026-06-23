# santhan's Arch Linux hacker desktop

Bootstrap-ready Arch Linux setup with a Hyprland-based hacker aesthetic, full cybersecurity toolkit, and curated dev environment.

## What's included

### Rice (Hyprland stack)
  • **Hyprland** — Wayland compositor with snappy animations
  • **hyprlock** — hacker-themed lock/login screen with timestamp + neon text
  • **hypridle** — auto-lock after 5 min idle
  • **Waybar** — top status bar with workspaces, clock, system stats
  • **Kitty** — terminal with Catppuccin Mocha theme
  • **Rofi** — app launcher
  • **swaync** — notification daemon
  • **wlogout** — power menu
  • **mako** — low-level notifications
  • **Starship** — git-aware shell prompt

### Cybersecurity toolkit
Recon: `nmap`, `masscan`, `gobuster`, `ffuf`, `feroxbuster`
Web: `burpsuite`, `zaproxy`, `sqlmap`, `nikto`, `wfuzz`
Auth/Crack: `john`, `hashcat`, `hydra`, `seclists`, `wordlists`
Network: `wireshark`, `tcpdump`, `netcat`, `socat`, `ettercap`, `bettercap`
Wireless: `aircrack-ng`, `wifite`, `kismet`
Exploit: `metasploit`, `crackmapexec`, `impacket`, `responder`, `bloodhound`
Reverse Eng: `ghidra`, `radare2`, `rizin`, `cutter`, `gdb`, `pwndbg`
Forensics: `volatility3`, `binwalk`, `foremost`, `sleuthkit`
Privacy: `tor`, `torsocks`, `proxychains-ng`, `macchanger`
VPN/Net: `tor`, `proxychains-ng`

### Dev environment
Languages: `python`, `go`, `rust`, `nodejs`, `gcc`, `gdb`
Build: `cmake`, `ninja`, `make`, `pkgconf`
Containers: `docker`, `docker-compose`
Shell: `zsh`, `tmux`, `fzf`, `ripgrep`, `fd`, `bat`, `eza`, `btop`, `neofetch`, `starship`
Editor: `neovim`

### Pre-configured aliases (in .bashrc)
  • `ls/ll/lt` → eza (icons, tree view)
  • `cat` → bat
  • `find` → fd
  • `top` → btop
  • `nmap-quick/full/stealth` → preconfigured scans
  • `sniff/sniff-cli` → wireshark/tshark
  • `crack/hashcrack` → john/hashcat
  • `update/install/search/remove/cleanup` → pacman shortcuts

## Install on a fresh Arch

```bash
# 1. Boot Arch ISO, partition, mount, pacstrap, arch-chroot
# 2. Inside chroot:
pacman -S git
git clone https://github.com/santhan2007/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The install script:
  1. Installs everything (pacman + AUR via paru)
  2. Enables services (NetworkManager, docker)
  3. Symlinks all dotfiles to $HOME
  4. Configures /etc/makepkg.conf
  5. Reboot, select Hyprland at login

## Usage

  • **Login screen** → automatic on lock/suspend (after 5 min idle)
  • **App launcher** → `SUPER + D`
  • **Terminal** → `SUPER + RETURN`
  • **Lock now** → `SUPER + L`
  • **Logout/Reboot/Shutdown** → run `wlogout`
  • **Screenshot** → `Print` (selection) or `SHIFT + Print` (full)

## Color palette (Catppuccin Mocha)

```
background  #1e1e2e
surface     #313244
text        #cdd6f4
accent      #c6a0f6  (lavender)
green       #a6e3a1
red         #f38ba8
yellow      #f9e2af
blue        #89b4fa
teal        #94e2d5
pink        #f5bde6
```

## Files in this repo

```
bash/             .bashrc, .bash_profile, .bash_logout
git/              .gitconfig
hyprland/         hyprland.conf, hyprlock.conf, hypridle.conf
waybar/           config, style.css
kitty/            kitty.conf
rofi/             config.rasi
mako/             config
swaync/           config.json
wlogout/          layout, style.css
starship/         starship.toml
scripts/          hacker-login.sh (matrix-style boot animation)
makepkg/          makepkg.conf snippet
wallpapers/       hacker.png (placeholder)
install.sh        one-shot bootstrap
```

## Notes

  • **SSH private keys are NEVER committed.** Generate per-machine with `ssh-keygen`.
  • **No secrets in this repo.** Verified clean.
  • **Idempotent install.** Re-running `./install.sh` is safe — existing configs get backed up with timestamp suffix.

## For authorized security testing only

Tools installed here are dual-use. Use them only on:
  • Systems you own
  • Systems you have written permission to test
  • CTF environments
  • Lab environments designed for security education

Unauthorized access to computer systems is illegal under India's IT Act 2000 (and equivalent laws elsewhere). KLU CSE Security coursework expects responsible disclosure.