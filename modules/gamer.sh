#!/bin/bash

echo =============
echo Setup Gamer
echo =============

sudo pacman -Syu

PACKAGES=(
  mesa,
  vulkan-intel
  lib32-vulkan-intel
  gamemode
  lib32-gamemode
  mangohub
  lib32-mangohub
  wine
  winetricks
  steam
  lutris
  vulkan-icd-loader
  lib32-vulkan-icd-loader
  intel-media-driver
  cpupower
)

yay -S --needed --noconfirm "${PACKAGES[@]}"

echo =================
echo CPU Performance
echo =================
sudo echo "governor='performance'" >>/etc/default/cpupower
sudo systemctl restart cpupower

echo ===============
echo Driver Intel
echo ===============

if ! grep -q "MESA_LOADER_DRIVER_OVERRIDE=iris" /etc/environment; then
  echo "MESA_LOADER_DRIVER_OVERRIDE=iris" | sudo tee -a /etc/environment
fi

echo ======================
echo Otimização de memória
echo ======================
echo "vm.swappiness=10" | sudo tee /etc/sysctl.d/99-swappiness.conf
echo "vm.nr_hugepages=128" | sudo tee /etc/sysctl.d/99-hugepages.conf

echo ==================
echo Intalar Proton GE
echo ==================

mkdir -p ~/.steam/root/compatibilitytools.d
cd ~/.steam/root/compatibilitytools.d
LATEST=$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest |
  grep browser_download_url |
  grep tar.gz |
  cut -d '"' -f 4)

wget "$LATEST" -O GE-Proton.tar.gz
tar -xvf GE-Proton.tar.gz
rm GE-Proton.tar.gz

cd ~

echo =================================
echo Adicionar na steam
echo gamemoderun mangohub MESA_GLTHREAD=true MESA_NO_ERROR=1 %command%
echo =================================
