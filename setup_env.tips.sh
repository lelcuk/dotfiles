#!/bin/bash
#
#

usage () {
echo "

Usage:
$0 dotfile_set
    will clone a copy of dotfiles into $HOME folder

$0 debian_set
    will install standrd shell utils such as vim and tmux

$0 samba_set <NETBIOS NAME> <domain admin>
    will setup this host as a domain member


"
}


##################################################################
# Setup a local copy of the dotfile repo 
# 
dotfile_set () {
    git_bin="/usr/bin/git"

    # If .dotfile directory exists then the repository was initiated already
    if [ -d $HOME/.dotfiles ] ; then
        cd $HOME/.dotfiles
        $git_bin fetch origin master:master
        cd -
    else
        $git_bin clone --bare https://github.com/lelcuk/dotfiles.git $HOME/.dotfiles
        $git_bin --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
    fi

    alias dotfiles='$git_bin --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

    my_dotfiles=$($git_bin --git-dir=$HOME/.dotfiles/ \
               --work-tree=$HOME ls-tree --full-tree -r --name-only HEAD)

    # Checkout the dotfile relative to $HOME
    # backup all original files
    for i in $my_dotfiles ; do
        [ -f $i ] && mv $HOME/$i $HOME/$i.$(date +%Y%m%d)
    done

    $git_bin --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout -f master

    # install/update vim plug
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

}

debian_set () {
    # this should also work in ubuntu and raspos
    sudo apt update
    sudp apt install -y -m git curl
    sudo apt install -y -m tmux ranger mc vim powerline fonts-powerline exa


    # Clone vim and tmux plugin managers
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    # Populate the basic ranger configuration
    ranger --copy-config=all
}

samba_set () {
    # https://wiki.samba.org/index.php/Setting_up_Samba_as_a_Domain_Member
    
    # We need to  have the new server name and the domain user to use
    [ -z "$2" ] && echo "Please specify samba server name" && return
    [ -z "$3" ] && echo "Please specify samba admin user name" && return

    sudo apt update
    sudo apt install samba winbind libnss-winbind libpam-winbind krb5-user || return

    # We need to setup time syncronization

    

    # stop all samba daemons befor we continue
    smb_daemon="smbd nmbd winbind"
    for i in $smb_daemon ; do
        sudo systemctl stop $i
    done

    # remove all default samba data bases
    data_dirs=$(smbd -b | egrep "LOCKDIR|STATEDIR|CACHEDIR|PRIVATE_DIR")
    for i in $data_dirs ; do
        dir=$(echo $i | awk -F ':' '{print $2}')
        rm -q $dir/*.tdb
        rm -q $dir/*.ldb
    done
    
    # copy smb.conf, user.map and krb.conf to thye right place

    # fix the netbios name in smb.conf

    # fix nsswitch , add winbind to the end of passwd and group entries


    # add to domain controller
    sudo net ads join -U $3


    # start the daemons
    for i in $smb_daemon ; do
        sudo systemctl start $i
    done
}

misc () {
    # many usefull utilities:
    # ripgrep, fd, exa, fzf 
    sudo update-alternatives --config editor # will set default editor in Ubuntu
    install fzf from https://github.com/junegunn/fzf
}

#########################################################
# MacOs Specific
#########################################################
# setup brew
brew_set () {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

    brew install tmux ranger mc wget htop bash coreutils
}

#########################################################
# the "main" functiion
#########################################################
arch=$(uname -m)
# Linux, MacOs or some varient of Cygwin
platform=$(uname -s) # Linux, Darwin and CYGWIN*|MINGW32*|MSYS*|MINGW*
# are we on WSL/WSL2
if grep -qEi "(microsoft|WSL)" /proc/version &> /dev/null ; then
    platform="$platform-WSL"
fi

case $1 in 
    dotfile_set)
        "$@"
        ;;
    debian_set|samba_set)
        # need to check for dabien
        "$@"
        ;;
    misc)
        ;;
    brew_set)
        [ "$platform" != "Darwin" ] && echo "Error: Not a MacOs platform" && exit 2
        # need to check for mac
        "$@"
        ;;
   *)
        echo "Error: $@ unknown option"
        usage
        exit 1
        ;;
esac

