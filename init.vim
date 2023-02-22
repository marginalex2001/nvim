set number                                                                        set expandtab
set tabstop=2

call plug#begin()

Plug 'scrooloose/nerdtree'
Plug 'jiangmiao/auto-pairs'
Plug 'ycm-core/YouCompleteMe'
"color
Plug 'morhetz/gruvbox'

call plug#end()

set hlsearch
set incsearch
syntax on


colorscheme gruvbox
set background=dark
"mappings

map <C-n> :NERDTreeToggle<CR>
map <F5> :source ~/.vimrc
map <F6> :PlugInstall

let g:ycm_enable_semantic_highlighting=1
