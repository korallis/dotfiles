#!/usr/bin/env bash
# Workspace pills — one per AeroSpace workspace. The focused pill glows with
# the accent; each pill shows app-font glyphs for the windows living on it.

sketchybar --add event aerospace_workspace_change

# Enumerate workspaces from AeroSpace; fall back to 1-9 if it isn't up yet.
WORKSPACES="$(aerospace list-workspaces --all 2>/dev/null)"
[ -z "$WORKSPACES" ] && WORKSPACES=$'1\n2\n3\n4\n5\n6\n7\n8\n9'

SPACE_ICONS=()
while IFS= read -r sid; do
    [ -z "$sid" ] && continue
    SPACE_ICONS+=("space.$sid")
    sketchybar --add item "space.$sid" left \
        --set "space.$sid" \
            icon="$sid" \
            icon.font="$FONT:Bold:15.0" \
            icon.color="$SUBTEXT" \
            icon.padding_left=10 \
            icon.padding_right=6 \
            label.font="$APP_FONT:Regular:15.0" \
            label.color="$TEXT" \
            label.padding_left=0 \
            label.padding_right=10 \
            label.drawing=off \
            background.color="$TRANSPARENT" \
            background.corner_radius=9 \
            background.height=26 \
            background.border_width=0 \
            background.border_color="$ACCENT" \
            click_script="aerospace workspace $sid" \
            script="$PLUGIN_DIR/aerospace.sh $sid" \
        --subscribe "space.$sid" aerospace_workspace_change front_app_switched space_windows_change
done <<< "$WORKSPACES"

# Thin separator between workspaces and the front-app item.
sketchybar --add item space.sep left \
    --set space.sep icon="" \
        icon.color="$SURFACE2" \
        icon.font="$FONT:Regular:16.0" \
        icon.padding_left=6 icon.padding_right=6 \
        label.drawing=off \
        background.drawing=off \
        associated_display=active
