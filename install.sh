#!/usr/bin/env bash
set -euo pipefail

# kitten themes para setar o tema do kitty

sudo pacman -Syu --noconfirm

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"

if command -v git >/dev/null 2>&1; then
  sudo pacman -S --needed git
fi

sudo pacman -S --needed base-devel

git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay
makepkg -si --noconfirm

# Package
packages=(
  hyprland
  hyprshot
  hyprpaper
  kitty
  fastfetch
  nemo
  wofi
  eog
  vlc
  zsh
  starship
  fzf
  zsh-autosuggestions
  zsh-autocomplete
  zsh-syntax-highlighting
  waybar
  waybar-hyprland-git
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
  ttf-jetbrains-mono-nerd
  visual-studio-code-bin
  adw-gtk-theme
  xdg-desktop-portal-hyprland
  xdg-desktop-portal-gtk
  xdg-desktop-portal
  qt6ct
  qt5ct
  kvantum
  breeze-icons
  pavucontrol
)

# sudo pacman -Syu --needed "${packages[@]}"
yay -S --needed --noconfirm "${packages[@]}"

echo "Configurações do sistema e do usuário"
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"

mkdir -p "$CONFIG/hypr" "$CONFIG/waybar"

ln -sf "/home/natan/setup-arch-hyprland/hypr/hyprpaper.conf" "$HOME/.config/hypr/hyprpaper.conf"
ln -sf "/home/natan/setup-arch-hypr/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
ln -sf "./waybar/config.jsonc" "$HOME/.config/waybar/config.jsonc"
ln -sf "./waybar/style.css" "$HOME/.config/waybar/style.css"
ln -sf "./.zshrc" "$HOME/.zshrc"
ln -sf "./starship.toml" "$HOME/.config/starship.toml"
ln -sf "./kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
ln -sf "./kitty/current-theme.conf" "$HOME/.config/kitty/current-theme.conf"

# Se precisar rodar configurações extra do GTK/Qt:
gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
export QT_QPA_PLATFORMTHEME=qt6ct

chsh -s "$(command -v zsh)"

echo "Installation complete! Please restart your session to apply all changes and excute hyprland"
