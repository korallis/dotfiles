#!/usr/bin/env bash
# Memory — RAM pressure used%, colour shifts as it climbs.

sketchybar --add item memory right \
    --set memory \
        icon="$ICON_MEMORY" \
        icon.color="$MAUVE" \
        label.font="$FONT:Bold:13.0" \
        background.color="$SURFACE0" \
        background.corner_radius=9 \
        background.height=26 \
        update_freq=5 \
        script="$PLUGIN_DIR/memory.sh" \
    --subscribe memory system_woke
