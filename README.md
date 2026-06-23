# santhan's Arch Linux hacker desktop

Full Hyprland-based hacker workstation with curated cybersecurity toolkit, professional dev environment, voice/video/multimedia tools, and notes/sync/backup stack. Clone + run = ready.

## What's inside (full list)

### Desktop (Hyprland Wayland rice)
- Hyprland, hyprlock, hypridle, hyprshot
- Waybar (workspaces, system stats, themed)
- Kitty terminal (Catppuccin Mocha)
- Rofi launcher, swaync, mako, wlogout
- Starship shell prompt
- swww animated wallpapers

### Cybersecurity toolkit
**Recon**: nmap, masscan, gobuster, ffuf, feroxbuster, dirb, subfinder, httpx, nuclei, nikto, wfuzz, theharvester, recon-ng, maltego, dnsutils
**Web**: burpsuite, zaproxy, sqlmap, wpscan
**Auth/Crack**: john, hashcat, hydra, hashcat-utils, seclists, wordlists, steghide, stegseek
**Network**: wireshark, tcpdump, netcat, socat, ettercap, bettercap
**Wireless**: aircrack-ng, wifite, kismet
**Exploit**: metasploit, crackmapexec, impacket, responder, bloodhound, evil-winrm, routersploit, exploitdb, searchsploit
**PrivEsc**: linpeas, winpeas, mimipenguin
**Social**: setoolkit, beef-xss
**RevEng**: ghidra, radare2, rizin, cutter, gdb+pwndbg
**Forensics**: volatility3, binwalk, foremost, sleuthkit
**Privacy**: tor, torsocks, proxychains-ng, macchanger, veracrypt, keepassxc, pass, gpg

### Languages & dev tools
python, go, rust, nodejs, gcc, gdb, cmake, ninja, docker, docker-compose
LSP: pyright, gopls, rust-analyzer, marksman
Lint/format: shellcheck, shfmt, stylua, black, ruff, pyright, isort

### Shell productivity
zsh, tmux, fzf, ripgrep, fd, bat, eza, btop, htop, neofetch, starship, zoxide, mcfly, lazygit, lazydocker, broot, delta, dysk, sd, xsv, tokei, hyperfine, pueue, just, watchexec, tldr, navi, cheat, ipython, bpython, glow, mdcat, lynx, w3m

### Editors
- **Neovim** (lazy.nvim, LSP, telescope, treesitter, catppuccin, lualine, gitsigns)
- nvim-tree file explorer
- All LSPs preconfigured

### Notes / Productivity
obsidian, task, timewarrior, calcurse, khal, vdirsyncer, signal-desktop, discord

### Sync / Backup / Cloud
syncthing, rclone, borg, timeshift

### Multimedia (voice / video / animations)
**Media**: mpv, vlc, obs-studio, ffmpeg, yt-dlp, streamlink, cava, cmus, sox, imagemagick
**Voice (TTS)**: piper-tts (neural), espeak-ng, festival — `voice "text"` or `say "text"`
**Speech-to-text**: whisper-cpp (local OpenAI Whisper) — `transcribe recording.wav` or `transcribe --live`
**OCR**: tesseract

### System monitoring
btop, htop, btop, glances, iotop, powertop, iftop, nethogs, sysstat

### Helper commands (in PATH)
- `hack` — matrix-style boot animation in current shell
- `voice "text"` — text-to-speech
- `say "text"` — alias for voice
- `transcribe file.wav` — speech-to-text (local)
- `transcribe --live` — record from mic, transcribe
- `sshot` — screenshot, auto-save + copy to clipboard
- `sshot region` — region screenshot
- `sshot window` — window screenshot
- `lg` — lazygit
- `ld` — lazydocker

### Keybindings (Hyprland)
- `SUPER + RETURN` — terminal
- `SUPER + D` — app launcher (rofi)
- `SUPER + L` — lock (hacker login screen)
- `SUPER + Q` — kill active window
- `SUPER + F` — fullscreen
- `SUPER + V` — toggle floating
- `Print` — screenshot region
- `SHIFT + Print` — screenshot full

## Install

### On a fresh Arch install (manual)
```bash
pacman -S git
git clone https://github.com/santhan2007/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```
The install script:
1. Installs everything (pacman + AUR via paru)
2. Enables services (NetworkManager, docker)
3. Symlinks all dotfiles
4. Configures /etc/makepkg.conf
5. Reboot, select Hyprland at SDDM

### On an existing system (just install packages, skip rice)
```bash
sudo pacman -S --needed - < pkglist.txt
```

## Color palette (Catppuccin Mocha — consistent everywhere)
```
bg          #1e1e2e
surface     #313244
overlay     #45475a
text        #cdd6f4
subtext     #a6adc8
accent      #c6a0f6  (lavender)
green       #a6e3a1
red         #f38ba8
yellow      #f9e2af
blue        #89b4fa
teal        #94e2d5
pink        #f5bde6
orange      #fab387
```

## Repo structure
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
nvim/             init.lua (lazy.nvim + LSP + telescope + catppuccin)
lazygit/          config.yml
delta/            delta.gitconfig
btop/             btop.conf
htop/             htoprc
tmux/             tmux.conf
scripts/          hack, voice, say, transcribe, sshot, lg, ld, hacker-login.sh
makepkg/          makepkg.conf snippet
wallpapers/       hacker.png
install.sh        one-shot bootstrap
pkglist.txt       flat package list
README.md         this file
```

## Notes
- SSH private keys are NEVER committed. Generate per machine.
- Idempotent install — re-running is safe (existing configs → `.bak.<timestamp>`).
- The hacker aesthetic is the visual identity; the underlying tools are professional-grade and useful for KLU CSE Security coursework.

## Authorized use only
Tools in this repo are dual-use. Use them only on systems you own, have written permission to test, or are part of CTF / lab environments. KLU CSE Security coursework expects responsible disclosure.