#!/bin/bash
#  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\ 
# ( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )
#  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ < 
#  /\_/\          ..                          ..       ..                      ..       ..                    .x+=:.      /\_/\ 
# ( o.o )   . uW8"          .n~~%x.     x .d88"  x .d88"                 x .d88"  x .d88"      .n~~%x.       z`    ^%    ( o.o )
#  > ^ <    `t888         x88X   888.    5888R    5888R      x.    .      5888R    5888R     x88X   888.        .   <k    > ^ < 
#  /\_/\     8888   .    X888X   8888L   '888R    '888R    .@88k  z88u    '888R    '888R    X888X   8888L     .@8Ned8"    /\_/\ 
# ( o.o )    9888.z88N  X8888X   88888    888R     888R   ~"8888 ^8888     888R     888R   X8888X   88888   .@^%8888"    ( o.o )
#  > ^ <     9888  888E 88888X   88888X   888R     888R     8888  888R     888R     888R   88888X   88888X x88:  `)8b.    > ^ < 
#  /\_/\     9888  888E 88888X   88888X   888R     888R     8888  888R     888R     888R   88888X   88888X 8888N=*8888    /\_/\ 
# ( o.o )    9888  888E 88888X   88888f   888R     888R     8888  888R     888R     888R   88888X   88888f  %8"    R88   ( o.o )
#  > ^ <     9888  888E 48888X   88888    888R     888R     8888 ,888B .   888R     888R   48888X   88888    @8Wou 9%     > ^ < 
#  /\_/\    .8888  888"  ?888X   8888"   .888B .  .888B .  "8888Y 8888"   .888B .  .888B .  ?888X   8888"  .888888P`      /\_/\ 
# ( o.o )    `%888*%"     "88X   88*`    ^*888%   ^*888%    `Y"   'YP     ^*888%   ^*888%    "88X   88*`   `   ^"F       ( o.o )
#  > ^ <        "`          ^"==="`        "%       "%                      "%       "%        ^"==="`                    > ^ < 
#  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\ 
# ( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )
#  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ < 

# Set the paths to your folders
WALLPAPER_FOLDER="$HOME/Documents/w4llp4p3rs"
CURSOR_FOLDER="$HOME/.icons"

# Function to set wallpaper and reset Waybar
set_wallpaper() {
    local wallpaper="$1"
    
    # Run commands synchronously but quickly
    wal -q -i "$wallpaper" &>/dev/null
    swww img "$wallpaper" &>/dev/null
    
    # Start waybar reload in background and detach completely
    nohup ~/.config/hypr/scripts/waybar.sh &>/dev/null &
    
    # Try pywalfox in background, will complete after script exits
    nohup pywalfox update &>/dev/null &
}

# Function to send notification (with fallback if notify-send fails)
send_notification() {
    local title="$1"
    local message="$2"
    
    notify-send "$title" "$message" 2>/dev/null || true
}

# Function to set cursor theme
set_cursor() {
    local cursor_theme="$1"
    # If size is provided, use it. If not, default to 28 (or read from file if you prefer)
    local cursor_size="${2:-28}"
    
    # Update GTK
    gsettings set org.gnome.desktop.interface cursor-theme "$cursor_theme" 2>/dev/null
    
    # Update Hyprland LIVE (No reload needed!)
    hyprctl setcursor "$cursor_theme" "$cursor_size" 2>/dev/null
    
    # Update Environment for current shell
    export XCURSOR_THEME="$cursor_theme"
    export XCURSOR_SIZE="$cursor_size"
    
    # SAVE STATE to /tmp so our hotkey scripts know what we are using
    echo "$cursor_theme" > /tmp/hypr_current_theme
    echo "$cursor_size" > /tmp/hypr_current_size
    
    send_notification "Cursor Changed" "$cursor_theme ($cursor_size)"
}

# Main menu - Ask what to change
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

# Handle Both Random - Pick random wallpaper AND random cursor
if [ "$MODE" == "both_random" ]; then
    # Get random wallpaper
    WALLPAPER=$(find "$WALLPAPER_FOLDER" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) 2>/dev/null | shuf -n 1)
    
    if [ -n "$WALLPAPER" ]; then
        set_wallpaper "$WALLPAPER"
    fi
    
    # Get random cursor theme
    cursor_themes=()
    
    # Check user directory
    if [ -d "$CURSOR_FOLDER" ]; then
        for theme_dir in "$CURSOR_FOLDER"/*; do
            if [ -d "$theme_dir/cursors" ] && [ "$(ls -A "$theme_dir/cursors" 2>/dev/null)" ]; then
                cursor_themes+=("$(basename "$theme_dir")")
            fi
        done
    fi
    
    # Check system directory
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

# Handle Wallpaper (manual selection)
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

# Handle Cursor (manual selection)
if [ "$MODE" == "cursor" ]; then
    cursor_themes=()
    
    # Check user directory
    if [ -d "$CURSOR_FOLDER" ]; then
        for theme_dir in "$CURSOR_FOLDER"/*; do
            if [ -d "$theme_dir/cursors" ] && [ "$(ls -A "$theme_dir/cursors" 2>/dev/null)" ]; then
                cursor_themes+=("$(basename "$theme_dir")")
            fi
        done
    fi
    
    # Check system directory
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
    
    # Sort the list
    IFS=$'\n' sorted_cursors=($(sort <<<"${cursor_themes[*]}"))
    unset IFS
    
    if [ ${#sorted_cursors[@]} -eq 0 ]; then
        send_notification "Error" "No valid cursor themes found!"
        exit 1
    fi
    
    # Convert array to string for wofi
    cursor_list=$(printf "%s\n" "${sorted_cursors[@]}")
    
    selected_cursor=$(echo "$cursor_list" | wofi --show dmenu --height 300 --width 300 -p "Select cursor theme:" 2>/dev/null)
    
    if [ -z "$selected_cursor" ]; then
        exit 1
    fi
    
    set_cursor "$selected_cursor"
    exit 0
fi
