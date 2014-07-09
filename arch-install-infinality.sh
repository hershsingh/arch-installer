# Add the infinality-bundle repository.
#$PACMANCONF=/etc/pacman.conf
PACMANCONF=newfile
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

# Add the unofficial keys.
echo Adding the keys for the infinality repository...
$KEYID=962DDE58
pacman-key -r $KEYID # Add key
pacman-key -f $KEYID # Verify key fingerprint
pacman-key --lsign-key $KEYID # Locally sign the key
echo

# Update pacman database and install infinality.
pacman -Sy && pacman -S infinality-bundle
