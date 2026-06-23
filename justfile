# santhan's justfile — selective install steps
# Install: cargo install just  OR  pacman -S just
# Usage:   just            (lists recipes)
#          just install   (full install)
#          just pkgs      (just packages, no configs)
#          just rice      (just configs + wallpapers)
#          just update    (update system)

# Default recipe — list everything
default:
    @just --list

# Full install: packages + configs
install:
    @echo "running full install..."
    @./install.sh

# Install just packages, skip rice
pkgs:
    @echo "installing packages only..."
    @bash -c 'grep -E "^[a-z]" pkglist.txt | xargs sudo pacman -S --needed --noconfirm'

# Install just configs (assumes packages already there)
rice:
    @echo "linking configs..."
    @mkdir -p ~/.config/hyprland ~/.config/waybar ~/.config/kitty \
             ~/.config/rofi ~/.config/mako ~/.config/swaync \
             ~/.config/wlogout ~/.config/starship ~/.config/nvim \
             ~/.config/lazygit ~/.config/delta ~/.config/btop \
             ~/.config/htop ~/.local/bin ~/.local/share/wallpapers
    @ln -sfn $(pwd)/bash/.bashrc ~/.bashrc
    @ln -sfn $(pwd)/bash/.bash_profile ~/.bash_profile
    @ln -sfn $(pwd)/bash/.bash_logout ~/.bash_logout
    @ln -sfn $(pwd)/git/.gitconfig ~/.gitconfig
    @ln -sfn $(pwd)/starship/starship.toml ~/.config/starship/starship.toml
    @ln -sfn $(pwd)/kitty/kitty.conf ~/.config/kitty/kitty.conf
    @ln -sfn $(pwd)/hyprland/hyprland.conf ~/.config/hyprland/hyprland.conf
    @ln -sfn $(pwd)/hyprland/hyprlock.conf ~/.config/hyprland/hyprlock.conf
    @ln -sfn $(pwd)/hyprland/hypridle.conf ~/.config/hyprland/hypridle.conf
    @ln -sfn $(pwd)/waybar/config ~/.config/waybar/config
    @ln -sfn $(pwd)/waybar/style.css ~/.config/waybar/style.css
    @ln -sfn $(pwd)/rofi/config.rasi ~/.config/rofi/config.rasi
    @ln -sfn $(pwd)/mako/config ~/.config/mako/config
    @ln -sfn $(pwd)/swaync/config.json ~/.config/swaync/config.json
    @ln -sfn $(pwd)/wlogout/layout ~/.config/wlogout/layout
    @ln -sfn $(pwd)/wlogout/style.css ~/.config/wlogout/style.css
    @ln -sfn $(pwd)/nvim/init.lua ~/.config/nvim/init.lua
    @ln -sfn $(pwd)/lazygit/config.yml ~/.config/lazygit/config.yml
    @ln -sfn $(pwd)/btop/btop.conf ~/.config/btop/btop.conf
    @ln -sfn $(pwd)/htop/htoprc ~/.config/htop/htoprc
    @ln -sfn $(pwd)/tmux/tmux.conf ~/.tmux.conf
    @chmod +x scripts/*
    @cp scripts/hacker-login.sh scripts/hack scripts/voice scripts/say \
          scripts/transcribe scripts/sshot scripts/lg scripts/ld \
          scripts/gen-wallpaper.sh ~/.local/bin/
    @echo "configs linked"

# Generate the wallpaper
wallpaper:
    @./scripts/gen-wallpaper.sh wallpapers/hacker.png
    @cp wallpapers/hacker.png ~/.local/share/wallpapers/

# Update system
update:
    @sudo pacman -Syu
    @paru -Sua

# Clean pacman cache (keep last 2 versions)
clean:
    @sudo paccache -r -k 2

# Show disk usage
disk:
    @df -h / && echo "---" && du -sh ~/.cache 2>/dev/null

# Test the install.sh syntax
test:
    @bash -n install.sh && echo "install.sh syntax OK"
    @bash -n scripts/*.sh && echo "all scripts syntax OK"

# Backup current configs
backup:
    @mkdir -p ~/.dotfiles-backup/$(date +%Y%m%d)
    @cp -r ~/.bashrc ~/.bash_profile ~/.bash_logout ~/.gitconfig \
          ~/.config/hyprland ~/.config/waybar ~/.config/kitty \
          ~/.config/rofi ~/.config/starship ~/.config/nvim \
          ~/.dotfiles-backup/$(date +%Y%m%d)/ 2>/dev/null || true
    @echo "backup at ~/.dotfiles-backup/$(date +%Y%m%d)/"