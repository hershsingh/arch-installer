# TexLive Network Install
# Remember that you NEED TO BE sudo to install this
# The idea is to do a minimal install on a USB drive

# Check for root access
if [[ $EUID != 0 ]]; then
    echo Please run this script with root access.
    exit 1
fi


## Preamble
# Define colors for 'tput'
textrev=$(tput rev)
textblue=$(tput setaf 1)
textred=$(tput setaf 4)
textreset=$(tput sgr0)

ai_texliveinstall() {
    if [ ! -f install-tl-unx.tar.gz ]
    then
        wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
    fi

    if [ ! -d install-tl ]; then 
        mkdir -p install-tl && tar -C install-tl --strip-components=1 -xvzf install-tl-unx.tar.gz 
    fi

    cd install-tl
    ./install-tl -profile ../texlive.profile
    # Check if PATH variable is set
    if [[ ! ":$PATH:" == *":/usr/local/texlive/2013/bin/x86_64-linux:"* ]]; then
        export PATH=$PATH:/usr/local/texlive/2013/bin/x86_64-linux 
        echo 'Please add PATH=$PATH:/usr/local/texlive/2013/bin/x86_64-linux to your .bashrc' 
    fi
    # Install base LaTeX
    tlmgr install latex latex-bin latexconfig latex-fonts latexmk

    # Install some interesting packages
    tlmgr install amsmath amsfonts babel ec geometry graphics hyperref lm  marvosym oberdiek parskip pdftex-def url pgf bera colortbl booktabs mdwlist multirow cite tools mh nicefrac caption mdwtools units xcolor ms amscls 
    
    # Minted Package, requireds python2-pygments
    tlmgr install minted fancyvrb float ifplatform
}

echo ${textblue}TexLive Network Install${textreset}
read -p "Do you wish to (c)ontinue/(s)kip/e(x)it? " -n 1 -r
echo
if [[ $REPLY =~ ^[Xx]$ ]] ; then
	exit
elif [[ $REPLY =~ ^[Cc]$ ]] ; then
    ai_texliveinstall
fi
