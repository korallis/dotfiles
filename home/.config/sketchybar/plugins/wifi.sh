#!/usr/bin/env bash
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

# SSID via system_profiler (networksetup -getairportnetwork is deprecated on Tahoe).
ssid="$(ipconfig getsummary en0 2>/dev/null | awk -F ' SSID : ' '/ SSID : / {print $2; exit}')"
[ -z "$ssid" ] && ssid="$(system_profiler SPAirPortDataType 2>/dev/null \
    | awk '/Current Network Information:/{getline; gsub(/^ *| *:$/,""); print; exit}')"

if [ -n "$ssid" ]; then
    sketchybar --set "$NAME" icon="$ICON_WIFI" icon.color="$BLUE" label="$ssid"
else
    sketchybar --set "$NAME" icon="$ICON_WIFI_OFF" icon.color="$OVERLAY1" label="off"
fi
