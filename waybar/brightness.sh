#!/bin/bash

get_brightness() {
    ddcutil getvcp 10 2>/dev/null | awk -F'=' '/current value/ {gsub(/,/, "", $2); print $2+0}'
}

set_brightness() {
    ddcutil setvcp 10 "$1" >/dev/null 2>&1
}

case "$1" in
  up)   step=+10 ;;
  down) step=-10 ;;
  *)    step=0 ;;
esac

if [ "$step" != 0 ]; then
  val=$(get_brightness)
  new=$((val+step))

  # Clamp to [0,100]
  (( new < 0 )) && new=0
  (( new > 100 )) && new=100

  set_brightness "$new"
fi

# Refresh brightness after change
current=$(get_brightness)
[ -z "$current" ] && current=0

# Pick icon + color class
if [ "$current" -le 30 ]; then
    icon="○"       # empty circle (low brightness)
    color="low"
elif [ "$current" -le 70 ]; then
    icon="◐"       # half circle (medium brightness)
    color="medium"
else
    icon="●"       # filled circle (high brightness)
    color="high"
fi

# Output JSON (icon + percent)
printf '{"text":"%s %s%%","tooltip":"External display brightness","class":"brightness %s"}\n' "$icon" "$current" "$color"

# Trigger Waybar refresh
kill -SIGRTMIN+1 $(pidof waybar)
