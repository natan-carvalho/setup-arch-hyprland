#!/bin/bash

ROFI="rofi -dmenu -i -theme ~/.config/rofi/launchers/type-1/style-5.rasi"
SCAN_TIME=8

# ======== ICONS ========
get_icon() {
  case "$1" in
    *Headset*|*Headphone*|*Buds*|*AirPods*) echo "󰋋" ;;
    *Mouse*) echo "󰍽" ;;
    *Keyboard*) echo "󰌌" ;;
    *Controller*|*Gamepad*|*Xbox*|*DualShock*) echo "󰖺" ;;
    *) echo "󰂯" ;;
  esac
}

# ======== Battery ========
get_battery() {
  local mac="$1"
  local mac_formatted=$(echo "$mac" | tr -d ':' | tr 'A-Z' 'a-z')

  for dev in /sys/class/power_supply/*; do
    [ -f "$dev/capacity" ] || continue
    [ -f "$dev/uevent" ] || continue

    if grep -qi "$mac_formatted" "$dev/uevent" 2>/dev/null; then
      cat "$dev/capacity"
      return 0
    fi
  done
}

# ======== power ========
is_powered() {
  bluetoothctl show | grep -q "Powered: yes"
}

toggle_power() {
  if is_powered; then
    bluetoothctl power off
  else
    bluetoothctl power on
  fi
}

# ======== Scan ========
scan_devices() {
  notify-send "Bluetooth" "Escanenando dispositivos Bluetooth..."

  DEVICES=$(echo -e "scan on\n" | bluetoothctl | \
    timeout $SCAN_TIME cat | \
    grep "Device" \ |
    awk '{print $3, substr($0, index($0,$4))}' | \
    sort -u)

  echo "$DEVICES" | while read -r MAC NAME; do
    ICON=$(get_icon "$NAME")
    echo "$ICON $NAME ($MAC)"
  done
}

# ======== Devices ========
get_devices() {
  bluetoothctl devices | while read -r _ MAC NAME; do
    ICON=$(get_icon "$NAME")
    BATTERY=$(get_battery "$MAC")

    if bluetoothctl info "$MAC" | grep -q "Connected: yes"; then
      STATUS="[connected]"
    else
      STATUS=""
    fi

    if [ -n "$BATTERY" ]; then
      echo "$ICON $NAME $STATUS 🔋${BATTERY}%::$MAC"
    else
      echo "$ICON $NAME $STATUS::$MAC"
    fi
  done
}

# ======== MENU ========
menu() {
  DEVICES=$(get_devices)

  MENU=$(printf \
    "󰂯  Bluetooth
     󰂯  Ligar/Desligar
     󰂓  Escanear

    %s" "$DEVICES"
  )

  CHOICE=$(echo -e "$MENU" | $ROFI)

  [ -z "$CHOICE" ] && exit 0

  case "$CHOICE" in
    *Ligar/Desligar*)
      toggle_power
      ;;
    *Escanear*)
      DEVICES=$(scan_devices)
      CHOICE=$(echo "$DEVICE" | $ROFI)
      ;;
  esac

  [ -z $CHOICE ] && exit 0

  MAC=$(echo "$CHOICE" | awk -F "::" '{print $2}')

  # desconectar
  if bluetoothctl info "$MAC" | grep -q "Connected: yes"; then
    bluetoothctl disconnect "$MAC"
    notify-send "Bluetooth" "Desconectado $CHOICE"
    exit 0
  fi

  # pair + connect + trust
  {
    echo -e "pair $MAC\nconnect $MAC\ntrust $MAC\nquit"
  } | bluetoothctl >/dev/null
}

# ======== WAYBAR ========
status() {
  if ! is_powered; then
    echo "󰂲 Off"
    exit 0
  fi

  DEVICE_LINE=$(bluetoothctl devices Connected | head -n 1)

  [ -z "$DEVICE_LINE" ] && {
    echo "󰂯 On"
    exit 0
  }

  MAC=$(echo "$DEVICE_LINE" | awk '{print $2}')
  NAME=$(echo "$DEVICE_LINE" | cut -d ' ' -f 3-)
  ICON=$(get_icon "$NAME")
  BATTERY=$(get_battery "$MAC")

  if [ -n "$BATTERY" ]; then
    echo "$ICON $NAME 🔋${BATTERY}%"
  else
    echo "$ICON $NAME"
  fi
}

# ===== ENTRY =====
case "$1" in
  toggle) toggle_power ;;
  menu) menu ;;
  *) status ;;
esac