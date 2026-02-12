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
install_packages binwalk aircrack-ng navi ipcalc exiftool hydra checksec net-snmp finalrecon qflipper-bin nmap openbsd-netcat rlwrap mariadb john feroxbuster impacket metasploit exploitdb proxychains-ng oath-toolkit bind sqlmap wpscan sherlock sqlite chromium tftp-hpa zaproxy hashcat nasm strace

# Python
install_packages python-pwntools python-aiosmtpd python-websocket-client python-bs4 python-requests python-beautifulsoup4 python-pexpect python-selenium python-pycryptodome

# Go 
go install github.com/sensepost/gowitness@latest
go install github.com/CodeOne45/vex-tui@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# Yay Packages
install_packages_yay ffuf gobuster burpsuite smbmap naabu netexec ruby-evil-winrm whatweb steghide pince git-dumper-git caido-desktop rustscan hashid python-oletools detect-it-easy responder

# Posting
curl -LsSf https://astral.sh/uv/install.sh | sh
# GEF
bash -c "$(curl -fsSL https://gef.blah.cat/sh)"

#  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\ 
# ( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )
#  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ < 
