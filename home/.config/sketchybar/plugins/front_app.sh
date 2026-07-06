#!/usr/bin/env bash
# Front-app label + app-font glyph.

source "$CONFIG_DIR/plugins/icon_map.sh"

if [ "$SENDER" = "front_app_switched" ]; then
    __icon_map "$INFO"
    sketchybar --set "$NAME" label="$INFO" icon="$icon_result"
fi
