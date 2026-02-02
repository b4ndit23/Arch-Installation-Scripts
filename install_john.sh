#!/bin/bash

# John the Ripper Installation Script
# Installs from official GitHub repository

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
INSTALL_DIR="$HOME/tools"
JOHN_DIR="$INSTALL_DIR/john"

echo -e "${GREEN}[*] John the Ripper Installation Script${NC}"
echo ""

# Create tools directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}[+] Creating tools directory: $INSTALL_DIR${NC}"
    mkdir -p "$INSTALL_DIR"
fi

# Check if John already exists
if [ -d "$JOHN_DIR" ]; then
    echo -e "${YELLOW}[!] John the Ripper directory already exists${NC}"
    read -p "Do you want to update it? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${GREEN}[+] Updating John the Ripper...${NC}"
        cd "$JOHN_DIR"
        git pull
    else
        echo -e "${RED}[!] Installation cancelled${NC}"
        exit 0
    fi
else
    echo -e "${GREEN}[+] Cloning John the Ripper repository...${NC}"
    cd "$INSTALL_DIR"
    git clone https://github.com/openwall/john.git
fi

# Build John
echo -e "${GREEN}[+] Building John the Ripper...${NC}"
cd "$JOHN_DIR/src"

echo -e "${YELLOW}[+] Running configure...${NC}"
./configure

echo -e "${YELLOW}[+] Compiling (this may take a while)...${NC}"
make -s clean && make -sj4

# Check if build was successful
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}[✓] John the Ripper installed successfully!${NC}"
    echo ""
    echo -e "${YELLOW}Installation location:${NC} $JOHN_DIR"
    echo -e "${YELLOW}Binary location:${NC} $JOHN_DIR/run/john"
    echo ""
    echo -e "${YELLOW}[+] To use John, you can:${NC}"
    echo "    1. Run directly: $JOHN_DIR/run/john"
    echo "    2. Add to PATH: export PATH=\"\$PATH:$JOHN_DIR/run\""
    echo "    3. Create an alias: alias john='$JOHN_DIR/run/john'"
    echo ""
    
    # Offer to add to PATH
    read -p "Do you want to add John to your PATH in ~/.bashrc? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "" >> ~/.bashrc
        echo "# John the Ripper" >> ~/.bashrc
        echo "export PATH=\"\$PATH:$JOHN_DIR/run\"" >> ~/.bashrc
        echo -e "${GREEN}[✓] Added to ~/.bashrc${NC}"
        echo -e "${YELLOW}[!] Run 'source ~/.bashrc' or restart your terminal${NC}"
    fi
else
    echo -e "${RED}[✗] Build failed!${NC}"
    exit 1
fi
