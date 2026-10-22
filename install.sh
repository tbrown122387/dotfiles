#!/usr/bin/env bash
#
# Symlinks this repo's configs into place and installs vim/tmux/lazygit
# if they're missing. Safe to re-run on any machine.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d%H%M%S)"

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mkdir -p "$BACKUP_DIR"
    echo "Backing up existing $dest -> $BACKUP_DIR/"
    mv "$dest" "$BACKUP_DIR/$(basename "$dest")"
  fi
  ln -sfn "$src" "$dest"
  echo "Linked $dest -> $src"
}

install_packages() {
  local missing=()
  command -v vim     >/dev/null 2>&1 || missing+=(vim)
  command -v tmux    >/dev/null 2>&1 || missing+=(tmux)
  command -v lazygit >/dev/null 2>&1 || missing+=(lazygit)

  if [ ${#missing[@]} -eq 0 ]; then
    return
  fi

  echo "Missing tools: ${missing[*]}"

  if command -v brew >/dev/null 2>&1; then
    brew install "${missing[@]}"
  elif command -v apt-get >/dev/null 2>&1; then
    local apt_pkgs=()
    for pkg in "${missing[@]}"; do
      [ "$pkg" = "lazygit" ] && continue  # not in apt; installed separately below
      apt_pkgs+=("$pkg")
    done
    if [ ${#apt_pkgs[@]} -gt 0 ]; then
      sudo apt-get update && sudo apt-get install -y "${apt_pkgs[@]}"
    fi
    if printf '%s\n' "${missing[@]}" | grep -qx lazygit; then
      install_lazygit_from_github
    fi
  else
    echo "No supported package manager found (brew/apt-get)."
    echo "Install manually: ${missing[*]}"
  fi
}

install_lazygit_from_github() {
  echo "Installing lazygit from GitHub releases..."
  local version arch url tmp
  version="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name": *"v\K[^"]+')"
  case "$(uname -m)" in
    x86_64)  arch="x86_64" ;;
    aarch64|arm64) arch="arm64" ;;
    *) echo "Unsupported arch for automatic lazygit install; install manually."; return ;;
  esac
  url="https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${version}_Linux_${arch}.tar.gz"
  tmp="$(mktemp -d)"
  curl -fsSL "$url" -o "$tmp/lazygit.tar.gz"
  tar -xzf "$tmp/lazygit.tar.gz" -C "$tmp" lazygit
  sudo install "$tmp/lazygit" /usr/local/bin/lazygit
  rm -rf "$tmp"
}

main() {
  install_packages

  link "$DOTFILES_DIR/vim/vimrc"          "$HOME/.vimrc"
  link "$DOTFILES_DIR/tmux/tmux.conf"     "$HOME/.tmux.conf"
  link "$DOTFILES_DIR/tmux/start.sh"      "$HOME/.local/bin/tmux-start"
  link "$DOTFILES_DIR/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"
  link "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"

  echo "Done."
}

main "$@"
