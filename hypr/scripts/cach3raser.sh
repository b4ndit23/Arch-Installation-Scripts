#!/bin/bash
#  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\ 
# ( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )
#  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ < 

usage() {
    echo "Usage: $0 [-copy [PATH]] [-hard]"
    echo "  -copy [PATH]  Optionally copy the .cache directory to the specified PATH."
    echo "               If PATH is not provided, copy to the current directory."
    echo "  -hard        Securely delete files using rmk function."
    exit 1
}
#_#
rmk() {
    scrub -p dod "$1"
    shred -zun 10 -v "$1"
}
#_#
COPY_PATH=""
HARD_DELETE=false
while [[ "$1" != "" ]]; do
    case $1 in
        -copy)
            shift
            if [[ "$1" != "" && "$1" != -* ]]; then
                COPY_PATH="$1"
                shift
            else
                COPY_PATH=$(pwd)
            fi
            ;;
        -hard)
            HARD_DELETE=true
            shift
            ;;
        *)
            usage
            ;;
    esac
done
#_#
CACHE_DIR="/home/b0llull0s/.cache"
#_#
EXCLUDE_DIR="wal"
#_#
TEMP_DIR=$(mktemp -d)
#_#
mv "$CACHE_DIR/$EXCLUDE_DIR" "$TEMP_DIR"
#_#
if [[ "$COPY_PATH" != "" ]]; then
    cp -r "$CACHE_DIR" "$COPY_PATH"
    echo ".cache directory copied to $COPY_PATH."
fi
#_#
if $HARD_DELETE; then
    
    find "$CACHE_DIR"/* -exec rmk {} \;
else
    
    find "$CACHE_DIR"/* -not -path "$CACHE_DIR/$EXCLUDE_DIR/*" -delete
fi
#_#
mv "$TEMP_DIR/$EXCLUDE_DIR" "$CACHE_DIR"
#_#
rmdir "$TEMP_DIR"
#_#
echo "Cache cleared, except for $CACHE_DIR/$EXCLUDE_DIR."
#_#
if $HARD_DELETE; then
    echo "Files were securely deleted using the rmk function."
fi

#  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\ 
# ( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )
#  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ < 
