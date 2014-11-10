# Add the infinality-bundle repository.

if [[ $EUID != 0 ]]; then
    echo Please run this script with root access.
    exit 1
fi

PACMANCONF=/etc/pacman.conf

# Check if pacman.conf already has the infinality repo added to it.
if grep -qs "Server\s*=\s*http://bohoomil.com/repo/$arch" $PACMANCONF
then
    echo [infinality-bundle] appears to be in pacman.conf already.
else
    echo Adding the [infinality-bundle] repository...
    cat >> $PACMANCONF <<-"EOF"
[infinality-bundle]
Server = http://bohoomil.com/repo/$arch
EOF
    echo
fi

if grep -qs "Server\s*=\s*http://bohoomil.com/repo/fonts" $PACMANCONF
then
    echo [infinality-bundle-fonts] appears to be in pacman.conf already.
else
    echo Adding the [infinality-bundle-fonts] repository...
    cat >> $PACMANCONF <<-"EOF"
[infinality-bundle-fonts]
Server = http://bohoomil.com/repo/fonts
EOF
    echo
fi

# Add the unofficial keys.
echo Adding the keys for the infinality repository...
KEYID=962DDE58
pacman-key -r $KEYID # Add key
pacman-key -f $KEYID # Verify key fingerprint
pacman-key --lsign-key $KEYID # Locally sign the key
echo

# Update pacman database and install infinality.
pacman -Sy && pacman -S infinality-bundle

# Install infinality fonts bundle
pacman -S ibfonts-meta-base ibfonts-meta-extended
