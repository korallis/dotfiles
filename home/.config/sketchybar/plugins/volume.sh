#!/usr/bin/env bash
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

# Scroll to adjust; otherwise read the reported / current level.
if [ "$SENDER" = "mouse.scrolled" ]; then
    cur="$(osascript -e 'output volume of (get volume settings)')"
    new=$(( cur + (SCROLL_DELTA > 0 ? 5 : -5) ))
    [ "$new" -gt 100 ] && new=100; [ "$new" -lt 0 ] && new=0
    osascript -e "set volume output volume $new"
    vol="$new"
elif [ "$SENDER" = "volume_change" ]; then
    vol="$INFO"
else
    vol="$(osascript -e 'output volume of (get volume settings)')"
fi

muted="$(osascript -e 'output muted of (get volume settings)')"
if [ "$muted" = "true" ] || [ "$vol" -eq 0 ]; then
    icon="$ICON_VOL_MUTE"; color="$OVERLAY1"
else
    case "$vol" in
        100|9[0-9]|8[0-9]|7[0-9]|6[0-9]) icon="$ICON_VOL_100" ;;
        5[0-9]|4[0-9]|3[0-9])            icon="$ICON_VOL_66"  ;;
        2[0-9]|1[0-9])                   icon="$ICON_VOL_33"  ;;
        *)                               icon="$ICON_VOL_10"  ;;
    esac
    color="$SKY"
fi

sketchybar --set "$NAME" icon="$icon" icon.color="$color" label="${vol}%"
sketchybar --set volume.slider slider.percentage="$vol" 2>/dev/null
