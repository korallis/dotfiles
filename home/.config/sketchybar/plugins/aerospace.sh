#!/usr/bin/env bash
# Workspace pill renderer.
#   $1                = workspace id baked in at add time
#   $FOCUSED_WORKSPACE = focused ws (only on aerospace_workspace_change)
# Highlights the focused pill and paints an app-font glyph strip of its windows.

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/plugins/icon_map.sh"
APP_FONT="sketchybar-app-font"

sid="$1"
focused="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

# Build a de-duplicated glyph strip for the apps on this workspace.
strip=""
seen=""
while IFS= read -r app; do
    [ -z "$app" ] && continue
    case "$seen" in *"|$app|"*) continue ;; esac
    seen="$seen|$app|"
    __icon_map "$app"
    strip+="${icon_result} "
done < <(aerospace list-windows --workspace "$sid" --format '%{app-name}' 2>/dev/null)
strip="${strip% }"

if [ "$sid" = "$focused" ]; then
    # focused: glowing accent pill, dark glyphs
    if [ -n "$strip" ]; then
        sketchybar --animate tanh 20 --set "space.$sid" \
            background.color="$ACCENT" \
            background.border_width=0 \
            icon.color="$BASE" \
            label="$strip" label.color="$BASE" label.drawing=on
    else
        sketchybar --animate tanh 20 --set "space.$sid" \
            background.color="$ACCENT" \
            background.border_width=0 \
            icon.color="$BASE" \
            label.drawing=off
    fi
else
    if [ -n "$strip" ]; then
        # occupied but unfocused: outlined pill with coloured glyphs
        sketchybar --animate tanh 20 --set "space.$sid" \
            background.color="$TRANSPARENT" \
            background.border_width=2 \
            background.border_color="$SURFACE1" \
            icon.color="$SUBTEXT" \
            label="$strip" label.color="$TEXT" label.drawing=on
    else
        # empty + unfocused: dim number only
        sketchybar --animate tanh 20 --set "space.$sid" \
            background.color="$TRANSPARENT" \
            background.border_width=0 \
            icon.color="$OVERLAY0" \
            label.drawing=off
    fi
fi
