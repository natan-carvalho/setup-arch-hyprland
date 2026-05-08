PACKAGES=(
  plymouth
  git
  
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
)

sudo pacman -S --noconfirm "${PACKAGES[@]}"

sudo systemctl enable bluetooth.service NetworkManager iwd sddm 

# adicionar o plymouth no ROOKS do arquivo /etc/mkinitcpio.conf
# rodar sudo mkinitcpio -P
