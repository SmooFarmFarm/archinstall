#!/bin/bash
set -e  # Exit on error

echo "Updating system..."
sudo pacman -Syu --noconfirm

echo "Installing essential packages..."
sudo pacman -S --needed --noconfirm git nano base-devel flatpak

echo "Installing yay (AUR helper)..."
if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si --noconfirm
    cd ..
    rm -rf yay-bin
else
    echo "yay is already installed."
fi

echo "Enabling Flathub..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install com.spotify.Client org.standardnotes.standardnotes
