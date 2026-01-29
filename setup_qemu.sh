#!/bin/bash

# QEMU & Libvirt Setup Script for Arch Linux
# This script installs and configures everything needed to run Windows 11 in Virt-Manager

echo "--- Starting QEMU/Libvirt Setup ---"

# 1. Install necessary packages
echo "[*] Installing QEMU, Virt-Manager, and Windows 11 dependencies..."
sudo pacman -S --needed --noconfirm \
    qemu-base \
    qemu-desktop \
    virt-manager \
    virt-viewer \
    dnsmasq \
    iptables-nft \
    swtpm \
    edk2-ovmf

# 2. Add current user to libvirt group for permission
echo "[*] Adding $USER to libvirt group..."
sudo usermod -aG libvirt $USER

# 3. Enable and start libvirt daemon
echo "[*] Starting and enabling libvirtd service..."
sudo systemctl enable --now libvirtd

# 4. Set up default network if it doesn't exist
echo "[*] Ensuring default network is active..."
sudo virsh net-start default 2>/dev/null
sudo virsh net-autostart default 2>/dev/null

echo ""
echo "--- Setup Complete! ---"
echo "IMPORTANT: You MUST log out and log back in (or reboot) for the group changes to take effect."
echo "After logging back in, you can launch 'virt-manager' to start creating your Windows 11 VM."
