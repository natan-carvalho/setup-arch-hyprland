#!/bin/bash
connected_ssid=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^sim:' | cut -d: -f2)

if [ -z "$connected_ssid" ]; then
  echo "睊  Offline"
else
  echo "  $connected_ssid"
fi