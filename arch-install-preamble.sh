## Preamble
# Define colors for 'tput'
textrev=$(tput rev)
textred=$(tput setaf 1)
textblue=$(tput setaf 4)
textreset=$(tput sgr0)
note() {
    echo ${textblue}$@${textreset}
}
header() {
    echo ${textred}$@${textreset}
}
