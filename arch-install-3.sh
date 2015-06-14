#!/bin/bash

## Author: Hersh Singh [hershdeep@gmail.com]
## Arch Installer Part #3: Post-Installation

## Assumptions:
#   - The system has been installed along with the bootloader.
#   - System has been rebooted once.
#   - Network has been configured. 

## Script configuration
source arch-install-preamble.sh

# Setup sudo 
header "Step 2: Setup sudo"
note "I will open \"sudoers\" file for you. You need to allow the wheel group to execute sudo commands."
read -p "Do you wish to (c)ontinue/(s)kip/e(x)it? " -n 1 -r
echo
if [[ $REPLY =~ ^[Xx]$ ]] ; then
	exit
elif [[ $REPLY =~ ^[Cc]$ ]] ; then
    (visudo)
fi
echo

# Users and Groups
# Setup one main user account.
header "Step 3: Users and Groups"
note "I will now create the user \"$AIS_USER\" and make it a member of group \"wheel\"."
read -p "Do you wish to (c)ontinue/(s)kip/e(x)it? " -n 1 -r
echo
if [[ $REPLY =~ ^[Xx]$ ]] ; then
	exit
elif [[ $REPLY =~ ^[Cc]$ ]] ; then
	note "Adding user $AIS_USER..."
    (useradd -m -G wheel -s /bin/bash $AIS_USER)
	note "Please enter a password for this user..."
    (passwd $AIS_USER)
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
	su $AIS_USER -c 'cd $HOME && 
        git clone https://github.com/hershsingh/dotfiles.git && 
        $HOME/dotfiles/bootstrap.sh'
fi

# AUR Packages
header "Step 5: AUR Packages"
read -p "Do you wish to install AUR packages? (y/N)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    (bash <(curl aur.sh) -si powerline-fonts-git)
fi
echo
