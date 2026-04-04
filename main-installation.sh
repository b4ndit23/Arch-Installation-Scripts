#!/bin/bash
#  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\ 
# ( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )
#  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ < 
SCRIPT_DIR=$(dirname "$(realpath "$0")")
# Functions
error_exit() {
    echo "$1" 1>&2
    exit 1
}

install_packages() {
    for package in "$@"; do
        if ! pacman -Q "$package" &>/dev/null; then
            sudo pacman -S --noconfirm "$package" || error_exit "Failed to install $package"
        fi
    done
}

install_packages_yay() {
    for package in "$@"; do
        if ! yay -Q "$package" &>/dev/null; then
            yay -S --noconfirm "$package" || error_exit "Failed to install $package"
        fi
    done
}

enable_services() {
    for service in "$@"; do
        sudo systemctl enable --now "$service" || error_exit "Failed to enable $service"
    done
}

# Firewall setup
install_packages ufw
sudo ufw enable || error_exit "Failed to enable UFW"
enable_services ufw.service

# Install Hyprland
install_packages hyprland ly

# Home directories setup
mkdir -p ~/Downloads ~/Screenshots || error_exit "Failed to create directories"

# Install Black Arch Basics
#curl -fsSL https://blackarch.org/strap.sh | sudo bash || error_exit "Failed to enable Black Arch repo"

# Enable BlackArch repository
echo -e "\n\033[1;35mEnabling BlackArch repository (lean mode – no tools installed yet)...\033[0m"

# Import and trust the official BlackArch master key
sudo pacman-key --keyserver keyserver.ubuntu.com --recv-keys 4345771566D76038C7FEB43863EC0ADBEA87E4E3 || error_exit "Failed to recv BlackArch master key"
sudo pacman-key --lsign-key 4345771566D76038C7FEB43863EC0ADBEA87E4E3 || error_exit "Failed to lsign BlackArch master key"

# Download and install only the keyring
curl -fsSLO https://blackarch.org/keyring/blackarch-keyring.pkg.tar.zst || error_exit "Failed to download blackarch-keyring"
sudo pacman -U --noconfirm blackarch-keyring.pkg.tar.zst || error_exit "Failed to install blackarch-keyring"
rm -f blackarch-keyring.pkg.tar.zst

# Add BlackArch repo to the pacman config file (idempotent)
if ! grep -q '^\[blackarch\]' /etc/pacman.conf; then
    cat <<'EOF' | sudo tee -a /etc/pacman.conf > /dev/null

[blackarch]
Server = https://mirror.blackarch.org/$repo/os/$arch
EOF
    echo "BlackArch repo added to /etc/pacman.conf"
else
    echo "BlackArch repo already present – skipping duplicate entry"
fi

# Refresh databases so BlackArch packages are instantly available
sudo pacman -Syy --noconfirm || error_exit "Failed to refresh package databases (pacman -Syy)"

echo -e "\033[1;32mBlackArch repository enabled successfully! (lean mode)\033[0m"
echo -e "\033[1;33m→ Tools ready! Example: sudo pacman -S nmap sqlmap metasploit hashcat john\033[0m"

# Flatpak
install_packages flatpak
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Yay setup
mkdir -p /tmp/yay_install
cd /tmp/yay_install || error_exit "Failed to enter temp dir"
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si --noconfirm || error_exit "Failed to install yay"
cd /tmp/yay_install
rm -rf yay-git 
cd - || return  

# Mirrors setup
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup || error_exit "Failed to backup mirrorlist"
install_packages reflector
sudo reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist

# PacCache setup
sudo systemctl enable --now paccache.timer || error_exit "Failed to enable paccache.timer"

# Basic
install_packages zsh alacritty wofi curl wget plocate less tree exa bat apparmor whois tcpdump exfatprogs openssh lsof fwupd tinyxxd iw wireless_tools

# Qt
install_packages qt5-wayland qt6-wayland qt6-base qt6-tools qtcreator

# Programming & Development
install_packages cargo go tk geckodriver python-pip python-pywal ncurses cmake pngquant oxipng mkcert

# Media
install_packages cmus pamixer pavucontrol vlc

# Bluetooth
install_packages blueman bluez bluez-utils
enable_services bluetooth

# Utils
install_packages curlie waybar yazi thunar ueberzugpp fzf btop cliphist pam_yubico pam-u2f atool unzip unrar zip sxiv 7zip net-tools openvpn proton-vpn-gtk-app jq timeshift qemu-user perl-image-exiftool firejail docker-compose dosfstools wev brightnessctl macchanger zoxide resvg fd ripgrep

# Graphic Design
install_packages gimp
#blender inkscape kdenlive

# Text Editor/Viewer
install_packages obsidian libreoffice-fresh zathura zathura-pdf-mupdf

# Gaming
install_packages steam
#lutris

# Messengers
install_packages signal-desktop
#thunderbird

# OBS
install_packages obs-studio xdg-desktop-portal-hyprland xdg-desktop-portal-wlr

# Wireshark
install_packages wireshark-qt
sudo usermod -aG wireshark $USER
sudo setcap cap_net_raw,cap_net_admin+eip /usr/bin/dumpcap
#sudo chmod +x /usr/bin/dumpcap || error_exit "Failed to change permissions for dumpcap"

# Screenshots
install_packages grim swappy slurp

# Yay Packages 
install_packages_yay ttf-firacode-nerd hyprland-qtutils swww vscodium-bin librewolf-bin scrub zsh-syntax-highlighting zsh-autosuggestions xpad youtube-music-bin cursor-bin python-pywalfox-librewolf

# Dot Files
cd "$SCRIPT_DIR" || exit 1 
for config_dir in alacritty btop gtk-3.0 gtk-4.0 hypr swappy waybar; do
    if [ -d "$config_dir" ]; then
        cp -r "$config_dir" ~/.config/ || error_exit "Failed to copy $config_dir"
    fi
done

if [ -d "wal" ]; then
    cp -r wal ~/.config/ || error_exit "Failed to copy wal/templates"
fi

# Dark Mode for root
sudo cp ~/.config/gtk-3.0/settings.ini /root/.config/gtk-3.0/settings.ini
sudo cp ~/.config/gtk-4.0/settings.ini /root/.config/gtk-4.0/settings.ini

# Script Permissions
sudo chmod +x ~/.config/hypr/scripts/*.sh || error_exit "Failed to change script permissions"

# OMZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || error_exit "Failed to install oh-my-zsh"

# Set pywal
wal -i ~/Arch-Installation-Scripts/w4llp4p3rs/1.jpg || error_exit "Failed to set pywal"
pywalfox install --browser librewolf || error_exit "Failed to set pywalfox"

# Set Wallpaper
swww img ~/Arch-Installation-Scripts/w4llp4p3rs/1.jpg

# .zshsrc
cp "$SCRIPT_DIR/.zshrc" ~/ || error_exit "Failed to copy .zshrc"

echo "Finished! Please reboot."

#  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\  /\_/\ 
# ( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )( o.o )
#  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ <  > ^ < 
