#!/usr/bin/env bash
# Cycle hyprsunset through 5 warmth levels on each SUPER+N press:
#   0: neutral (identity)
#   1: 5500K
#   2: 4500K
#   3: 3700K
#   4: 3000K
# Then wraps back to 0.
STATE_FILE=/tmp/hyprsunset-level

current=0
[ -f "$STATE_FILE" ] && current=$(cat "$STATE_FILE" 2>/dev/null)

# Advance and wrap
next=$(( (current + 1) % 5 ))

case "$next" in
  0) hyprctl hyprsunset identity ;;
  1) hyprctl hyprsunset temperature 5500 ;;
  2) hyprctl hyprsunset temperature 4500 ;;
  3) hyprctl hyprsunset temperature 3700 ;;
  4) hyprctl hyprsunset temperature 3000 ;;
esac

echo "$next" > "$STATE_FILE"

# Optional: brief on-screen confirmation
notify-send -t 800 "hyprsunset" "level $next / 4"
