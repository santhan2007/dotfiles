# ~/.bash_profile

# Source bashrc for interactive shells
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# Start graphical environment on tty1 if not already running
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec Hyprland
fi