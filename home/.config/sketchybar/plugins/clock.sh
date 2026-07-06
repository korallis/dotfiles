#!/usr/bin/env bash
# Center clock — "Mon 07 Jul  ·  14:30"
sketchybar --set "$NAME" label="$(date '+%a %d %b  ·  %H:%M')"
