MON_LEFT=$1
MON_MAIN=$2
MON_RIGHT=$3
WALLPAPER=$4

ACTIVEMON=$(hyprctl -j activeworkspace | jq -r ".monitor")

if [[ "$ACTIVEMON" != "$MON_MAIN" ]]; then
  pkill -f "pqiv: $ACTIVEMON"
  pqiv -l -i -T "pqiv: $ACTIVEMON" --shuffle -f "$WALLPAPER" &
  sleep 0.15
  hyprctl dispatch focusmonitor "$MON_MAIN"
fi

if [[ "$ACTIVEMON" == "$MON_MAIN" ]]; then

  PQIVRUN=$(pgrep -c -f "pqiv: $MON_LEFT")
  if [[ "$PQIVRUN" == "0" ]]; then 
    pqiv -l -i -T "pqiv: $MON_LEFT" --shuffle -f "$WALLPAPER" &
    sleep 0.15
    hyprctl dispatch movewindow mon:"$MON_LEFT"

    hyprctl dispatch focusmonitor "$MON_MAIN"
  fi

  PQIVRUN=$(pgrep -c -f "pqiv: $MON_RIGHT")
  if [[ "$PQIVRUN" == "0" ]]; then 
    pqiv -l -i -T "pqiv: $MON_RIGHT" --shuffle -f "$WALLPAPER" &
    sleep 0.15
    hyprctl dispatch movewindow mon:"$MON_RIGHT"

    hyprctl dispatch focusmonitor "$MON_MAIN"
  fi
fi
