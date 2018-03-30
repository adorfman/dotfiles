set tw=120
set tabstop=4
set shiftwidth=4
set expandtab
set showmatch
set incsearch
set hls
syntax on
set number
set autoindent
set smartindent
set ruler
set virtualedit=all
filetype on
autocmd BufNewFile,BufRead *.p? compiler perl


noremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
:imap jj <Esc>

