#!/bin/bash

# Lista redes
wifi_list=$(nmcli -t -f SSID,SECURITY dev wifi list | sed '/^$/d')

# Escolhe a rede
chosen_wifi=$(echo "$wifi_list" | wofi --dmenu --prompt "Select Wi-Fi Network")

[ -z "$chosen_wifi" ] && exit 1

ssid=$(echo "$chosen_wifi" | cut -d: -f1)
security=$(echo "$chosen_wifi" | cut -d: -f2)

# Se for aberta
if [ -z "$security" ]; then
  nmcli dev wifi connect "$ssid"
else
  # Solicita a senha
  password=$(wofi --dmenu --password --prompt "Enter Wi-Fi Password for $ssid")

  [ -z "$password" ] && exit 1

  nmcli dev wifi connect "$ssid" password "$password"
fi
