#!/usr/bin/env bash
# Front app — app-font glyph + name of the currently focused application.

sketchybar --add item front_app left \
    --set front_app \
        icon.font="$APP_FONT:Regular:16.0" \
        icon.color="$ACCENT" \
        icon.padding_left=10 \
        label.font="$FONT:Bold:13.0" \
        label.color="$TEXT" \
        label.padding_right=10 \
        background.color="$SURFACE0" \
        background.corner_radius=9 \
        background.height=26 \
        script="$PLUGIN_DIR/front_app.sh" \
        click_script="aerospace list-windows --focused" \
    --subscribe front_app front_app_switched
