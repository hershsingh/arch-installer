#!/bin/bash

## Author: Hersh Singh [hershdeep@gmail.com]
## Date: June 11, 2014
## Arch Installer Part #1: The Beginnings...

## Assumptions:
#	- System is booted using archboot iso with a working internet connection.
#   - All required partition (/, /boot, /home,...) have been mounted inside /mnt.

# Install the base and base-devel (for ABS) packages
echo I hope you have configured the mirrorlist. 
echo Installing the base packages in /mnt now...
pacstrap -i /mnt base base-devel
echo

# Generate fstab
echo Generating fstab...
genfstab -U -p /mnt >> /mnt/etc/fstab
echo You should check the generated fstab. I am opening it for you.
read -p "Press any key to continue..  " 
echo

# chroot into the base system
echo Chrooting into the base system...
arch-chroot /mnt /bin/bash
