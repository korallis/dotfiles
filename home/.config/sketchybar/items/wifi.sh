#!/usr/bin/env bash
# Wi-Fi — glyph + SSID (polled; the wifi_change event is unreliable on modern macOS).

sketchybar --add item wifi right \
    --set wifi \
        icon="$ICON_WIFI" \
        icon.color="$BLUE" \
        label.font="$FONT:Bold:13.0" \
        label.max_chars=18 \
        background.color="$SURFACE0" \
        background.corner_radius=9 \
        background.height=26 \
        update_freq=15 \
        script="$PLUGIN_DIR/wifi.sh" \
        click_script="open -a 'System Settings' x-apple.systempreferences:com.apple.Network-Settings.extension" \
    --subscribe wifi wifi_change system_woke
