#!/bin/bash

## Author: Hersh Singh [hershdeep@gmail.com]
## Date: June 11, 2014
## Arch Installer Part #3: Post-Installation

## Assumptions:
#   - The system has been installed along with the bootloader.
#   - System has been rebooted once.
#   - Network has been configured. 

# Install all interesting packages
pacman -S $(grep -v '^#' packages-usb.txt)

# Setup sudo 
echo Setting sudo command.
echo I will open sudoers config file for you. You need to allow the wheel group to execute sudo commands.
sudo visudo
echo

# Users and Groups
# Setup one main user account.
AIS_USER=hersh
echo Adding user $AIS_USER...
useradd -m -G wheel -s /bin/bash $AIS_USER
echo Please enter a password for this user...
passwd $AIS_USER

## Switch to $AIS_USER
## Setup the dotfiles from a github repository
echo Switching to user $AIS_USER...
su hersh -c 'cd $HOME && git clone https://github.com/hershsingh/dotfiles.git && $HOME/dotfiles/bootstrap.sh'

# Copy the dotfiles now...
# ranger
#   - Copy all the settings
# awesome
#   - Minimal or complete? 
# vim
#	- Run plugin update
# git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
#   - install plugins
# conky
#   - Do I need it here? 
# bashrc, Xresources

# Setup X
#   .xinitrc
#   xmodmap

# AUR
ai-aur() {
    curl aur.sh > aur.sh
    chmod +x aur.sh
    # powerline-fonts-git
    #  
}

# Mounting Internal Partitions
# User needs to be in the 'disk' groups
mount_internal_ntfs_partition() {
    # This needs to be executed as root, but will allow $AIS_USER to read/write.
    gpasswd -a $AIS_USER disk
    mkdir -p /mnt/c /mnt/d
    chown $AIS_USER:$AIS_USER /mnt/c /mnt/d
    mount -t ntfs-3g -o uid=$AIS_USER,gid=$AIS_USER,umask=0022 /dev/sda3
}

# TexLive Network Install
# Remember that you need to be sudo to install this
# The idea is to do a minimal install on a USB drive
ai-texliveinstall() {
    wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
    if [ ! -d install-tl ]; then 
        mkdir -p install-tl && tar -C install-tl --strip-components=1 -xvzf install-tl-unx.tar.gz 
        cd install-tl
        ./install-tl -profile $DOTFILES/texlive.profile
        # Check if PATH variable is set
        if [[ ! ":$PATH:" == *":/usr/local/texlive/2013/bin/i386-linux:"* ]]; then
            export PATH=$PATH:/usr/local/texlive/2013/bin/i386-linux 
            echo 'Please add PATH=$PATH:/usr/local/texlive/2013/bin/i386-linux to your .bashrc' 
        fi
        # Install base LaTeX
        tlmgr install latex latex-bin latexconfig latex-fonts

        # Install some interesting packages
        tlmgr install amsmath amsfonts babel ec geometry graphics hyperref lm  marvosym oberdiek parskip pdftex-def url pgf bera colortbl booktabs mdwlist multirow cite tools mh nicefrac caption mdwtools units xcolor ms amscls 
        
        # Minted Package, requireds python2-pygments
        tlmgr install minted fancyvrb float ifplatform
    fi
}

