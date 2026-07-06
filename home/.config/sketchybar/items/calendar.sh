#!/usr/bin/env bash
# Center clock — day / date on the left, time on the right, accent pill.

sketchybar --add item clock center \
    --set clock \
        icon="$ICON_CLOCK" \
        icon.color="$ACCENT" \
        icon.font="$FONT:Bold:15.0" \
        icon.padding_left=12 \
        label.font="$FONT:Bold:13.0" \
        label.color="$TEXT" \
        label.padding_right=12 \
        background.color="$SURFACE0" \
        background.corner_radius=9 \
        background.height=26 \
        update_freq=10 \
        script="$PLUGIN_DIR/clock.sh" \
        click_script="open -a Calendar" \
    --subscribe clock system_woke
