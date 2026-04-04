#!/bin/bash

#  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\ 
# ( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )
#  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ < 

error_exit() {
    echo "$1" 1>&2
    exit 1
}

install_packages() {
    for package in "$@"; do
        if ! pacman -Q "$package" &>/dev/null; then
            sudo pacman -Sy --noconfirm "$package" || error_exit "Failed to install $package"
        fi
    done
}

install_packages_yay() {
    for package in "$@"; do
        if ! yay -Q "$package" &>/dev/null; then
            yay -Sy --noconfirm "$package" || error_exit "Failed to install $package"
        fi
    done
}

enable_services() {
    for service in "$@"; do
        sudo systemctl enable --now "$service" || error_exit "Failed to enable $service"
    done
}

# Packages
install_packages binwalk finalrecon qflipper-bin openbsd-netcat rlwrap impacket metasploit proxychains-ng oath-toolkit bind nasm strace

# Protocols
install_packages freerdp net-snmp tftp-hpa

# Utility
install_package navi ipcalc csvlens 

# Bruteforcing
install_package john feroxbuster hydra hashcat

# Scanners
install_package wpscan sherlock nmap

# Databases
install_packages exploitdb sqlmap mariadb sqlite

# Wifi
install_packages macchanger bettercap aircrack-ng

# Stego
install_packages exiftool 

# Yay Packages
install_packages_yay ffuf gobuster burpsuite smbmap naabu netexec ruby-evil-winrm whatweb steghide pince git-dumper-git caido-desktop rustscan hashid python-oletools detect-it-easy responder

# Python
install_packages python-pwntools python-aiosmtpd python-websocket-client python-bs4 python-requests python-beautifulsoup4 python-pexpect python-selenium python-pycryptodome

# Go 
go install github.com/sensepost/gowitness@latest
go install github.com/CodeOne45/vex-tui@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# Posting
curl -LsSf https://astral.sh/uv/install.sh | sh

# GEF
bash -c "$(curl -fsSL https://gef.blah.cat/sh)"

# Penelope
wget https://raw.githubusercontent.com/brightio/penelope/refs/heads/main/penelope.py && python3 penelope.py

#  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\ 
# ( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )
#  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ < 
