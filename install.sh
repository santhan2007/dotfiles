#!/usr/bin/env bash
# santhan's full Arch setup — packages + rice + tools
# Run on a fresh Arch install after `pacman -S git` and cloning this repo.
# Idempotent — safe to re-run.

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
HOME_DIR="$HOME"

# Ask for sudo once, cache for the rest of the script
sudo -v
while true; do sudo -n true; sleep 50; kill -0 "$$" 2>/dev/null || exit; done 2>/dev/null &
SUDOKEEPER=$!
trap "kill $SUDOKEEPER 2>/dev/null || true" EXIT

# ============================================================
# 1. PACKAGES
# ============================================================

echo "==> [1/5] Installing base + dev tools"
sudo pacman -S --needed --noconfirm \
    base-devel git vim nano \
    gcc gdb make cmake ninja pkgconf \
    python python-pip python-virtualenv \
    go nodejs npm \
    docker docker-compose \
    openssh rsync wget curl jq unzip p7zip zip \
    tmux zsh zsh-completions \
    ripgrep fd fzf bat eza btop htop neofetch starship \
    neovim

echo "==> [2/5] Installing Wayland + rice stack"
sudo pacman -S --needed --noconfirm \
    hyprland hyprlock hypridle hyprland-qtutils \
    waybar mako swaync wlogout \
    rofi-wayland swww grim slurp wl-clipboard cliphist \
    kitty alacritty foot \
    qt5-wayland qt6-wayland \
    polkit-gnome \
    xdg-desktop-portal-hyprland xdg-utils \
    pipewire pipewire-pulse wireplumber pavucontrol \
    brightnessctl playerctl \
    thunar thunar-archive-plugin thunar-media-tags-plugin \
    network-manager-applet blueman

echo "==> [3/5] Installing fonts"
sudo pacman -S --needed --noconfirm \
    ttf-jetbrains-mono-nerd ttf-firacode-nerd ttf-hack-nerd \
    noto-fonts noto-fonts-emoji noto-fonts-cjk \
    ttf-font-awesome

echo "==> [4/5] Installing cybersecurity toolkit"
sudo pacman -S --needed --noconfirm \
    nmap masscan wireshark-qt tcpdump netcat-openbsd socat \
    aircrack-ng kismet wifite bettercap ettercap \
    john hashcat hydra seclists wordlists \
    gobuster ffuf feroxbuster \
    sqlmap nikto wfuzz zaproxy \
    metasploit \
    impacket responder crackmapexec bloodhound \
    ghidra radare2 rizin cutter \
    volatility3 binwalk foremost sleuthkit \
    gdb strace ltrace \
    tor torsocks proxychains-ng macchanger \
    firefox chromium

echo "==> Enabling services"
sudo systemctl enable --now NetworkManager docker || true
sudo usermod -aG docker "$USER" 2>/dev/null || true

# ============================================================
# 2. AUR packages via paru
# ============================================================

if ! command -v paru >/dev/null 2>&1; then
    echo "==> Installing paru from AUR"
    cd /tmp
    rm -rf paru
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    cd "$DOTFILES"
fi

echo "==> Installing AUR extras"
paru -S --needed --noconfirm burpsuite pro pwndbg steghide || true

# ============================================================
# 3. SYSTEM TWEAKS
# ============================================================

echo "==> Applying system tweaks"
if grep -q '^#BUILDDIR=/tmp/makepkg' /etc/makepkg.conf 2>/dev/null; then
    sudo sed -i 's|^#BUILDDIR=/tmp/makepkg|BUILDDIR=/tmp/makepkg|' /etc/makepkg.conf
fi

# ============================================================
# 4. SYMLINK DOTFILES
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

echo "==> [5/5] Linking dotfiles"
mkdir -p \
    "$HOME_DIR/.config/hyprland" \
    "$HOME_DIR/.config/waybar" \
    "$HOME_DIR/.config/kitty" \
    "$HOME_DIR/.config/rofi" \
    "$HOME_DIR/.config/mako" \
    "$HOME_DIR/.config/swaync" \
    "$HOME_DIR/.config/wlogout" \
    "$HOME_DIR/.config/starship"

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

# Wallpaper (binary-safe copy, not symlink — git doesn't love binary symlinks)
mkdir -p "$HOME_DIR/.local/share/wallpapers"
cp -f "$DOTFILES/wallpapers/hacker.png" "$HOME_DIR/.local/share/wallpapers/" 2>/dev/null || true

# ============================================================
# 5. FINISH
# ============================================================

echo
echo "==> Done."
echo "    Reboot, select Hyprland at login (or run: Hyprland)."
echo "    Hacker login screen via: hyprlock (auto on suspend/lock)"
echo "    Tools list: see pkglist.txt in the repo."