# TexLive Network Install
# Remember that you NEED TO BE sudo to install this
# The idea is to do a minimal install on a USB drive.

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

    tex_packages=(
        # Base LaTeX
        latex latex-bin latexconfig latex-fonts latexmk 

        # LuaTeX
        fontspec luaotfload euenc xunicode

        # Miscellaneous
        babel       # Internationalization
        parskip     # Paragraph indent and parskip
        units
        geometry
        pdftex-def 

        # Super-packages
        tools
        oberdiek
        mdwtools
        ms
        mh  # Contains breqn package

        # Math
        amsmath amsfonts 
        mathtools
        nicefrac 

        # More symbols
        marvosym 

        # Classes
        amscls 
        standalone

        # Lists
        mdwlist 

        # Cite/Reference
        url
        cite
        hyperref 
        caption 

        # Graphics 
        pgf
        graphics
        xcolor
        # TikZ
        tikz-cd

        # Tables
        booktabs    # Prettier tables
        array       # Make custom columns
        colortbl    # Color tables
        multirow    

        # Bibliography
        biber

        # Better typography
        microtype 

        # Line spacing
        setspace 

        # Fonts
        lm  # Latin modern
        ec  # Computer modern fonts in T1 and TS1 encodings
        bera
        inconsolata # Awesome monospace font
        upquote     # Dependency for Inconsolata 

        # Moderncv and dependencies
        moderncv fancyhdr etoolbox l3packages l3kernel

        # Source code listings
        # Minted, requires python2-pygments
        minted fancyvrb float ifplatform

        # Young diagrams
        youngtab

        # latexdiff
        latexdiff
        ulem
    )
    tlmgr install ${tex_packages[@]}

}

echo ${textblue}TexLive Network Install${textreset}
read -p "Do you wish to (c)ontinue/(s)kip/e(x)it? " -n 1 -r
echo
if [[ $REPLY =~ ^[Xx]$ ]] ; then
	exit
elif [[ $REPLY =~ ^[Cc]$ ]] ; then
    ai_texliveinstall
fi
