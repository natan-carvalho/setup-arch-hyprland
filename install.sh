#!/usr/bin/env bash
set -euo pipefail

# kitten themes para setar o tema do kitty

sudo pacman -Syu --noconfirm

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"

if command -v git >/dev/null 2>&1; then
  sudo pacman -S --needed git
fi

git clone https://aur.archlinux.org/yay.git ~
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
  base-devel
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

echo "Instalação dos pacotes concluída!"
echo "Escolha sua fonte do terminal"
kitten choose-font
starship preset nerd-font-symbols -o "$CONFIG/starship.toml"

echo "Configurações do sistema e do usuário"
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"

mkdir -p "$CONFIG/hypr" "$CONFIG/waybar"

cp "$REPO_ROOT/hypr/hyprpaper.conf" "$CONFIG/hypr/hyprpaper.conf"

ln -sf "$REPO_ROOT/hypr/hyprland.conf" "$CONFIG/hypr/hyprland.conf"
ln -sf "$REPO_ROOT/waybar/config.jsonc" "$CONFIG/waybar/config.json"
ln -sf "$REPO_ROOT/waybar/style.css" "$CONFIG/waybar/style.css"
ln -sf "$REPO_ROOT/.zshrc" "$HOME/.zshrc"

# Se precisar rodar configurações extra do GTK/Qt:
gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
export QT_QPA_PLATFORMTHEME=qt6ct

chsh -s "$(command -v zsh)"

echo "Installation complete! Please restart your session to apply all changes and excute hyprland"