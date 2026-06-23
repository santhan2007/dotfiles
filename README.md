# santhan's Arch Linux dotfiles

Bootstrap-ready Arch Linux configuration. Clone on a fresh machine, run `install.sh`, done.

## What's in here

| Path            | What it is                              |
|-----------------|-----------------------------------------|
| `bash/`         | `.bashrc`, `.bash_profile`, `.bash_logout` |
| `git/`          | `.gitconfig`                            |
| `paru/`         | AUR package build config (used to build paru from source) |
| `makepkg/`      | `/etc/makepkg.conf` snippet — `BUILDDIR=/tmp/makepkg` |
| `ssh/`          | `.ssh/config` (if present)              |
| `install.sh`    | One-shot bootstrap script               |

## Usage

On a fresh Arch install:

```bash
git clone git@github.com:santhan2007/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` symlinks everything in this repo into `$HOME` (and `/etc/makepkg.conf` for the makepkg snippet, with sudo).

## Why symlinks instead of copies?

Editing any config in `~/dotfiles/...` updates the live version. One `git add -A && git commit && git push` from `~/dotfiles` keeps GitHub in sync. On a new laptop, re-cloning instantly restores the latest state.

## What's NOT in this repo

  • SSH private keys (`~/.ssh/id_ed25519`) — generate fresh per machine
  • `.bash_history`, `.cache/`, package caches, browser profiles — machine-local noise
  • Any credential/token files