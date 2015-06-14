#!/bin/bash

## Author: Hersh Singh [hershdeep@gmail.com]
## Date: June 11, 2014
## Arch Installer Part #1: The Beginnings...

## Assumptions:
#	- System is booted using archboot iso with a working internet connection.
#   - All required partition (/, /boot, /home,...) have been mounted inside /mnt.
#   If this script is being executed from an arch system with arch-installer-scripts, please add the arch-installer-scripts to $PATH
#   PATH=$PATH:$(pwd)

# Script Configuration
source arch-install-preamble.sh

header "Arch Linux Installer [Script I - Base Install]"
note "I will assume that you have partitioned the system and mounted the base partition on $AIS_MNT."
echo
header "Checking network..."
if ! ping -c 3 8.8.8.8 ; then
    note "There seems to be some problem with your network. Please ensure that you have a working internet connection and try again."
    exit 1
else
    note "We have a working network. Beginning the install process..."
fi

read -p "Do you wish to (C)ontinue/e(x)it? " -n 1 -r
echo
if [[ $REPLY =~ ^[Xx]$ ]] ; then
	exit 0
fi
echo

# Configure the mirrorlist.
header "Step 1: Configure Mirrorlist"
read -p "Do you want to open the mirrorlist now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    (set -x; 
    $EDITOR /etc/pacman.d/mirrorlist
    )
fi
echo

# Install the base and base-devel (for ABS) packages
header "Step 2: Install the base system."
note "We will now install the base packages in $AIS_MNT using pacstrap."
read -p "Do you wish to (c)ontinue/(S)kip/e(x)it? " -n 1 -r
echo
if [[ $REPLY =~ ^[Xx]$ ]] ; then
	exit 0
elif [[ $REPLY =~ ^[Cc]$ ]] ; then
    (set -x; 
    pacstrap -i $AIS_MNT base base-devel
    )
fi
echo

# Generate fstab
header "Step 3: Fstab"
note "I will now generate fstab for you."
read -p "Do you wish to (c)ontinue/(S)kip/e(x)it? " -n 1 -r
echo
if [[ $REPLY =~ ^[Xx]$ ]] ; then
	exit 0
elif [[ $REPLY =~ ^[Cc]$ ]] ; then
    note Generating and installing fstab...
    (set -x; 
    mkdir -p $AIS_MNT/etc
    genfstab -U -p $AIS_MNT >> $AIS_MNT/etc/fstab
    )
    note "You should check the generated fstab. I am opening it for you."
    read -p "Press any key to continue...  " 
    (set -x;
    $EDITOR $AIS_MNT/etc/fstab
    )
fi
echo

# chroot into the base system
header "Step 4: Chroot"
note "We are now ready to chroot into the newly installed system to configure it. "
note "Please run Part Two of the arch installer script after chrooting."
read -p "Do you wish to (c)ontinue/(S)kip/e(x)it? " -n 1 -r
echo
if [[ $REPLY =~ ^[Xx]$ ]] ; then
	exit 0
elif [[ $REPLY =~ ^[Cc]$ ]] ; then
    note Chrooting into the base system...
    arch-chroot $AIS_MNT /bin/bash
fi
