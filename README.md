# dotfiles
My Linux dot files and other useful files 
see https://www.atlassian.com/git/tutorials/dotfiles
https://www.ackama.com/blog/posts/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained


`git clone --bare https://github.com/lelcuk/dotfiles.git $HOME/.dotfiles`

`alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'`


or:
`wget https://raw.githubusercontent.com/lelcuk/dotfiles/master/setup_env.tips.sh`

`bash setup_env.tips.sh dotfile_set`
