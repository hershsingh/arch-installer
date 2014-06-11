#!/bin/bash

## Author: Hersh Singh [hershdeep@gmail.com]
## Date: June 11, 2014
## Arch Installer Part #2: System Configuration

## Assumptions:
#  - The base system has been installed using pacstrap.
#  - We have chrooted into /mnt now

## Locale
echo Setting Locale...
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
echo Setting timezone to $AIS_TIMEZONE...
ln -s /usr/share/zoneinfo/$AIS_TIMEZONE /etc/localtime
echo

## Hardware clock
echo Setting the Hardware clock to UTC...
hwclock --systohc --utc
# Use the following for localtime (discouraged, used by Windows)
# hwclock --systohv --localtime
echo

## Kernel Modules
# We'll go with the defaults for now.

## Hostname
AIS_HOST=dabba
echo Setting hostname as $AIS_HOST
echo $AIS_HOST > /etc/hostname
echo Remember to add this hostname to /etc/hosts.
echo

## Network
# We need to set up the network for the base system at this point. Maybe its better 
# to shift this step to the top, so that no manual intervention is required for this script.

## Initial Ramdisk Environment
echo Creating an initial ramdisk environment...
echo Edit the /etc/mkinitcpio.conf file
echo If you are installing this on a USB drive, put block right after udev in the HOOKS array.
read -p "Press any key to continue..  " 
nano /etc/mkinitcpio.conf
mkinitcpio -p linux
echo

## Root password
echo Setting the root password...
passwd

## Bootloader
echo Installing the bootloader syslinux...
pacman -S syslinux
syslinux-install_update -i -a -m
echo I will now open /boot/syslinux/syslinux.cfg for you.
echo You need to edit it to point to the correct root partition.
read -p "Press any key to continue..  " 
nano /boot/syslinux/syslinux.cfg
echo 

## Unmount and reboot
echo Exiting from chroot environment...
exit
echo Unmounting base system...
umount -R /mnt
echo

## Should install the other packages now...
# 
