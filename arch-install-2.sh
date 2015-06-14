#!/bin/bash

## Author: Hersh Singh [hershdeep@gmail.com]
## Arch Installer Part #2: System Configuration

# Preamble
source arch-install-preamble.sh

# Print script information
header "Arch Linux Installer [Script II - Configuration]"
note "This script is assumed to run from a chroot jail, where the base system has been installed using pacstrap."
echo

# The configuration begins here...

## Locale
header "Step 1: Locale" 
note "I will set the locale now."
read -p "Do you wish to (c)ontinue/(S)kip/e(x)it? " -n 1 -r
echo
if [[ $REPLY =~ ^[Xx]$ ]] ; then
	exit 0
elif [[ $REPLY =~ ^[Cc]$ ]] ; then
    (set -x; 

    # Set the correct Locale
    mv /etc/locale.gen /etc/locale.gen.backup;
    echo en_US.UTF-8 UTF-8 > /etc/locale.gen 

    # Generate the locale
    locale-gen
    echo LANG=en_US.UTF-8 > /etc/locale.conf
    export LANG=en_US.UTF-8
    )
fi
echo

## Console font and keymap
# Ignore this for now.

## Time zone
header "Step 2: Time Zone"
note "I will set the time zone to $AIS_TIMEZONE"
read -p "Do you wish to (c)ontinue/(S)kip/e(x)it? " -n 1 -r
echo
if [[ $REPLY =~ ^[Xx]$ ]] ; then
	exit 0
elif [[ $REPLY =~ ^[Cc]$ ]] ; then
    note "Setting timezone to $AIS_TIMEZONE..."
    (set -x; 
    ln -s /usr/share/zoneinfo/$AIS_TIMEZONE /etc/localtime
    )
fi
echo

## Hardware clock
header "Step 3: Hardware Clock" 
note "Setting the Hardware clock to UTC..."
(set -x;
hwclock --systohc --utc
)
# Use the following for localtime (discouraged, used by Windows)
# hwclock --systohv --localtime
echo

## Kernel Modules
header "Step 4: Kernel Modules" 
note "We'll go with the defaults for now. Skipping this step..."
echo

## Hostname
header "Step 5: Hostname" 
note "Setting hostname as ${AIS_HOST}..."
echo $AIS_HOST > /etc/hostname
note You should add this hostname to /etc/hosts.
read -p "Do you want to edit /etc/hosts? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    (set -x; 
    $EDITOR /etc/hosts
    )
fi
echo

## Initial Ramdisk Environment
header "Step 6: Initial Ramdisk Environment"
note "You may want to edit /etc/mkinitcpio.conf. This is usually not required."
note "However, if you are installing this on a USB drive, you need to put \"block\" right after \"udev\" in the HOOKS array."
read -p "Do you want to edit mkinitcpio.conf now? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    (set -x; 
    $EDITOR /etc/mkinitcpio.conf
    mkinitcpio -p linux
    )
fi
echo

## Root password
header "Step 7: Root Password" 
note "Please enter a password for the root account."
(set -x; 
passwd
)
echo

## Bootloader
ai_bootloader () {
    pacman -S syslinux
    syslinux-install_update -i -a -m

    note "I will now open /boot/syslinux/syslinux.cfg for you."
    note "You need to edit it to point to the correct root partition."
    note "Remember to use UUID. You may use the following command to get the UUID of a partition: "
    note "  blkid -s UUID -o value /dev/sdx1"
    read -p "Press any key to continue..  " 
    $EDITOR /boot/syslinux/syslinux.cfg
    note The bootloader has been installed. 
    echo
}

header "Step 8: Bootloader"
note "I will install the bootloader Syslinux now." 
read -p "Do you wish to (c)ontinue/(S)kip/e(x)it? " -n 1 -r
echo
if [[ $REPLY =~ ^[Xx]$ ]] ; then
	exit 0
elif [[ $REPLY =~ ^[Cc]$ ]] ; then
    header Checking network...
    if ! ping -c 3 8.8.8.8 ; then
        note "There seems to be some problem with your network. Please ensure that you have a working internet connection and try again."
        exit 1
    else
        note "We have a working network. Proceeding to install the bootloader..." 
        ai_bootloader
    fi
fi
echo

###########################
header "Epilogue"
note "
- This may be a good time to install something else too. 
- For instance, you may want to ensure that the network would work after
  rebooting. 
- To make your life easier, install the packages wpa_supplicant and dialog for
  WiFi.  
- After you are done, you may proceed to exit from chroot, unmount the newly
  installed root partition and reboot.  
- To transform this bare bones installation to an complete and awesome linux
  system, run the Arch Installer Script III after you reboot."

## Unmount and reboot
#echo Exiting from chroot environment...
#exit
#echo Unmounting base system...
#umount -R /mnt
#echo
