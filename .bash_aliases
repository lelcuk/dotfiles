alias ssh='ssh -X'

alias lessh='LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s" less -R '
#alias updater='gnome-terminal -- apt-dater'
alias updater='rxvt -e apt-dater'

# Set got bare ripo for dotfiles
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

