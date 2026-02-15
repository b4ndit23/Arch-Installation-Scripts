#  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\ 
# ( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )
#  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ < 

#!/bin/bash

read_value() {
    cat "$1" 2>/dev/null | tr -d '[:space:]'
}

CURRENT_THEME=$(read_value /tmp/hypr_current_theme)
CURRENT_SIZE=$(read_value /tmp/hypr_current_size)

if [ -z "$CURRENT_THEME" ]; then
    CURRENT_THEME="Adwaita"
fi
if [ -z "$CURRENT_SIZE" ]; then
    CURRENT_SIZE=24
fi

SIZES=(32 48 64)
NEXT_SIZE=$CURRENT_SIZE

for i in "${!SIZES[@]}"; do
    if [[ "${SIZES[$i]}" == "$CURRENT_SIZE" ]]; then
        INDEX=$i
        break
    fi
done

case "$1" in
    "up")
        NEXT_INDEX=$(( (INDEX + 1) % ${#SIZES[@]} ))
        NEXT_SIZE=${SIZES[$NEXT_INDEX]}
        ;;
    "down")
        NEXT_INDEX=$(( (INDEX - 1 + ${#SIZES[@]}) % ${#SIZES[@]} ))
        NEXT_SIZE=${SIZES[$NEXT_INDEX]}
        ;;
    *)
        exit 1
        ;;
esac

hyprctl setcursor "$CURRENT_THEME" "$NEXT_SIZE"

echo "$NEXT_SIZE" > /tmp/hypr_current_size

notify-send "Cursor Size" "$CURRENT_THEME: $NEXT_SIZE" 2>/dev/null || true
#  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\ 
# ( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )
#  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ < 
