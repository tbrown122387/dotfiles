# dotfiles

Personal configs for vim, tmux, and lazygit, plus a script to set them up
on a new machine.

## Setup on a new machine

```sh
git clone git@github.com:tbrown122387/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

`install.sh` is idempotent:
- Installs `vim`, `tmux`, and `lazygit` if they're missing (via `brew` on
  macOS, `apt-get` on Debian/Ubuntu; `lazygit` falls back to a GitHub
  release download on Linux since it's not in apt).
- Symlinks this repo's configs into place:
  - `vim/vimrc` -> `~/.vimrc`
  - `tmux/tmux.conf` -> `~/.tmux.conf`
  - `lazygit/config.yml` -> `~/.config/lazygit/config.yml`
  - `claude/settings.json` -> `~/.claude/settings.json`
- Backs up any pre-existing real (non-symlink) config files to
  `~/.dotfiles-backup/<timestamp>/` before overwriting them.

## Layout

```
vim/vimrc           sensible vim defaults, no plugin manager required
tmux/tmux.conf      mouse support, vi-style pane nav/copy mode, status bar
lazygit/config.yml  mouse support, autofetch/autorefresh
claude/settings.json  Claude Code telemetry/data-sharing opt-outs, UI/model prefs
install.sh          installs the tools above and symlinks the configs
```

## Updating

Edit the files in this repo, commit, and re-run `./install.sh` on each
machine (or just `git pull` since everything is symlinked).

## tmux quick reference

Prefix is the tmux default, `C-b`.

| Keys            | Action                     |
|-----------------|-----------------------------|
| `prefix r`      | reload tmux config         |
| `prefix \|`      | split pane vertically      |
| `prefix -`      | split pane horizontally    |
| `prefix h/j/k/l`| move between panes          |
| `prefix H/J/K/L`| resize pane                 |
