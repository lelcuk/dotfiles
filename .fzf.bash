# Setup fzf
# ---------
if [[ ! "$PATH" == */mnt/private/home/lelcuk/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/mnt/private/home/lelcuk/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/mnt/private/home/lelcuk/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/mnt/private/home/lelcuk/.fzf/shell/key-bindings.bash"
