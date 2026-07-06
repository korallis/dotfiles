#!/usr/bin/env bash
source "$CONFIG_DIR/colors.sh"

# Total CPU usage % from top (user+sys), one sample.
usage="$(top -l 1 -n 0 | awk -F'[:,]' '/CPU usage/ {
    u=$2; s=$3; gsub(/[^0-9.]/,"",u); gsub(/[^0-9.]/,"",s);
    printf "%.0f", u+s
}')"
[ -z "$usage" ] && usage=0

if   [ "$usage" -ge 85 ]; then color="$RED"
elif [ "$usage" -ge 60 ]; then color="$PEACH"
else color="$SAPPHIRE"; fi

sketchybar --push cpu "$(echo "scale=2; $usage/100" | bc 2>/dev/null || echo 0)"
sketchybar --set cpu icon.color="$color" label="${usage}%" graph.color="$color"
