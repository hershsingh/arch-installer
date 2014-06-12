#!/bin/bash

## Author: Hersh Singh [hershdeep@gmail.com]
## Date: June 11, 2014
## Arch Installer Part #1: The Beginnings...

## Assumptions:
#	- System is booted using archboot iso with a working internet connection.
#   - All required partition (/, /boot, /home,...) have been mounted inside /mnt.
#   If this script is being executed from an arch system with arch-installer-scripts, please add the arch-installer-scripts to $PATH
#   PATH=$PATH:$(pwd)

AIS_MNT=/mnt

echo I will assume that you have partitioned the system and mounted the base partition on $AIS_MNT
echo Please ensure that you have a working internet connection.
read -p "Press any key to continue..."

# Configure the mirrorlist.
echo The first step is to configure to mirror list. 
read -p "Do you want to open it now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    $EDITOR /etc/pacman.d/mirrorlist
fi

# Install the base and base-devel (for ABS) packages
echo Installing the base packages in /mnt using pacstrap...
pacstrap -i $AIS_MNT base base-devel
echo

# Generate fstab
echo Generating and installing fstab...
mkdir -p $AIS_MNT/etc
genfstab -U -p $AIS_MNT >> $AIS_MNT/etc/fstab
echo You should check the generated fstab. I am opening it for you.
read -p "Press any key to continue...  " 
$EDITOR $AIS_MNT/etc/fstab
echo

# chroot into the base system
echo Chrooting into the base system...
arch-chroot $AIS_MNT /bin/bash
