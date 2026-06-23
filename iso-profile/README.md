# MSS Hacker Desktop — Custom Arch ISO

Build a bootable Arch ISO that, when flashed to USB and booted, can install a complete MSS hacker desktop in one command.

## What's in this ISO

  • Base Arch Linux live environment
  • `install-mss.sh` script on the desktop — runs the full installer
  • SSH server enabled by default (remote install possible)
  • All necessary partitioning / formatting / bootloader tools

## How to build the ISO

On an Arch Linux machine (or live Arch USB):

```bash
# Install archiso
sudo pacman -S archiso

# Copy the releng profile as a starting point
cp -r /usr/share/archiso/configs/releng /tmp/mss-build

# Copy our profile over it
cp -r iso-profile/* /tmp/mss-build/

# Build the ISO
cd /tmp/mss-build
sudo mkarchiso -v -o ~/iso-output .
```

Output: `~/iso-output/mss-hacker-desktop-*.iso` (~1.5GB)

## How to use the ISO

1. Flash to USB: `sudo dd if=mss-hacker-desktop-*.iso of=/dev/sdX bs=4M status=progress oflag=sync`
2. Boot target machine from USB
3. Login as `root` (no password in live ISO)
4. Run `install-mss.sh` — interactive prompts
   - Or `install-mss.sh --auto /dev/sda` for unattended install

The script will:
  • Partition the target disk
  • Format + mount + pacstrap
  • arch-chroot and configure
  • Clone your dotfiles repo
  • Run `./install.sh` (full package install + rice)
  • Create user + set password
  • Install bootloader
  • Reboot into your new system

## Required packages on the build machine

  • `archiso` — the ISO builder
  • Anything else needed is included in the ISO

## Limitations

  • Build machine must be x86_64 Arch
  • Output ISO is ~1.5GB (compression with zstd)
  • The dotfiles repo (github.com/santhan2007/dotfiles) must be accessible during install — if offline, pre-clone it to /root/dotfiles in the live ISO before running install-mss.sh

## Customization

To modify what's in the ISO:
  • Edit `profiledef.sh` to change packages, publisher info
  • Edit `install-mss.sh` to change the install flow (partition layout, user creation, etc.)
  • Add files to `airootfs/` to have them present on the live ISO at boot