#!/usr/bin/env bash
# santhan's full Arch setup — every tool a 10+ year hacker needs
# Run on a fresh Arch install: git clone https://github.com/santhan2007/dotfiles ~/dotfiles && cd ~/dotfiles && ./install.sh
# Idempotent — safe to re-run.

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
HOME_DIR="$HOME"

# ============================================================
# Helpers
# ============================================================

# Cache sudo for the whole script
sudo -v
( while true; do sudo -n true; sleep 50; kill -0 "$$" 2>/dev/null || exit; done ) &
SUDOKEEPER=$!
trap "kill $SUDOKEEPER 2>/dev/null || true" EXIT

# Install with failure tolerance (AUR sometimes breaks)
try_install() {
    if sudo pacman -S --needed --noconfirm "$@" 2>/dev/null; then
        return 0
    else
        echo "  ! pacman install failed for: $*"
        return 0  # don't abort
    fi
}

try_aur_install() {
    if paru -S --needed --noconfirm "$@" 2>/dev/null; then
        return 0
    else
        echo "  ! AUR install failed for: $* (skipping — likely missing/unmaintained)"
        return 0  # don't abort
    fi
}

# ============================================================
# 1. BASE + DEV TOOLS
# ============================================================

echo "==> [1/10] Base + dev tools"
try_install \
    base-devel git vim nano \
    gcc gdb make cmake ninja pkgconf autoconf automake libtool \
    python python-pip python-virtualenv python-pipenv \
    go rust nodejs npm yarn \
    docker docker-compose docker-buildx \
    openssh rsync wget curl jq yq unzip p7zip zip unrar \
    shellcheck shfmt stylua lua-language-server \
    black ruff pyright isort \
    gopls rust-analyzer marksman \
    pandoc texinfo

echo "==> [2/10] Shell + terminal productivity"
try_install \
    tmux tmuxp zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting \
    ripgrep fd fzf bat eza btop htop neofetch starship zoxide mcfly \
    neovim lazygit lazydocker broot delta dysk choose-rustic sd xsv tokei \
    hyperfine pueue just watchexec \
    tldr navi cheat choose \
    ipython bpython \
    glow mdcat lynx w3m \
    tree-sitter

# ============================================================
# 2. WAYLAND RICE
# ============================================================

echo "==> [3/10] Wayland rice stack"
try_install \
    hyprland hyprlock hypridle hyprland-qtutils hyprshot \
    waybar mako swaync wlogout \
    rofi-wayland swww grim slurp wl-clipboard cliphist \
    kitty alacritty foot \
    qt5-wayland qt6-wayland \
    polkit-gnome \
    xdg-desktop-portal-hyprland xdg-utils \
    pipewire pipewire-pulse wireplumber pavucontrol \
    brightnessctl playerctl \
    thunar thunar-archive-plugin thunar-media-tags-plugin \
    network-manager-applet blueman \
    sddm

echo "==> [4/10] Fonts"
try_install \
    ttf-jetbrains-mono-nerd ttf-firacode-nerd ttf-hack-nerd \
    noto-fonts noto-fonts-emoji noto-fonts-cjk \
    ttf-font-awesome ttf-meslo-nerd \
    awesome-terminal-fonts \
    librsvg  # needed by wallpaper generator

# ============================================================
# 3. MULTIMEDIA: VOICE, VIDEO, TTS, OCR
# ============================================================

echo "==> [5/10] Multimedia (voice, video, TTS, OCR)"
try_install \
    ffmpeg imagemagick sox cava cmus \
    mpv vlc obs-studio \
    yt-dlp streamlink \
    espeak-ng festival festival-english \
    piper-tts piper-bin \
    tesseract tesseract-data-eng \
    whisper-cpp

# ============================================================
# 4. CYBERSECURITY TOOLKIT (CORE)
# ============================================================

echo "==> [6/10] Cybersecurity toolkit (core)"
try_install \
    nmap masscan wireshark-qt tcpdump netcat-openbsd socat \
    aircrack-ng kismet wifite bettercap ettercap \
    john hashcat hydra seclists wordlists \
    gobuster ffuf feroxbuster dirb \
    sqlmap nikto wfuzz zaproxy \
    metasploit \
    impacket responder crackmapexec bloodhound \
    ghidra radare2 rizin cutter \
    volatility3 binwalk foremost sleuthkit \
    gdb strace ltrace lsof \
    tor torsocks proxychains-ng macchanger \
    firefox chromium curl \
    exploitdb \
    dnsutils whois bind

# ============================================================
# 5. CYBERSECURITY TOOLKIT (AUR / ADVANCED)
# ============================================================

echo "==> [7/10] Cybersecurity toolkit (AUR + advanced)"
try_aur_install \
    burpsuite pro \
    pwndbg wireshark-cli \
    hashcat-utils steghide stegseek \
    evil-winrm routersploit \
    theharvester recon-ng maltego \
    subfinder httpx nuclei \
    wpscan \
    exploitdb-searchsploit-git \
    mimipenguin linpeas winpeas \
    setoolkit beef-xss \
    gdb-tools

# ============================================================
# 6. PRODUCTIVITY + NOTES
# ============================================================

echo "==> [8/10] Productivity + notes"
try_install \
    obsidian \
    task timewarrior calcurse khal vdirsyncer \
    keepassxc pass gpg gnupg \
    veracrypt wireguard-tools \
    signal-desktop \
    rclone borg \
    timeshift syncthing \
    signal-boost discord

# ============================================================
# 7. ENABLE SERVICES
# ============================================================

echo "==> [9/10] Enabling services"
sudo systemctl enable --now NetworkManager docker || true
sudo usermod -aG docker "$USER" 2>/dev/null || true
sudo systemctl enable --now sshd || true

# ============================================================
# 8. SYSTEM TWEAKS
# ============================================================

if grep -q '^#BUILDDIR=/tmp/makepkg' /etc/makepkg.conf 2>/dev/null; then
    sudo sed -i 's|^#BUILDDIR=/tmp/makepkg|BUILDDIR=/tmp/makepkg|' /etc/makepkg.conf
    echo "  enabled BUILDDIR=/tmp/makepkg"
fi

# Allow running docker without sudo (effective after re-login)
if ! getent group docker | grep -q "$USER"; then
    sudo usermod -aG docker "$USER" 2>/dev/null || true
fi

# ============================================================
# 9. SYMLINK DOTFILES
# ============================================================

link() {
    local src="$1"
    local dst="$2"
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        if [ ! -L "$dst" ] || [ "$(readlink -f "$dst")" != "$(readlink -f "$src")" ]; then
            mv "$dst" "${dst}.bak.$(date +%s)"
            echo "  backed up $dst"
        fi
    fi
    mkdir -p "$(dirname "$dst")"
    ln -sfn "$src" "$dst"
    echo "  linked $dst"
}

echo "==> [10/10] Linking dotfiles"
mkdir -p \
    "$HOME_DIR/.config/hyprland" \
    "$HOME_DIR/.config/waybar" \
    "$HOME_DIR/.config/kitty" \
    "$HOME_DIR/.config/rofi" \
    "$HOME_DIR/.config/mako" \
    "$HOME_DIR/.config/swaync" \
    "$HOME_DIR/.config/wlogout" \
    "$HOME_DIR/.config/starship" \
    "$HOME_DIR/.config/nvim" \
    "$HOME_DIR/.config/lazygit" \
    "$HOME_DIR/.config/delta" \
    "$HOME_DIR/.config/htop" \
    "$HOME_DIR/.config/btop" \
    "$HOME_DIR/.local/bin" \
    "$HOME_DIR/.local/share/wallpapers" \
    "$HOME_DIR/Documents/notes"

link "$DOTFILES/bash/.bashrc"            "$HOME_DIR/.bashrc"
link "$DOTFILES/bash/.bash_profile"      "$HOME_DIR/.bash_profile"
link "$DOTFILES/bash/.bash_logout"       "$HOME_DIR/.bash_logout"
link "$DOTFILES/git/.gitconfig"          "$HOME_DIR/.gitconfig"
link "$DOTFILES/starship/starship.toml"  "$HOME_DIR/.config/starship.toml"
link "$DOTFILES/kitty/kitty.conf"        "$HOME_DIR/.config/kitty/kitty.conf"
link "$DOTFILES/hyprland/hyprland.conf"  "$HOME_DIR/.config/hyprland/hyprland.conf"
link "$DOTFILES/hyprland/hyprlock.conf"  "$HOME_DIR/.config/hyprland/hyprlock.conf"
link "$DOTFILES/hyprland/hypridle.conf"  "$HOME_DIR/.config/hyprland/hypridle.conf"
link "$DOTFILES/waybar/config"           "$HOME_DIR/.config/waybar/config"
link "$DOTFILES/waybar/style.css"        "$HOME_DIR/.config/waybar/style.css"
link "$DOTFILES/rofi/config.rasi"        "$HOME_DIR/.config/rofi/config.rasi"
link "$DOTFILES/mako/config"             "$HOME_DIR/.config/mako/config"
link "$DOTFILES/swaync/config.json"      "$HOME_DIR/.config/swaync/config.json"
link "$DOTFILES/wlogout/layout"          "$HOME_DIR/.config/wlogout/layout"
link "$DOTFILES/wlogout/style.css"       "$HOME_DIR/.config/wlogout/style.css"
link "$DOTFILES/scripts/hacker-login.sh" "$HOME_DIR/.local/bin/hacker-login"
link "$DOTFILES/scripts/hack"            "$HOME_DIR/.local/bin/hack"
link "$DOTFILES/scripts/voice"           "$HOME_DIR/.local/bin/voice"
link "$DOTFILES/scripts/transcribe"      "$HOME_DIR/.local/bin/transcribe"
link "$DOTFILES/scripts/say"             "$HOME_DIR/.local/bin/say"
link "$DOTFILES/scripts/sshot"           "$HOME_DIR/.local/bin/sshot"
link "$DOTFILES/scripts/lg"              "$HOME_DIR/.local/bin/lg"
link "$DOTFILES/scripts/ld"              "$HOME_DIR/.local/bin/ld"
link "$DOTFILES/nvim/init.lua"           "$HOME_DIR/.config/nvim/init.lua"
link "$DOTFILES/lazygit/config.yml"      "$HOME_DIR/.config/lazygit/config.yml"
link "$DOTFILES/delta/delta.gitconfig"   "$HOME_DIR/.config/delta/delta.gitconfig"
link "$DOTFILES/btop/btop.conf"          "$HOME_DIR/.config/btop/btop.conf"
link "$DOTFILES/htop/htoprc"             "$HOME_DIR/.config/htop/htoprc"
link "$DOTFILES/tmux/tmux.conf"          "$HOME_DIR/.tmux.conf"

# Wallpaper — generate fresh if missing (procedural, no binary fabrication)
mkdir -p "$HOME_DIR/.local/share/wallpapers"
if [ ! -f "$DOTFILES/wallpapers/hacker.png" ] && command -v rsvg-convert >/dev/null 2>&1; then
    bash "$DOTFILES/scripts/gen-wallpaper.sh" "$DOTFILES/wallpapers/hacker.png" || true
fi
cp -f "$DOTFILES/wallpapers/hacker.png" "$HOME_DIR/.local/share/wallpapers/" 2>/dev/null || true

# Init notes vault
cat > "$HOME_DIR/Documents/notes/README.md" <<'EOF'
# My notes

This is the Obsidian vault root. Open it with `obsidian` and point it at this folder.

## Structure (suggested)
- daily/        — daily journal entries
- projects/     — your work
- learning/     — KLU coursework
- recon/        — security notes
- people/       — contacts and notes
EOF

# ============================================================
# FINISH
# ============================================================

cat <<'EOF'

==> DONE.

    Reboot, select Hyprland at SDDM login screen.

    Key shortcuts:
      SUPER + RETURN    terminal
      SUPER + D         app launcher
      SUPER + L         lock (hacker login screen)
      Print             screenshot region
      SHIFT + Print     screenshot full
      hack              run hacker boot animation in current shell
      voice <text>      text-to-speech (espeak)
      transcribe <file> speech-to-text (whisper)
      sshot             screenshot to clipboard
      lg                lazygit
      ld                lazydocker

    Tools installed:
      Languages: python, go, rust, nodejs, gcc, gdb, neovim
      Recon:     nmap, masscan, gobuster, ffuf, feroxbuster, nikto, wfuzz, sqlmap
      Exploit:   metasploit, crackmapexec, impacket, responder, bloodhound
      RevEng:    ghidra, radare2, rizin, cutter, gdb+pwndbg
      Forensics: volatility3, binwalk, foremost, sleuthkit
      Wireless:  aircrack-ng, wifite, kismet
      Privacy:   tor, proxychains-ng, macchanger
      Shell:     zsh, tmux, fzf, ripgrep, fd, bat, eza, btop, zoxide, mcfly
      Notes:     obsidian, task, timewarrior, calcurse, khal
      Sync:      syncthing, rclone, borg
      Crypto:    keepassxc, pass, gpg, veracrypt
      Media:     mpv, vlc, obs-studio, ffmpeg, yt-dlp, cava, cmus
      Voice:     espeak-ng, festival, piper-tts, whisper-cpp

EOF