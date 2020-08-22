# Setup fzf
# ---------
if [[ ! "$PATH" == */mnt/private/home/lelcuk/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/mnt/private/home/lelcuk/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "$HOME/.fzf/shell/key-bindings.bash"
