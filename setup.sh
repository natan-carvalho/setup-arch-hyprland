echo "╔═════════════════════════════════════════════════╗"
echo "║                Iniciando o Setup                ║"
echo "╚═════════════════════════════════════════════════╝"
sudo pacman -Syu --noconfirm

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"

if ! command -v git &>/dev/null; then
  echo "Git could not be found. Please install Git and try again."
  sudo pacman -S --noconfirm git
fi

sudo pacman -S --noconfirm base-devel

if ! command -v yay &>/dev/null; then
  echo "Yay could not be installed. Please check the installation process."
  # instalar o yay
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd ~
fi

PACKAGES=(
  # ╔════════════════╗
  # ║      BASE      ║
  # ╚════════════════╝
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
  hyprpicker # pegar cores do tema
  waybar
  awww
  # tela de login
  sddm
  qt6-svg
  qt6-virtualkeyboard
  qt6-multimedia-ffmpeg
  hyprlock
  hypridle
  wlogout
  # Fonts
  ttf-jetbrains-mono
  ttf-jetbrains-mono-nerd
  ttf-dejavu
  ttf-liberation
  ttf-font-awesome
  nerd-fonts-meta
  noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  ttf-firacode-nerd
  otf-font-awesome
  # file manager
  dolphin
  dolphin-plugins
  # descompactador
  file-roller
  rofi
  polkit-kde-agent
  file-roller
  gvfs-smb
  gvfs
  gvfs-mtp
  gnome-keyring
  # integração
  xdg-desktop-portal
  xdg-desktop-portal-hyprland
  xdg-desktop-portal-gtk
  xdg-user-dirs-gtk
  xdg-user-dirs
  xdg-utils
  nwg-look
  qt5ct-kde
  qt6ct-kde
  qt5-wayland
  qt6-wayland
  kvantum
  kvantum-qt5
  papirus-icon-theme
  papirus-folders

  # ╔════════════════╗
  # ║   DEVELOPMENT  ║
  # ╚════════════════╝
  visual-studio-code-bin
  zsh
  starship
  fzf
  asdf-vm
  zsh-autosuggestions
  zsh-autocomplete
  zsh-syntax-highlighting
)

# Função para verificar se o pacote é do pacman
is_pacman_package() {
  pacman -Ss "^$1$" >/dev/null 2>&1
}

# Separar pacotes
PACMAN_PACKAGES=()
AUR_PACKAGES=()

for pkg in "${PACKAGES[@]}"; do
  if is_pacman_package "$pkg"; then
    PACMAN_PACKAGES+=("$pkg")
  else
    AUR_PACKAGES+=("$pkg")
  fi
done

# Instalar pacotes do pacman
if [ ${#PACMAN_PACKAGES[@]} -gt 0 ]; then
  sudo pacman -S --noconfirm "${PACMAN_PACKAGES[@]}"
fi

# Instalar pacotes do AUR
if [ ${#AUR_PACKAGES[@]} -gt 0 ]; then
  yay -S --noconfirm "${AUR_PACKAGES[@]}"
fi

sudo systemctl enable bluetooth.service NetworkManager iwd sddm


# SDDM Theme
sudo git clone -b master --depth 1 https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme
sudo cp -r /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/

for dir in $REPO_ROOT/etc/*; do
  name=$(basename $dir)
  echo "Criando o diretorio de teste $dir"
  sudo rm -rf /etc/$name
  sudo ln -sfn $dir /etc/$name
done

sudo ln -sfn $REPO_ROOT/usr/share/sddm/theme/metatadata.desktop /usr/share/sddm/themes/sddm-astronaut-theme/metadata.desktop
# Linkagem
#rm -rf $CONFIG/hypr

# ln -sfn $REPO_ROOT/.config/* $CONFIG/
ln -sf $REPO_ROOT/.zshrc $HOME/.zshrc
for dir in $REPO_ROOT/.config/*; do
  name=$(basename $dir)
  rm -rf $CONFIG/$name
  echo Diretorio de teste $dir
  ln -sfn $dir $CONFIG/$name
done

fc-cache -fv
echo "Informe a Senha"
chsh -s "$(command -v zsh)"

# adicionar o plymouth no ROOKS do arquivo /etc/mkinitcpio.conf
# rodar sudo mkinitcpio -P
echo "╔═════════════════════════════════════════════════╗"
echo "║                 Setup Concluído                 ║"
echo "╚═════════════════════════════════════════════════╝"