#!/usr/bin/env bash
source "$CONFIG_DIR/colors.sh"

# Memory "used" % = 100 - free/inactive share of total pages.
read -r used <<< "$(
  vm_stat | awk '
    /page size of/ { ps=$8 }
    /Pages free/        { free=$3 }
    /Pages active/      { active=$3 }
    /Pages inactive/    { inactive=$3 }
    /Pages speculative/ { spec=$3 }
    /Pages wired/       { wired=$4 }
    /Pages occupied by compressor/ { comp=$5 }
    END {
      gsub(/\./,"",free); gsub(/\./,"",active); gsub(/\./,"",inactive);
      gsub(/\./,"",spec); gsub(/\./,"",wired); gsub(/\./,"",comp);
      total=free+active+inactive+spec+wired+comp;
      usedp=(active+wired+comp)/total*100;
      printf "%.0f", usedp
    }'
)"
[ -z "$used" ] && exit 0

if   [ "$used" -ge 85 ]; then color="$RED"
elif [ "$used" -ge 70 ]; then color="$PEACH"
else color="$MAUVE"; fi

sketchybar --set "$NAME" icon.color="$color" label="${used}%"
