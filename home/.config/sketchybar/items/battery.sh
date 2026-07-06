#!/usr/bin/env bash
# Battery — glyph colour tracks charge; label shows percentage.

sketchybar --add item battery right \
    --set battery \
        icon="$ICON_BATT_100" \
        icon.color="$GREEN" \
        label.font="$FONT:Bold:13.0" \
        background.color="$SURFACE0" \
        background.corner_radius=9 \
        background.height=26 \
        update_freq=60 \
        script="$PLUGIN_DIR/battery.sh" \
    --subscribe battery power_source_change system_woke
