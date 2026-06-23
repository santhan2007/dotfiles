[archiso]
# Profile name shown on boot
name = MSS Hacker Desktop

# Which architecture to build for
arch = x86_64

# ISO file name
image_name = mss-hacker-desktop

# ISO publisher info
iso_publisher = "santhan2007"
iso_application = "MSS Hacker Desktop Live ISO"

# Compression for the ISO file
iso_label = MSS_HACKER
compression = zstd

# Build modes available: 'iso', 'net' (PXE)
buildmodes = ('iso')

# Filesystem for the ISO: 'iso9660' for CD/DVD/USB, 'squashfs' for read-only
# Standard: 'iso9660'
fsarch = iso9660

# List of packages from the repositories
packages = (
    "base",
    "linux",
    "linux-firmware",
    "linux-headers",
    "base-devel",
    "git",
    "openssh",
    "vim",
    "nano",
    "wget",
    "curl",
    "reflector",
)

# Additional packages installed at runtime via the bootstrap script
# (anything in pkglist.txt gets pulled in by /root/install.sh on first boot)

# Files to copy into the live ISO
# (pointed at the dotfiles repo so it's all self-contained)
# The bootstrap script copies everything from /root/dotfiles to the target
# after installation.

# Hooks: scripts that run during build to customize the ISO
# We add a custom script that drops the install.sh into the live root

[run_archiso]

# Bootstrap script — runs once on first boot of the live ISO
# Prints instructions for the user to run /root/install-mss.sh
# which does the full Arch install + dotfiles deployment