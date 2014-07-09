#!/bin/bash

## Author: Hersh Singh [hershdeep@gmail.com]
## Date: June 11, 2014
## Arch Installer Part #3: Post-Installation

## Assumptions:
#   - The system has been installed along with the bootloader.
#   - System has been rebooted once.
#   - Network has been configured. 

## Preamble
# Define colors for 'tput'
textrev=$(tput rev)
textblue=$(tput setaf 1)
textred=$(tput setaf 4)
textreset=$(tput sgr0)

# Print script information
echo ${textrev}Arch Linux Installer [Script III - Post Installation]${textreset}
echo ${textred}It is assumed that the base system has been installed and rebooted once.${textreset}
echo ${textred}Please ensure that you have a working internet connection. ${textreset}

# Install all interesting packages
echo 
echo ${textblue}Step 1: Interesting Packages ${textreset}
echo I shall install all the interesting packages now. 
read -p "Do you wish to (c)ontinue/(s)kip/e(x)it? " -n 1 -r
echo
if [[ $REPLY =~ ^[Xx]$ ]] ; then
	exit
elif [[ $REPLY =~ ^[Cc]$ ]] ; then
	pacman -S $(grep -v '^#' packages-usb.txt)
fi
echo

# Setup sudo 
echo ${textblue}Step 2: Setup sudo${textreset}
echo I will open sudoers config file for you. You need to allow the wheel group to execute sudo commands.
read -p "Do you wish to (c)ontinue/(s)kip/e(x)it? " -n 1 -r
echo
if [[ $REPLY =~ ^[Xx]$ ]] ; then
	exit
elif [[ $REPLY =~ ^[Cc]$ ]] ; then
	sudo visudo
fi
echo

# Users and Groups
# Setup one main user account.
echo ${textblue}Step 3: Users and Groups${textreset}
AIS_USER=hersh
echo I will now add the main user $AIS_USER.
read -p "Do you wish to (c)ontinue/(s)kip/e(x)it? " -n 1 -r
echo
if [[ $REPLY =~ ^[Xx]$ ]] ; then
	exit
elif [[ $REPLY =~ ^[Cc]$ ]] ; then
	echo Adding user $AIS_USER...
	useradd -m -G wheel -s /bin/bash $AIS_USER
	echo Please enter a password for this user...
	passwd $AIS_USER
fi

## Switch to $AIS_USER
## Setup the dotfiles from a github repository
echo ${textblue}Step 4: Dotfiles for $AIS_USER ${textreset}
echo I will get the dotfiles from the github repository and install them. 
read -p "Do you wish to (c)ontinue/(s)kip/e(x)it? " -n 1 -r
echo
if [[ $REPLY =~ ^[Xx]$ ]] ; then
	exit
elif [[ $REPLY =~ ^[Cc]$ ]] ; then
	echo Switching to user $AIS_USER...
	su $AIS_USER -c 'cd $HOME && git clone https://github.com/hershsingh/dotfiles.git && $HOME/dotfiles/bootstrap.sh'
fi

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

