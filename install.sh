#!/usr/bin/env bash
# santhan's Arch dotfiles bootstrap
# Usage:  cd ~/dotfiles && ./install.sh
# Effect: symlinks every config in this repo into $HOME (and /etc/makepkg.conf).
# Safe to re-run.

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
HOME_DIR="$HOME"

link() {
    local src="$1"
    local dst="$2"
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        # already exists — back it up once so the user's previous config isn't lost
        if [ ! -L "$dst" ] || [ "$(readlink -f "$dst")" != "$(readlink -f "$src")" ]; then
            mv "$dst" "${dst}.bak.$(date +%s)"
            echo "  backed up $dst"
        fi
    fi
    mkdir -p "$(dirname "$dst")"
    ln -sfn "$src" "$dst"
    echo "  linked $dst -> $src"
}

echo "==> Linking bash configs"
link "$DOTFILES/bash/.bashrc"      "$HOME_DIR/.bashrc"
link "$DOTFILES/bash/.bash_profile" "$HOME_DIR/.bash_profile"
link "$DOTFILES/bash/.bash_logout"  "$HOME_DIR/.bash_logout"

echo "==> Linking git config"
link "$DOTFILES/git/.gitconfig"    "$HOME_DIR/.gitconfig"

echo "==> Linking paru config (if present)"
if [ -d "$DOTFILES/paru" ]; then
    mkdir -p "$HOME_DIR/.config/paru"
    for f in "$DOTFILES/paru"/*; do
        [ -f "$f" ] && link "$f" "$HOME_DIR/.config/paru/$(basename "$f")"
    done
fi

echo "==> Linking ssh config (if present)"
if [ -f "$DOTFILES/ssh/config" ]; then
    mkdir -p "$HOME_DIR/.ssh"
    chmod 700 "$HOME_DIR/.ssh"
    link "$DOTFILES/ssh/config" "$HOME_DIR/.ssh/config"
    chmod 600 "$HOME_DIR/.ssh/config"
fi

echo "==> Installing makepkg.conf snippet (requires sudo)"
if [ -f "$DOTFILES/makepkg/makepkg.conf.snippet" ]; then
    if grep -q '^BUILDDIR=/tmp/makepkg' /etc/makepkg.conf 2>/dev/null; then
        echo "  BUILDDIR already set in /etc/makepkg.conf, skipping"
    else
        echo '1980' | sudo -S sed -i 's|^#BUILDDIR=/tmp/makepkg|BUILDDIR=/tmp/makepkg|' /etc/makepkg.conf
        echo "  enabled BUILDDIR=/tmp/makepkg in /etc/makepkg.conf"
    fi
fi

echo
echo "==> Done. Open a new shell or run: source ~/.bashrc"