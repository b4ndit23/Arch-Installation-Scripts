#!/bin/bash

echo "Installing UUP Dump dependencies for Arch Linux..."

sudo pacman -S --needed aria2 cabextract wimlib chntpw cdrtools mtools

echo "All dependencies installed!"
echo "You can now run UUP Dump scripts to download Windows ISOs."
