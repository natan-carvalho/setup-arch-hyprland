
sudo pacman -Syu --noconfirm

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG=$HOME/.config

if ! command -v git &> /dev/null; then
  echo "Git could not be found. Please install Git and try again."
  sudo pacman -S --noconfirm git
fi

sudo pacman -S --noconfirm base-devel

if ! command -v yay &> /dev/null; then
  echo "Yay could not be installed. Please check the installation process."
  # instalar o yay
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si
  cd ~
fi

PACKAGES=(
  plymouth
  git
  google-chrome

  # Video
  amd-ucode
  intel-ucode
  intel-media-driver
  #libva-mesa-driver
  mesa
  #nvidia
  #nvidia-utils

  # Audio
  pipewire
  pipewire-alsa
  pipewire-pulse
  pipewire-jack
  wireplumber
  pavucontrol

  # Bluetooth
  bluez
  bluez-utils
  blueman

  # Reproducao de videos e audio
  ffmpeg
  gstreamer
  gst-libav
  gst-plugins-base
  gst-plugins-good
  gst-plugins-bad
  gst-plugins-ugly
  libdvdcss
  vlc

  # Terminal
  kitty

  # interface
  hyprland

  # tela de login
  sddm

  # dev
  visual-studio-code-bin
)

yay -S --noconfirm "${PACKAGES[@]}"

sudo systemctl enable bluetooth.service NetworkManager iwd sddm

# Linkagem
rm -rf $CONFIG/hypr

ln -sf $REPO_ROOT/.config/* $CONFIG/

# adicionar o plymouth no ROOKS do arquivo /etc/mkinitcpio.conf
# rodar sudo mkinitcpio -P
