#!/bin/bash
#  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\ 
# ( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )
#  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ < 

WALLPAPER_FOLDER="$HOME/Documents/w4llp4p3rs"
CURSOR_FOLDER="$HOME/.icons"

set_wallpaper() {
    local wallpaper="$1"
    
    wal -q -i "$wallpaper" &>/dev/null
    swww img "$wallpaper" &>/dev/null
    
    nohup ~/.config/hypr/scripts/waybar.sh &>/dev/null &
    
    nohup pywalfox update &>/dev/null &
}

send_notification() {
    local title="$1"
    local message="$2"
    
    notify-send "$title" "$message" 2>/dev/null || true
}

set_cursor() {
    local cursor_theme="$1"
    local cursor_size="${2:-28}"
    
    gsettings set org.gnome.desktop.interface cursor-theme "$cursor_theme" 2>/dev/null
    
    hyprctl setcursor "$cursor_theme" "$cursor_size" 2>/dev/null
    
    export XCURSOR_THEME="$cursor_theme"
    export XCURSOR_SIZE="$cursor_size"
    
    echo "$cursor_theme" > /tmp/hypr_current_theme
    echo "$cursor_size" > /tmp/hypr_current_size
    
    send_notification "Cursor Changed" "$cursor_theme ($cursor_size)"
}

main_options=("wallpaper" "cursor" "both random")
selected_main=$(echo -e "1. ${main_options[0]}\n2. ${main_options[1]}\n3. ${main_options[2]}" | wofi --show dmenu --height 150 --width 200 -p "What to change:" 2>/dev/null)

case "$selected_main" in
    "1. wallpaper")
        MODE="wallpaper"
        ;;
    "2. cursor")
        MODE="cursor"
        ;;
    "3. both random")
        MODE="both_random"
        ;;
    *)
        exit 1
        ;;
esac

if [ "$MODE" == "both_random" ]; then
    WALLPAPER=$(find "$WALLPAPER_FOLDER" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) 2>/dev/null | shuf -n 1)
    
    if [ -n "$WALLPAPER" ]; then
        set_wallpaper "$WALLPAPER"
    fi
    
    cursor_themes=()
    
    if [ -d "$CURSOR_FOLDER" ]; then
        for theme_dir in "$CURSOR_FOLDER"/*; do
            if [ -d "$theme_dir/cursors" ] && [ "$(ls -A "$theme_dir/cursors" 2>/dev/null)" ]; then
                cursor_themes+=("$(basename "$theme_dir")")
            fi
        done
    fi
    
    if [ -d "/usr/share/icons" ]; then
        for theme_dir in /usr/share/icons/*; do
            if [ -d "$theme_dir/cursors" ] && [ "$(ls -A "$theme_dir/cursors" 2>/dev/null)" ]; then
                theme_name=$(basename "$theme_dir")
                if [[ ! " ${cursor_themes[@]} " =~ " ${theme_name} " ]]; then
                    cursor_themes+=("$theme_name")
                fi
            fi
        done
    fi
    
    if [ ${#cursor_themes[@]} -gt 0 ]; then
        random_cursor="${cursor_themes[$RANDOM % ${#cursor_themes[@]}]}"
        set_cursor "$random_cursor"
    fi
    
    send_notification "Theme Randomized! 🎲" "Wallpaper: $(basename "$WALLPAPER")\nCursor: $random_cursor"
    exit 0
fi

if [ "$MODE" == "wallpaper" ]; then
    options=("random" "select")
    selected_option=$(echo -e "1. ${options[0]}\n2. ${options[1]}" | wofi --show dmenu --height 100 --width 200 -p "Wallpaper:" 2>/dev/null)
    
    case "$selected_option" in
        "1. random")
            WALLPAPER=$(find "$WALLPAPER_FOLDER" -type f 2>/dev/null | shuf -n 1)
            set_wallpaper "$WALLPAPER"
            exit 0
            ;;
        "2. select")
            selected_wallpaper=$(ls -1 "$WALLPAPER_FOLDER" 2>/dev/null | grep -E "\.(jpg|png|jpeg)$" | wofi --show dmenu --height 300 --width 400 -p "Select wallpaper:" 2>/dev/null)
            if [ -z "$selected_wallpaper" ]; then
                exit 1
            fi
            selected_wallpaper_path="$WALLPAPER_FOLDER/$selected_wallpaper"
            set_wallpaper "$selected_wallpaper_path"
            exit 0
            ;;
        *)
            exit 1
            ;;
    esac
fi

if [ "$MODE" == "cursor" ]; then
    cursor_themes=()
    
    if [ -d "$CURSOR_FOLDER" ]; then
        for theme_dir in "$CURSOR_FOLDER"/*; do
            if [ -d "$theme_dir/cursors" ] && [ "$(ls -A "$theme_dir/cursors" 2>/dev/null)" ]; then
                cursor_themes+=("$(basename "$theme_dir")")
            fi
        done
    fi
    
    if [ -d "/usr/share/icons" ]; then
        for theme_dir in /usr/share/icons/*; do
            if [ -d "$theme_dir/cursors" ] && [ "$(ls -A "$theme_dir/cursors" 2>/dev/null)" ]; then
                theme_name=$(basename "$theme_dir")
                if [[ ! " ${cursor_themes[@]} " =~ " ${theme_name} " ]]; then
                    cursor_themes+=("$theme_name")
                fi
            fi
        done
    fi
    
    IFS=$'\n' sorted_cursors=($(sort <<<"${cursor_themes[*]}"))
    unset IFS
    
    if [ ${#sorted_cursors[@]} -eq 0 ]; then
        send_notification "Error" "No valid cursor themes found!"
        exit 1
    fi
    
    cursor_list=$(printf "%s\n" "${sorted_cursors[@]}")
    
    selected_cursor=$(echo "$cursor_list" | wofi --show dmenu --height 300 --width 300 -p "Select cursor theme:" 2>/dev/null)
    
    if [ -z "$selected_cursor" ]; then
        exit 1
    fi
    
    set_cursor "$selected_cursor"
    exit 0
fi
#  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\ 
# ( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )
#  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ < 
