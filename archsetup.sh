f#!/bin/bash
set -e  # Exit on error

#####################
echo "Allow sudo for 15 mins"
sudo -v

#####################

# Update system clock
sudo timedatectl set-ntp true

####################

# Install reflector to find the fastest mirrors
sudo pacman -S --noconfirm reflector

# Backup existing mirrorlist
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

# Set the 10 fastest mirrors CANADA
sudo reflector --latest 10 --protocol https --sort rate --country Canada --save /etc/pacman.d/mirrorlist


# Refresh package database
sudo pacman -Syy

###################


# Enable TRIM for SSDs - not needed in virtualbox
# sudo systemctl enable fstrim.timer


##################

echo "Updating system..."
sudo pacman -Syu --noconfirm

###################



# Installing core packages
echo "Installing essential packages..."
sudo pacman -S --needed --noconfirm git nano base-devel flatpak gparted htop inxi obs-studio syncthing linux-headers dnsutils wget curl openssh ntfs-3g exfat-utils f2fs-tools btrfs-progs dosfstools zip unzip p7zip unrar lzop lrzip htop btop nvtop lm_sensors lsof bash-completion neofetch exa bat fd ripgrep fzf xdg-utils gvfs file-roller   
 

##################

# Enable syncthing and enable it even without logging in
systemctl --user enable --now syncthing
loginctl enable-linger $USER


####################

# Installing yay
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

###################


# Enabling Flathub and downloading Flatpak apps
echo "Enabling Flathub..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install com.spotify.Client org.standardnotes.standardnotes org.audacityteam.Audacity org.mozilla.firefox org.chromium.Chromium com.bitwarden.desktop com.calibre_ebook.calibre com.discordapp.Discord io.mpv.Mpv org.videolan.VLC org.qbittorrent.qBittorrent org.kde.kdenlive org.libreoffice.LibreOffice org.kde.krita org.signal.Signal            

##################

# AUR programs
yay -S --noconfirm veracrypt mullvad-vpn-bin


#################

# Set up 'll' alias like Ubuntu
echo 'alias ll="ls -lah --color=auto"' | sudo tee -a /etc/skel/.bashrc /root/.bashrc /home/$USER/.bashrc

# Reload bash config
source /home/$USER/.bashrc


# Replace ls with exa
# alias ls='exa -al --color=always --group-directories-first --icons'     # preferred listing
# alias la='exa -a --color=always --group-directories-first --icons'      # all files and dirs
# alias ll='exa -l --color=always --group-directories-first --icons'      # long format
# alias lt='exa -aT --color=always --group-directories-first --icons'     # tree listing
# alias l.='exa -ald --color=always --group-directories-first --icons .*' # show only dotfiles
