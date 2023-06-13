MON_MAIN=$1
MON_SECOND=$2
WALLPAPER=$3

PQIVRUN=$(pgrep -c -f "pqiv: $MON_SECOND")

if [[ "$PQIVRUN" != "0" ]]; then 
  pkill -f "pqiv: $MON_SECOND"
fi

hyprctl dispatch swapactiveworkspaces "$MON_MAIN" "$MON_SECOND"

if [[ "$PQIVRUN" != "0" ]]; then 
  pqiv -l -i -T "pqiv: $MON_SECOND" --shuffle -f "$WALLPAPER" &
  sleep 0.15
  hyprctl dispatch movewindow mon:"$MON_SECOND"
fi

hyprctl dispatch focusmonitor "$MON_MAIN"

