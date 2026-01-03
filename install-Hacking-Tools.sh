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
install_packages net-snmp finalrecon qflipper-bin nmap openbsd-netcat rlwrap mariadb john feroxbuster impacket metasploit exploitdb proxychains-ng oath-toolkit bind sqlmap wpscan sherlock sqlite chromium tftp-hpa zaproxy hashcat nasm strace

# Python
install_packages python-pwntools python-aiosmtpd python-websocket-client python-bs4 python-requests python-beautifulsoup4 python-pexpect python-selenium python-pycryptodome

# Go 
go install github.com/sensepost/gowitness@latest
go install github.com/CodeOne45/vex-tui@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# Yay Packages
install_packages_yay ffuf gobuster burpsuite smbmap naabu netexec ruby-evil-winrm whatweb steghide pince git-dumper-git caido-desktop rustscan hashid

# Posting
curl -LsSf https://astral.sh/uv/install.sh | sh
