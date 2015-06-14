#!/bin/bash

## Author: Hersh Singh [hershdeep@gmail.com]
## Arch Installer Script Configuration

# Script configuration
AIS_MNT=/mnt
AIS_TIMEZONE=US/Eastern
AIS_HOST=dabba
AIS_USER=hersh

# Global configuration
export EDITOR=vi

# Define colors for 'tput'
textrev=$(tput rev)
textred=$(tput setaf 1)
textblue=$(tput setaf 4)
textreset=$(tput sgr0)

# Functions to display messages
note() {
    echo ${textblue}$@${textreset}
}
header() {
    echo ${textred}$@${textreset}
}
