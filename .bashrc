# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

#######################################################################
# Some platform and architecture data we will need later
#
arch=$(uname -m)
# Linux, MacOs or some varient of Cygwin
platform=$(uname -s) # Linux, Darwin and CYGWIN*|MINGW32*|MSYS*|MINGW*
# are we on WSL/WSL2
if grep -qEi "(microsoft|WSL)" /proc/version &> /dev/null ; then
    platform="$platform-WSL"
fi


case "$platform" in
    Linux*)
        GNU_PRE=""
        DIRCOLORS="/usr/bin/dircolors"
        POWERLINE_B="/usr/share/powerline/bindings/bash/powerline.sh"
        ;;&
    *WSL)
        # Specific wsl overwrits for the standard Linux settings
        np () { /mnt/c/Program\ Files/Notepad++/notepad++.exe "$@" & }
        alias adb='adb.exe'
        alias fastboot='fastboot.exe'
        ;;
    Darwin)
        GNU_PRE="g"
        DIRCOLORS="/usr/local/bin/gdircolors"
        python_ver="$(python --version 2>&1 |sed 's/Python \(.*\).[0-9]/python\1/')"
        POWERLINE_B="/usr/local/lib/$python_ver/site-packages/powerline/bindings/bash/powerline.sh"
        POWERLINE_T="/usr/local/lib/$python_ver/site-packages/powerline/bindings/tmux/powerline.conf"
        alias ls='ls -GF' # will be replaced later by gls or exa if exists
        ;;
    *)
        ;;
esac

#######################################################################
# Bash standard behaviour 
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


#######################################################################
### Usfull  functions
# ARCHIVE EXTRACTION
# usage: ex <file>
ex () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1   ;;
            *.tar.gz)    tar xzf $1   ;;
            *.bz2)       bunzip2 $1   ;;
            *.rar)       unrar x $1   ;;
            *.gz)        gunzip $1    ;;
            *.tar)       tar xf $1    ;;
            *.tbz2)      tar xjf $1   ;;
            *.tgz)       tar xzf $1   ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1;;
            *.7z)        7z x $1      ;;
            *.deb)       ar x $1      ;;
            *.tar.xz)    tar xf $1    ;;
            *.tar.zst)   unzstd $1    ;;      
            *)           echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
       echo "'$1' is not a valid file"
fi
}

# usage: sudox <command>
sudox () {
    token=$(xauth list $DISPLAY)
    sudo su - -c xauth add $token
    sudo $@
}

#######################################################################
# are we in tmux, ssh or other ... what shell level are we
# $TMUX   $SHLVL $SSH_CLIENT  $SSH_CONNECTION
# Also considure dbus via $DBUS_SESSION_BUS_ADDRESS

###################################################################
#   L E S S
# make less more friendly for non-text input files, see lesspipe(1)
# ee: https://www.topbug.net/blog/2016/09/27/make-gnu-less-more-powerful/
[[ -x /usr/bin/lesspipe || -x /usr/local/bin/lesspip ]] && eval "$(SHELL=/bin/sh lesspipe)"
export LESS='--quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4'
# Set colors for less. Borrowed from 
# https://wiki.archlinux.org/index.php/Color_output_in_console#less
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# syntax highlighting
#if type pygmentize >/dev/null 2>&1; then
#   #export LESSCOLORIZER='pygmentize'
#else
#    echo "For LESS syntax highlighting considure installing pygmentize"
#fi
# Another options package source-highlight ??

###################################################################
# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
         PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
         ;;
    *)
         ;;
esac

###################################################################
# Aliases:
#
#
# ls coloring, if exa exisits we will use it
# enable color support of ls and also add handy aliases
if [ -x $DIRCOLORS ]; then
    test -r ~/.dircolors && eval "$(${DIRCOLORS} -b ~/.dircolors)" || eval "$(${DIRCOLORS} -b)"
    alias ls='${GNU_PRE}ls --color=auto -F'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
else
    echo "dircolor missing, considure installing gnu core util"
fi

# if we have exa, us it and override all other ls aliases
[[ $(type exa 2>/dev/null) ]] && alias ls='exa -F --group-directories-first'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -a'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Navigation Aliases
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ..='cd ..'
alias ...='cd ../..'

# System health aliases
alias df='df -h'
alias apt='sudo apt'

# Git aliases
alias gs='git status'

# bare git repo alias for dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'


# Merge Xresources
alias merge='xrdb -merge ~/.Xresources'

# More alias definitions:
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

#################################################
# My Changes
#

#if [ -f /usr/bin/dbus-launch ]; then
#   eval `dbus-launch --sh-syntax`
#fi

SCREEN_NAME="home"
if [ -n "$SSH_CLIENT" ] ; then
   SCREEN_NAME=$SSH_CLIENT
fi

PROMPT_DIRTRIM=2
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

stty -ixon

#if [ -f /usr/bin/most ]; then
    # export PAGER="most"
#fi



###################################################################
# The "main function" is called at the end
#
#
###################################################################
main () {
     run_powerline
     run_tmux
     print_mot 

}

###################################################################
# enable powerline
#
#
###################################################################
run_powerline () {
     if [ -f $POWERLINE_B ]; then
         powerline-daemon -q
         POWERLINE_BASH_CONTINUATION=1
         POWERLINE_BASH_SELECT=1
         source $POWERLINE_B
     fi
}

###################################################################
# run_tmux will lunch tmux if no "free" session is avilable, 
#   if tmux is already running don't run tmux
#   if this is an ssh session (TERM has "screen" in it) 
#         dont run tmux automaticallya !!!!need fixing
#
###################################################################
run_tmux () {
   if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] \
             && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
      tsessions=`tmux ls -F "#{session_name}: #{?session_attached,attached,detached}"`
      if [[ ! $tsessions ]] ; then
          tmux -u new-session -A -s main # remove exec so i can exit into bash without logging out
      else
         IFS=$'\n'
         for i in $tsessions ; do 
             if [[ "$i" =~ attached ]] ; then
               continue
             elif [[ "$i" =~ detached ]] ; then 
               found=1
               printf "****\n**** found detached tmux [$i] session\n****\n"
               printf "**** Whould you like to attach (y/n):"
               read -n 1 connect
               if [[ ${connect,,} == "y" ]] ; then 
                  sid=`echo $i | awk -F ':' '{print $1}'`
                  printf "\ncoconnecting to $sid\n"
                  tmux attach -t $sid
                  printf "\n\n"
                  break 
               fi
               printf "\n\n"
             fi
         done
         if [ -z $found ] ; then
            tmux -u
         fi
      fi
   fi
}

###################################################################
# print mot etc in tmux
###################################################################
print_mot () {

    if [ ! -z "$TMUX" ]; then
        [ -f /run/motd.dynamic ] && cat /run/motd.dynamic
        printf "\n\n"
    fi
}


###################################################################
# run the main program
###################################################################
main "$@"
