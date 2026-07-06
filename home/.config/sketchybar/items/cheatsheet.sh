#!/usr/bin/env bash
# Keybinding cheat sheet — a keyboard button on the bar. Click to toggle a
# popup listing every AeroSpace bind. Static content, so no plugin script.
# Key glyphs: ⌥ = Option(alt), ⇧ = Shift, ⏎ = Enter, ⇥ = Tab.

C="cheatsheet"

sketchybar --add item "$C" left \
    --set "$C" \
        icon="$ICON_KEYBOARD" \
        icon.font="$FONT:Bold:16.0" \
        icon.color="$BASE" \
        label.drawing=off \
        background.color="$ACCENT_ALT" \
        background.corner_radius=9 \
        background.height=26 \
        click_script="sketchybar --set $C popup.drawing=toggle" \
        popup.align=left \
        popup.horizontal=off \
        popup.y_offset=6

# Section header row: accent-tinted title, faint divider background.
n=0
header() {
    n=$((n+1))
    sketchybar --add item "cheat.h$n" popup."$C" \
        --set "cheat.h$n" \
            icon="$1" \
            icon.color="$ACCENT" \
            icon.font="$FONT:Bold:11.0" \
            icon.padding_left=14 icon.padding_right=14 \
            label.drawing=off \
            background.color="$SURFACE0" \
            background.corner_radius=6 \
            background.height=20
}

# Binding row: keys (accent, fixed-width column) + action.
r=0
row() {
    r=$((r+1))
    sketchybar --add item "cheat.r$r" popup."$C" \
        --set "cheat.r$r" \
            icon="$1" \
            icon.color="$LAVENDER" \
            icon.font="$FONT:Bold:13.0" \
            icon.width=150 icon.align=left \
            icon.padding_left=16 icon.padding_right=8 \
            label="$2" \
            label.color="$TEXT" \
            label.font="$FONT:Regular:13.0" \
            label.align=left label.padding_right=18 \
            background.drawing=off
}

header "APPS"
row "⌥ ⏎  /  ⌥ Q"   "WezTerm"
row "⌥ B"           "Chrome"
row "⌥ E"           "Finder"
row "⌥ C"           "Close window"

header "FOCUS  ·  MOVE"
row "⌥ H J K L"     "Focus  (or arrows)"
row "⌥ ⇧ H J K L"   "Move window"
row "⌥ -  /  ⌥ ="   "Shrink / grow"

header "LAYOUT"
row "⌥ F"           "Fullscreen"
row "⌥ V"           "Toggle floating"
row "⌥ T"           "Tiles / split axis"
row "⌥ ,"           "Accordion"
row "⌥ R"           "Resize mode"

header "WORKSPACES"
row "⌥ 1 – 9"       "Go to workspace"
row "⌥ ⇧ 1 – 9"     "Move window there"
row "⌥ ⇥"           "Last workspace"

header "SERVICE MODE  ·  ⌥ ⇧ ;"
row "esc"           "Reload config"
row "R"             "Reset layout tree"
row "F"             "Float / tile all"
row "⌥ ⇧ H J K L"   "Join window"
row "backspace"     "Close others"
