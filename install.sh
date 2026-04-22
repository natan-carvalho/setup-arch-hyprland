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
  ttf-jetbrains-mono
  ttf-dejavu
  tt-liberation
  ttf-font-awesome
  noto-fonts
  noto-fonts-emoji
  noto-fonts-cjk
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
  bluez-utils
  networkmanager
  nm-connection-editor
  imagemagick
  papirus-icon-theme
  mako
  hypridle
  hyprlock
  ufw
  tar
  zip
  unzip
)

fc-cache -fv

sudo systemctl enable --now NetworkManager
# sudo pacman -Syu --needed "${packages[@]}"
yay -S --needed --noconfirm "${packages[@]}"

echo "Configurações do sistema e do usuário"
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"

mkdir -p "$CONFIG/hypr" "$CONFIG/waybar"
mkdir -p "$CONFIG/waybar/scripts"
mkdir -p "$CONFIG/hypr/scripts"
mkdir -p "$CONFIG/wofi"
mkdir -p "$CONFIG/kitty"
mkdir -p "$CONFIG/mako"

ln -sf "$REPO_ROOT/hypr/hyprpaper.conf" "$CONFIG/hypr/hyprpaper.conf"
ln -sf "$REPO_ROOT/hypr/hyprland.conf" "$CONFIG/hypr/hyprland.conf"
ln -sf "$REPO_ROOT/hypr/hypridle.conf" "$CONFIG/hypr/hypridle.conf"
ln -sf "$REPO_ROOT/hypr/hyprlock.conf" "$CONFIG/hypr/hyprlock.conf"
ln -sf "$REPO_ROOT/hypr/scripts/wallpaper.sh" "$CONFIG/hypr/scripts/wallpaper.sh"
ln -sf "$REPO_ROOT/waybar/config.jsonc" "$CONFIG/waybar/config.jsonc"
ln -sf "$REPO_ROOT/waybar/style.css" "$CONFIG/waybar/style.css"
ln -sf "$REPO_ROOT/waybar/scripts/wifi.sh" "$CONFIG/waybar/scripts/wifi.sh"
ln -sf "$REPO_ROOT/waybar/scripts/wifi-status.sh" "$CONFIG/waybar/scripts/wifi-status.sh"
ln -sf "$REPO_ROOT/.zshrc" "$HOME/.zshrc"
ln -sf "$REPO_ROOT/starship.toml" "$CONFIG/starship.toml"
ln -sf "$REPO_ROOT/kitty/kitty.conf" "$CONFIG/kitty/kitty.conf"
ln -sf "$REPO_ROOT/kitty/current-theme.conf" "$CONFIG/kitty/current-theme.conf"
ln -sf "$REPO_ROOT/wofi/style.css" "$CONFIG/wofi/style.css"
ln -sf "$REPO_ROOT/wofi/config" "$CONFIG/wofi/config"
ln -sf "$REPO_ROOT/mako/config" "$CONFIG/mako/config"

chmod +x "$CONFIG/waybar/scripts/wifi.sh"
chmod +x "$CONFIG/waybar/scripts/wifi-status.sh"
chmod +x "$CONFIG/hypr/scripts/wallpaper.sh"

# Se precisar rodar configurações extra do GTK/Qt:
gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
export QT_QPA_PLATFORMTHEME=qt6ct

chsh -s "$(command -v zsh)"

echo ""
read -p "Deseja configurar o sistema para jogos? (s/n): " gaming

if [[ "$gaming" == "s" || "$gaming" == "S" ]]; then
  echo "Instalando setup gamer..."
  chmod +x "$REPO_ROOT/game.sh"
  bash "$REPO_ROOT/game.sh"
else
  echo "Setup gamer ignorado."
fi
echo "Installation complete! Please restart your session to apply all changes and excute hyprland"
