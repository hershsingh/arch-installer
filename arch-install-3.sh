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
note() {
    echo ${textblue}$@${textreset}
}
header() {
    echo ${textred}$@${textreset}
}

# Print script information
header "Arch Linux Installer [Script III - Post Installation]"
note "It is assumed that the base system has been installed and rebooted once."
note "Please ensure that you have a working internet connection."
echo 

# Install all interesting packages
header "Step 1: Interesting Packages"
note "I shall install all the interesting packages now."
read -p "Do you wish to (c)ontinue/(s)kip/e(x)it? " -n 1 -r
echo
if [[ $REPLY =~ ^[Xx]$ ]] ; then
	exit
elif [[ $REPLY =~ ^[Cc]$ ]] ; then
	pacman -S $(sed 's/#.*$//' packages.txt)
fi
echo

# Setup sudo 
header "Step 2: Setup sudo"
note "I will open \"sudoers\" file for you. You need to allow the wheel group to execute sudo commands."
read -p "Do you wish to (c)ontinue/(s)kip/e(x)it? " -n 1 -r
echo
if [[ $REPLY =~ ^[Xx]$ ]] ; then
	exit
elif [[ $REPLY =~ ^[Cc]$ ]] ; then
	visudo
fi
echo

# Users and Groups
# Setup one main user account.
header "Step 3: Users and Groups"
AIS_USER=hersh
note "I will now add the main user $AIS_USER and make it a member of group \"wheel\"."
read -p "Do you wish to (c)ontinue/(s)kip/e(x)it? " -n 1 -r
echo
if [[ $REPLY =~ ^[Xx]$ ]] ; then
	exit
elif [[ $REPLY =~ ^[Cc]$ ]] ; then
	note "Adding user $AIS_USER..."
	useradd -m -G wheel -s /bin/bash $AIS_USER
	note "Please enter a password for this user..."
	passwd $AIS_USER
fi

## Switch to $AIS_USER
## Setup the dotfiles from a github repository
header "Step 4: Dotfiles for $AIS_USER"
echo I will get the dotfiles from the github repository and install them. 
read -p "Do you wish to (c)ontinue/(s)kip/e(x)it? " -n 1 -r
echo
if [[ $REPLY =~ ^[Xx]$ ]] ; then
	exit
elif [[ $REPLY =~ ^[Cc]$ ]] ; then
	echo Switching to user $AIS_USER...
	su $AIS_USER -c 'cd $HOME && git clone https://github.com/hershsingh/dotfiles.git && $HOME/dotfiles/bootstrap.sh'
fi

# Install stuff from AUR
ai-aur() {
    curl aur.sh > aur.sh
    chmod +x aur.sh
    # powerline-fonts-git
    # batterymon-clone
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

