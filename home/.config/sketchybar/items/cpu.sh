#!/usr/bin/env bash
# CPU — live graph with an icon + usage% label, wrapped in a pill.

sketchybar --add graph cpu right 45 \
    --set cpu \
        graph.color="$ACCENT_ALT" \
        graph.fill_color="0x3389b4fa" \
        graph.line_width=2.0 \
        icon="$ICON_CPU" \
        icon.color="$SAPPHIRE" \
        label.font="$FONT:Bold:13.0" \
        label.padding_right=10 \
        background.color="$SURFACE0" \
        background.corner_radius=9 \
        background.height=26 \
        update_freq=2 \
        script="$PLUGIN_DIR/cpu.sh" \
    --subscribe cpu system_woke
