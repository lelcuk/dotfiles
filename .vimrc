" .vimrc example is taken from:
"    https://www.youtube.com/watch?v=n9k9scbTuvQ
"    https://github.com/erkrnt/awesome-streamerrc/blob/master/ThePrimeagen/init.vim
"
syntax on

set guicursor=
set noshowmatch
set relativenumber
set nohlsearch
set hidden
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
"set termguicolors
set scrolloff=8

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey

" Enabling mouse in VIM
" see http://vimdoc.sourceforge.net/htmldoc/options.html
set mouse=n

" set paste/nopaste to allow no auto indent when pasting, a better solution is
" avilable here:
" https://coderwall.com/p/if9mda/automatically-set-paste-mode-in-vim-when-pasting-in-insert-mode
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

" plugins manager
" https://github.com/junegunn/vim-plug
" to install run: curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" Use :PlugInstall to install all plugins
call plug#begin('~/.vim/plugged')

" A collection of language packs for Vim.
" https://github.com/sheerun/vim-polyglot
Plug 'sheerun/vim-polyglot'

" Command completion plugin
" https://github.com/neoclide/coc.nvim
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" ripgrap plugin
" https://github.com/jremmen/vim-ripgrep
Plug 'jremmen/vim-ripgrep'

" Undo tree plugin
" https://github.com/mbbill/undotree
Plug 'mbbill/undotree'

" git plugin
" https://github.com/tpope/vim-fugitive
Plug 'tpope/vim-fugitive'

" View man pages in vim. Grep for the man pages.
" https://github.com/vim-utils/vim-man
Plug 'vim-utils/vim-man'

Plug 'preservim/nerdtree'

" Some formatting
Plug 'gruvbox-community/gruvbox'
Plug 'sainnhe/gruvbox-material'
Plug 'phanviet/vim-monokai-pro'
Plug 'vim-airline/vim-airline'   " Nice status line for vim
Plug 'flazz/vim-colorschemes'    " Load color scheme via :colorscheme

" Plug 'kamykn/spelunker.vim'      " spell checker plugin
"  spelunker.vim kills vim performance, dont use
" Plug 'reedes/vim-lexical' is another option for spell checking

call plug#end()

colorscheme gruvbox
set background=dark


if executable('rg')
    let g:rg_derive_root='true'
endif

let g:coc_disable_startup_warning = 1


" Spell checking in VIM??, somehow the native spell checker is not working
" Using https://github.com/kamykn/spelunker.vim Plugin
" set nospell
" let g:enable_spelunker_vim = 1
" let g:spelunker_check_type = 2
" let g:spelunker_max_suggest_words = 15
" let g:spelunker_highlight_type = 2
" let g:spelunker_disable_uri_checking = 1
" Override highlight setting.
" highlight SpelunkerSpellBad cterm=underline gui=underline 

" Spell Checking is still for me tbd
setlocal spell spelllang=en_us
"   set spellfile=~/.vim/spell/en.utf-8.add
"
"
" viminfo is where the history is kept
"set viminfo=%,<800,'10,/50,:100,h,f0,n~/.vim/.viminfo
"           | |    |   |   |    | |  + viminfo file path
"           | |    |   |   |    | + file marks 0-9,A-Z 0=NOT stored
"           | |    |   |   |    + disable 'hlsearch' loading viminfo
"           | |    |   |   + command-line history saved
"           | |    |   + search history saved
"           | |    + files marks saved
"           | + lines saved each register (old name for <, vi6.2)
"           + save/restore buffer list
