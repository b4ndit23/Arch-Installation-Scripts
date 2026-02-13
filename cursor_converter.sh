#!/bin/bash

# Script to convert cursor SETS with PROPER HOTSPOT positioning

CURSOR_SOURCE="$HOME/Pictures/Cursors"
OUTPUT_DIR="$HOME/.icons"
TEMP_DIR="/tmp/cursor_conversion"

echo "========================================="
echo "Converting YOUR Cursor Sets to Themes"
echo "WITH AUTO-SCALING & PROPER HOTSPOTS"
echo "========================================="

if ! command -v xcursorgen &> /dev/null; then
    echo "Installing xcursorgen..."
    sudo pacman -S xorg-xcursorgen --noconfirm || {
        echo "Please install xcursorgen manually:"
        echo "  sudo pacman -S xorg-xcursorgen"
        exit 1
    }
fi

if ! command -v convert &> /dev/null; then
    echo "Installing ImageMagick (for image scaling)..."
    sudo pacman -S imagemagick --noconfirm || {
        echo "Please install ImageMagick manually:"
        echo "  sudo pacman -S imagemagick"
        exit 1
    }
fi

mkdir -p "$TEMP_DIR"

declare -A themes

for png_file in "$CURSOR_SOURCE"/*-default.png "$CURSOR_SOURCE"/*-hand.png; do
    [ -f "$png_file" ] || continue
    
    basename=$(basename "$png_file")
    theme_name=$(echo "$basename" | sed -E 's/-(default|hand)\.png$//')
    themes["$theme_name"]=1
done

if [ ${#themes[@]} -eq 0 ]; then
    echo "ERROR: No cursor pairs found!"
    echo ""
    echo "Expected file naming:"
    echo "  themename-default.png  (the arrow/pointer)"
    echo "  themename-hand.png     (the clicking hand)"
    exit 1
fi

echo "Found ${#themes[@]} cursor theme(s)"
echo ""

create_scaled_cursors() {
    local source_png="$1"
    local output_prefix="$2"
    local sizes=(28 36 52 68)
    
    for size in "${sizes[@]}"; do
        convert "$source_png" -resize ${size}x${size} "$TEMP_DIR/${output_prefix}_${size}.png" 2>/dev/null
        
        if [ $? -ne 0 ]; then
            echo "  ⚠️  Warning: Failed to scale $(basename "$source_png") to ${size}x${size}"
        fi
    done
}

for theme_name in "${!themes[@]}"; do
    default_png="$CURSOR_SOURCE/${theme_name}-default.png"
    hand_png="$CURSOR_SOURCE/${theme_name}-hand.png"
    
    echo "Processing: $theme_name"
    
    if [ ! -f "$default_png" ]; then
        echo "  ⚠️  Missing: ${theme_name}-default.png (skipping)"
        continue
    fi
    if [ ! -f "$hand_png" ]; then
        echo "  ⚠️  Missing: ${theme_name}-hand.png (skipping)"
        continue
    fi
    
    default_size=$(identify -format "%wx%h" "$default_png" 2>/dev/null)
    hand_size=$(identify -format "%wx%h" "$hand_png" 2>/dev/null)
    echo "  Original sizes: default=$default_size, hand=$hand_size"
    
    echo "  Scaling to slightly larger cursor sizes (28, 36, 52, 68)..."
    create_scaled_cursors "$default_png" "${theme_name}_default"
    create_scaled_cursors "$hand_png" "${theme_name}_hand"
    
    theme_dir="$OUTPUT_DIR/$theme_name"
    mkdir -p "$theme_dir/cursors"
    
    cat > "$theme_dir/index.theme" << EOF
[Icon Theme]
Name=$theme_name
Comment=Custom cursor theme with proper hotspot positioning
EOF
    
    default_config="$TEMP_DIR/${theme_name}_default.cfg"
    cat > "$default_config" << EOF
28 5 5 $TEMP_DIR/${theme_name}_default_28.png
36 6 6 $TEMP_DIR/${theme_name}_default_36.png
52 9 9 $TEMP_DIR/${theme_name}_default_52.png
68 12 12 $TEMP_DIR/${theme_name}_default_68.png
EOF
    
    hand_config="$TEMP_DIR/${theme_name}_hand.cfg"
    cat > "$hand_config" << EOF
28 9 5 $TEMP_DIR/${theme_name}_hand_28.png
36 12 6 $TEMP_DIR/${theme_name}_hand_36.png
52 18 9 $TEMP_DIR/${theme_name}_hand_52.png
68 24 12 $TEMP_DIR/${theme_name}_hand_68.png
EOF
    
    default_names=(
        "default" "left_ptr" "arrow" "top_left_arrow"
        "wait" "watch" "progress"
        "help" "question_arrow"
        "cross" "crosshair" "tcross"
        "move" "fleur" "size_all"
        "n-resize" "s-resize" "e-resize" "w-resize"
        "ne-resize" "nw-resize" "se-resize" "sw-resize"
        "ns-resize" "ew-resize" "nesw-resize" "nwse-resize"
        "col-resize" "row-resize"
        "not-allowed" "forbidden" "no-drop"
        "text" "xterm" "ibeam"
        "zoom-in" "zoom-out"
        "alias" "copy" "context-menu"
        "cell" "vertical-text" "all-scroll"
    )
    
    hand_names=(
        "pointer" "hand" "hand2" "pointing_hand" "hand1"
        "grab" "openhand" "grabbing" "closedhand"
    )
    
    echo "  Generating cursor files with proper hotspots..."
    for cursor_name in "${default_names[@]}"; do
        xcursorgen "$default_config" "$theme_dir/cursors/$cursor_name" 2>/dev/null
    done
    
    for cursor_name in "${hand_names[@]}"; do
        xcursorgen "$hand_config" "$theme_dir/cursors/$cursor_name" 2>/dev/null
    done
    
    echo "  ✓ Created: $theme_dir"
    echo "    - Default cursor: hotspot at tip (top-left)"
    echo "    - Hand cursor: hotspot at fingertip"
    echo ""
done

echo "Cleaning up temporary files..."
rm -rf "$TEMP_DIR"

echo ""
echo "========================================="
echo "SUCCESS! Created ${#themes[@]} cursor themes"
echo "========================================="

for theme_name in "${!themes[@]}"; do
    echo "  ✓ $theme_name"
done


echo ""
echo "Your cursor themes are in: $OUTPUT_DIR"
echo ""
echo "Cursor sizes: 28px, 36px, 52px, 68px (slightly bigger than standard)"
