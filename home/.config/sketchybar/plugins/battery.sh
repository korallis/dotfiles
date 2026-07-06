#!/usr/bin/env bash
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

pct="$(pmset -g batt | grep -Eo '[0-9]+%' | head -1 | tr -d '%')"
charging="$(pmset -g batt | grep -c 'AC Power')"
[ -z "$pct" ] && exit 0

if [ "$charging" -eq 1 ]; then
    icon="$ICON_BATT_CHARGING"; color="$GREEN"
else
    case "$pct" in
        100|9[0-9]|8[0-9]|7[0-9]) icon="$ICON_BATT_100"; color="$GREEN" ;;
        6[0-9]|5[0-9])            icon="$ICON_BATT_75";  color="$TEAL"  ;;
        4[0-9]|3[0-9])            icon="$ICON_BATT_50";  color="$YELLOW" ;;
        2[0-9]|1[0-9])            icon="$ICON_BATT_25";  color="$PEACH" ;;
        *)                        icon="$ICON_BATT_0";   color="$RED"   ;;
    esac
fi

sketchybar --set "$NAME" icon="$icon" icon.color="$color" label="${pct}%"
