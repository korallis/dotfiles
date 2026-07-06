#!/usr/bin/env bash
# Volume — glyph reflects level; scroll to change, click for a slider popup.

sketchybar --add item volume right \
    --set volume \
        icon="$ICON_VOL_100" \
        icon.color="$SKY" \
        label.font="$FONT:Bold:13.0" \
        background.color="$SURFACE0" \
        background.corner_radius=9 \
        background.height=26 \
        script="$PLUGIN_DIR/volume.sh" \
        click_script="sketchybar --set volume popup.drawing=toggle" \
    --subscribe volume volume_change mouse.scrolled

# slider inside the popup
sketchybar --add slider volume.slider popup.volume 120 \
    --set volume.slider \
        slider.highlight_color="$ACCENT" \
        slider.background.height=6 \
        slider.background.corner_radius=3 \
        slider.background.color="$SURFACE1" \
        slider.knob="􀀁" \
        slider.knob.drawing=on \
        icon="$ICON_VOL_66" icon.color="$SKY" \
        label.drawing=off \
        click_script="osascript -e \"set volume output volume \$PERCENTAGE\"" \
    --subscribe volume.slider mouse.clicked
