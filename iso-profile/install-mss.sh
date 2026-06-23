#!/usr/bin/env bash
# install-mss.sh — runs on first boot of the MSS Hacker Desktop live ISO
# Walks the user through Arch install + auto-deploys dotfiles

set -euo pipefail

CYAN='\033[1;36m'
GREEN='\033[1;32m'
PURPLE='\033[1;35m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
RESET='\033[0m'

clear

cat <<'BANNER'
    ╔══════════════════════════════════════════════════════════╗
    ║                                                          ║
    ║              MSS HACKER DESKTOP — LIVE ISO                ║
    ║                                                          ║
    ║           One-shot Arch install + full rice               ║
    ║                                                          ║
    ╚══════════════════════════════════════════════════════════╝
BANNER

echo
echo -e "${CYAN}This script will:${RESET}"
echo "  1. Partition the disk (auto-detected if 1 disk present)"
echo "  2. Format partitions (EFI + ext4)"
echo "  3. pacstrap base + linux"
echo "  4. arch-chroot and configure"
echo "  5. Install all 240+ packages"
echo "  6. Clone dotfiles from GitHub"
echo "  7. Run install.sh — full rice deployment"
echo "  8. Create user, set password, configure bootloader"
echo
echo -e "${YELLOW}Target disk:${RESET}"
lsblk -d -o NAME,SIZE,MODEL | grep -v "NAME"
echo
echo -e "${YELLOW}Usage:${RESET}"
echo "  install-mss.sh           — interactive install on /dev/sda"
echo "  install-mss.sh /dev/nvme0n1 — interactive install on /dev/nvme0n1"
echo "  install-mss.sh --auto /dev/sda — non-interactive (uses defaults)"
echo
echo -e "${RED}WARNING: This will ERASE all data on the target disk.${RESET}"
echo -e "${RED}         Make sure you've backed up everything important.${RESET}"
echo

# Read target disk
DISK="${1:-}"
AUTO=false
if [ "$1" = "--auto" ]; then
    AUTO=true
    DISK="${2:-}"
fi

if [ -z "$DISK" ]; then
    # Auto-detect: first non-removable disk
    DISK=$(lsblk -d -n -o NAME,TRAN | grep -v "usb" | grep -v "NAME" | head -1 | awk '{print "/dev/"$1}')
    if [ -z "$DISK" ]; then
        echo -e "${RED}ERROR: no disk auto-detected. Pass one explicitly:${RESET}"
        echo "  install-mss.sh /dev/sda"
        exit 1
    fi
    echo -e "${CYAN}Auto-detected disk: ${GREEN}${DISK}${RESET}"
fi

if [ "$AUTO" = false ]; then
    read -p "Install to ${DISK}? Type 'yes' to continue: " CONFIRM
    if [ "$CONFIRM" != "yes" ]; then
        echo "aborted."
        exit 1
    fi
fi

echo
echo -e "${GREEN}==> Step 1/8: Partitioning ${DISK}${RESET}"
# Wipe and create: 1GB EFI + rest Linux
sgdisk --zap-all "$DISK"
sgdisk -n 1:0:+1G -t 1:ef00 -c 1:"EFI System" "$DISK"
sgdisk -n 2:0:0    -t 2:8300 -c 2:"Linux root" "$DISK"

# Detect partition naming convention
if [[ "$DISK" == *"nvme"* ]] || [[ "$DISK" == *"mmcblk"* ]]; then
    EFI_PART="${DISK}p1"
    ROOT_PART="${DISK}p2"
else
    EFI_PART="${DISK}1"
    ROOT_PART="${DISK}2"
fi

sleep 2
partprobe "$DISK"

echo -e "${GREEN}==> Step 2/8: Formatting partitions${RESET}"
mkfs.fat -F32 "$EFI_PART"
mkfs.ext4 -F "$ROOT_PART"

echo -e "${GREEN}==> Step 3/8: Mounting + pacstrap${RESET}"
mount "$ROOT_PART" /mnt
mkdir -p /mnt/boot/efi
mount "$EFI_PART" /mnt/boot/efi

pacstrap -K /mnt base linux linux-firmware linux-headers base-devel \
    git openssh vim nano wget curl reflector

echo -e "${GREEN}==> Step 4/8: fstab + arch-chroot prep${RESET}"
genfstab -U /mnt >> /mnt/etc/fstab

# Set hostname
echo "mss-arch" > /mnt/etc/hostname

# Time
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
arch-chroot /mnt hwclock --systohc

# Locale
arch-chroot /mnt sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
arch-chroot /mnt locale-gen
arch-chroot /mnt echo 'LANG=en_US.UTF-8' > /etc/locale.conf

# Network
arch-chroot /mnt systemctl enable NetworkManager

# Bootloader (systemd-boot for UEFI)
arch-chroot /mnt bootctl install
arch-chroot /mnt mkdir -p /boot/loader/entries
cat > /mnt/boot/loader/loader.conf <<'LOADER'
default arch.conf
timeout 3
editor no
LOADER
cat > /mnt/boot/loader/entries/arch.conf <<'ENTRY'
title   MSS Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
ENTRY

echo -e "${GREEN}==> Step 5/8: Create user + password${RESET}"
if [ "$AUTO" = true ]; then
    arch-chroot /mnt useradd -m -G wheel,audio,video,network -s /bin/bash santhan
    echo "santhan:1980" | arch-chroot /mnt chpasswd
else
    arch-chroot /mnt useradd -m -G wheel,audio,video,network -s /bin/bash santhan
    echo "set password for user 'santhan':"
    arch-chroot /mnt passwd santhan
fi

# sudo without password for wheel (during install only — user can change later)
arch-chroot /mnt sed -i 's|^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL|%wheel ALL=(ALL:ALL) NOPASSWD: ALL|' /etc/sudoers

echo -e "${GREEN}==> Step 6/8: Clone dotfiles repo${RESET}"
arch-chroot /mnt sudo -u santhan bash -c "
    cd ~
    git clone https://github.com/santhan2007/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ./install.sh
"

echo -e "${GREEN}==> Step 7/8: Tidy sudo + reboot prep${RESET}"
# Restore sudo password requirement
arch-chroot /mnt sed -i 's|^%wheel ALL=(ALL:ALL) NOPASSWD: ALL|# %wheel ALL=(ALL:ALL) NOPASSWD: ALL|' /etc/sudoers

echo -e "${GREEN}==> Step 8/8: Done${RESET}"
echo
cat <<'DONE'
    ╔══════════════════════════════════════════════════════════╗
    ║                                                          ║
    ║                  INSTALLATION COMPLETE                    ║
    ║                                                          ║
    ║   Reboot, select Hyprland at SDDM, login as santhan     ║
    ║                                                          ║
    ╚══════════════════════════════════════════════════════════╝
DONE

echo
echo "Press Enter to reboot, or Ctrl-C to stay in live ISO."
read _
reboot