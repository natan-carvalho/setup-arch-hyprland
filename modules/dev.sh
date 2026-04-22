#!/usr/bin/env bash
set -euo pipefail

# kitten themes para setar o tema do kitty

sudo pacman -Syu --noconfirm

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"

# Package
packages=(
  zsh
  starship
  fzf
  zsh-autosuggestions
  zsh-autocomplete
  zsh-syntax-highlighting
  curl
  wget
  unzip
  zip
  neovim
  gnome-keyring
  polkit-gnome
  grim
  slurp
  docker
  docker-compose
  visual-studio-code-bin
)

# sudo pacman -Syu --needed "${packages[@]}"
yay -S --needed --noconfirm "${packages[@]}"

echo "Configurações do sistema e do usuário"
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"

ln -sf "$REPO_ROOT/.zshrc" "$HOME/.zshrc"
ln -sf "$REPO_ROOT/starship.toml" "$CONFIG/starship.toml"

chsh -s "$(command -v zsh)"
