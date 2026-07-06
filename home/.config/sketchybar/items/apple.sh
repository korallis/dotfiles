#!/usr/bin/env bash
# Apple logo — accent pill on the far left, opens a quick-actions popup.

sketchybar --add item apple.logo left \
    --set apple.logo \
        icon="$ICON_APPLE" \
        icon.font="$FONT:Bold:18.0" \
        icon.color="$BASE" \
        icon.padding_left=10 \
        icon.padding_right=10 \
        label.drawing=off \
        background.color="$ACCENT" \
        background.corner_radius=9 \
        background.height=26 \
        click_script="sketchybar --set apple.logo popup.drawing=toggle" \
        popup.horizontal=off \
        popup.align=left

# popup entries
sketchybar --add item apple.about popup.apple.logo \
    --set apple.about icon="" label="About This Mac" \
        click_script="open -a 'System Information'; sketchybar --set apple.logo popup.drawing=off" \
    --add item apple.prefs popup.apple.logo \
    --set apple.prefs icon="" label="System Settings" \
        click_script="open -a 'System Settings'; sketchybar --set apple.logo popup.drawing=off" \
    --add item apple.activity popup.apple.logo \
    --set apple.activity icon="" label="Activity Monitor" \
        click_script="open -a 'Activity Monitor'; sketchybar --set apple.logo popup.drawing=off" \
    --add item apple.lock popup.apple.logo \
    --set apple.lock icon="" label="Lock Screen" \
        click_script="pmset displaysleepnow; sketchybar --set apple.logo popup.drawing=off"

# Hide popup when the mouse leaves it.
sketchybar --subscribe apple.logo mouse.exited.global
