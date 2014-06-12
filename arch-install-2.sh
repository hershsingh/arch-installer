#!/bin/bash

## Author: Hersh Singh [hershdeep@gmail.com]
## Date: June 11, 2014
## Arch Installer Part #2: System Configuration

## Assumptions:
#  - The base system has been installed using pacstrap.
#  - We have chrooted into /mnt now

## Preamble
# Define colors for 'tput'
textrev=$(tput rev)
textblue=$(tput setf 1)
textred=$(tput setf 4)
textreset=$(tput sgr0)
# Print script information
echo ${rev}Arch Linux Installer [Script II - Configuration]${textreset}
echo ${textred}Note: This script should be run from a chroot jail, where the base system has been installed using pacstrap.${textreset}

# The configuration begins here...

## Locale
echo ${textblue}Setting Locale...${textreset}
echo

# Set the correct Locale
mv /etc/locale.gen /etc/locale.gen.backup
echo en_US.UTF-8 UTF-8 > /etc/locale.gen
# Generate the locale
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8
echo

## Console font and keymap
# Ignore this for now.

## Time zone
AIS_TIMEZONE=Asia/Calcutta
echo ${textblue}Setting timezone to $AIS_TIMEZONE...${textreset}
ln -s /usr/share/zoneinfo/$AIS_TIMEZONE /etc/localtime
echo

## Hardware clock
echo ${textblue}Setting the Hardware clock to UTC...${textreset}
hwclock --systohc --utc
# Use the following for localtime (discouraged, used by Windows)
# hwclock --systohv --localtime
echo

## Kernel Modules
# We'll go with the defaults for now.

## Hostname
AIS_HOST=dabba
echo ${textblue}Setting hostname as ${AIS_HOST}${textreset}
echo $AIS_HOST > /etc/hostname
echo ${textred}You should add this hostname to /etc/hosts.${textreset}
read -p "Do you want to edit /etc/hosts? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    $EDITOR /etc/hosts
fi
echo

## Network
# We need to set up the network for the base system at this point. Maybe its better 
# to shift this step to the top, so that no manual intervention is requitextred for this script.

## Initial Ramdisk Environment
echo ${textblue}Creating an initial ramdisk environment...${textreset}
echo You may want to edit /etc/mkinitcpio.conf. This is usually not requitextred.
echo However, if you are installing this on a USB drive, put \"block\" right after \"udev\" in the HOOKS array.
read -p "Do you want to edit mkinitcpio.conf now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    $EDITOR /etc/mkinitcpio.conf
    mkinitcpio -p linux
fi
echo

## Root password
echo ${textblue}Setting the root password...${textreset}
echo Please enter a password for the root account. 
passwd
echo

## Bootloader
ai-install_bootloader () {
    echo ${textblue}Installing the bootloader: syslinux...${textreset}
    pacman -S syslinux
    syslinux-install_update -i -a -m
    echo I will now open /boot/syslinux/syslinux.cfg for you.
    echo You need to edit it to point to the correct root partition.
    read -p "Press any key to continue..  " 
    $EDITOR /boot/syslinux/syslinux.cfg
    echo The bootloader has been installed. 
    echo
    echo ${textblue}This may be a good time to install something else too. Otherwise, please proceed to exit from chroot, unmount the root partition and reboot.${textreset}

}

## Check Network for the newly installed system.
echo ${textblue}Checking if the network is up...${textreset}
if ping -c 3 8.8.8.8; then
    echo We have a working internet connection. Proceeding to install the bootloader.
    echo
    ai-install_bootloader
else
    echo ${textred}There seems to be a problem with the internet connection. Please configure the network properly.${textreset}
    echo ${textblue}Once you have a working network connection, you may run ${textrev}ai-install_boatloader${textreset}${textblue} to complete the installation.${textreset}
fi

## Unmount and reboot
#echo Exiting from chroot environment...
#exit
#echo Unmounting base system...
#umount -R /mnt
#echo
