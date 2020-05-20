
if filereadable(expand("~/.vim/autoload/plug.vim"))
  call plug#begin('~/.vim/plugged')

  Plug 'junegunn/fzf' ", { 'do': { -> fzf#install() } } 
  Plug 'junegunn/fzf.vim'
  Plug 'francoiscabrol/ranger.vim'
  Plug 'tpope/vim-fugitive' 
  Plug 'itchyny/lightline.vim'
  Plug 'vimwiki/vimwiki'
  Plug 'ap/vim-css-color'
  Plug 'chrisbra/Colorizer'
  Plug 'itchyny/vim-gitbranch'
"  Plug 'powerline/powerline-fonts'
  Plug 'airblade/vim-gitgutter'

  " Color themes
  Plug 'ParamagicDev/vim-medic_chalk'
  Plug 'bluz71/vim-nightfly-guicolors'

  call plug#end() 

endif  

if exists('$SUDO_USER')
  set noswapfile                      " don't create root-owned files
  set nobackup
  set noundofile
else
  set directory=~/.vim/tmp//    " keep swap files out of the way
  set directory+=.
  set backupdir=~/.vim/tmp// 
  set backupdir+=.  
  set undodir=~/.vim/tmp// 
  set undodir+=.  
endif

if has('mksession')
  set viewdir=~/.vim/tmp/view       " override ~/.vim/view default
  set viewoptions=cursor,folds        " save/restore just these (with `:{mk,load}view`)
endif

if has('termguicolors')
  set termguicolors                   " use guifg/guibg instead of ctermfg/ctermbg in terminal
endif

set tw=120
set tabstop=4
set shiftwidth=8
set autoindent                 " maintain indent of current line
set backspace=indent,start,eol " allow unrestricted backspacing in insert mode 
set expandtab
set showmatch
set incsearch
set hls  "highlight search
set cursorline
set number
set autoindent
set smartindent
set ruler
set virtualedit=all
set wildmenu 
set lazyredraw  " don't bother updating screen during macro playback
set visualbell t_vb=
filetype on     

" UTF-8 support
set encoding=utf-8
set fileencoding=utf-8 
set background=dark

syntax on 
colorscheme nightfly

if has('windows')
  set splitbelow                      " open horizontal splits below current window
endif

if has('vertsplit')
  set splitright                      " open vertical splits to the right of the current window
endif

" cleanup ranger buffers
let g:ranger_on_exit = 'bw!'
let g:ranger_open_mode = 'tabe'

" Plug 'itchyny/lightline.vim' Configuration
set laststatus=2
let g:lightline = {
      \ 'colorscheme' : 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch2', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': "gitbranch#name",
      \   'gitbranch2' : 'LightlineFugitive' 
      \ },
      \ 'component' : {
      \    'vicon' : "⎇ "
      \ },
       \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
       \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" } 
    \ }

fun LightlineFugitive()
   if exists('*gitbranch#name')
      let branch = gitbranch#name()
      return branch !=# '' ? ' '.branch : ''
   endif
   return ''
endfun
" make function to combine gliyph and function
"      \ 'separator': { 'left': '▶', 'right': '' },
"      \ 'subseparator': { 'left': '', 'right': '' }

" u+E0B2
"       \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
"       \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }

" Common mappings for most programming languages, these will be enabled by
" InitalizeVimBuffer() for most coding files.
fun CustomMacrosEnableBasicCompletion()
    " inoremap ( ()<Esc>i
    " inoremap [ []<Esc>i
    " inoremap { {}<Esc>i
    inoremap (<Space> (  )<Esc>hi
    inoremap [<Space> [  ]<Esc>hi
    inoremap {<Space> {  }<Esc>hi
    inoremap (<CR> (<CR>)<Esc>O
    inoremap [<CR> [<CR>]<Esc>O
    inoremap {<CR> {<CR>}<Esc>O
endfun

fun InitalizeVimBuffer()

    " show current file path
    nnoremap <leader>f :echo expand('%:p')<CR>

    " Toggle number/relative number/no number
    nnoremap <silent>  <leader>l :exec &nu==&rnu? "se nu!" : "se rnu!"<CR>
    nnoremap <leader>r :Ranger<CR>
    :imap jj <Esc> 

    nnoremap <C-J> <C-W><C-J>
    nnoremap <C-K> <C-W><C-K>
    nnoremap <C-L> <C-W><C-L>
    nnoremap <C-H> <C-W><C-H> 

    " Move between tabs with Shift-] and Shift-[, create new tabs with \t
    nnoremap { :tabNext <CR>
    nnoremap } :tabprevious <CR>
    nnoremap <leader>t :tabnew <CR>

    " Use Shift-J and Shift-K for page down/up like I could with arrows.
    nnoremap <S-k> <C-u>
    nnoremap <S-j> <C-d>

    " Create new window splits with \d and \D to mimic new windows in iTerm
    nnoremap <leader>sn :new <CR>
    nnoremap <leader>vn :vnew <CR>

    nnoremap <leader>s :split <CR>
    nnoremap <leader>v :vsplit <CR> 

    if &filetype == "perl"
        inoremap IFB if (  ) {<CR>}<Esc>O <Esc>xk$3hi
        inoremap FOB for my $ (  ) {<CR>}<Esc>O <Esc>xk$6hi
        inoremap WHB while (  ) {<CR>}<Esc>O <Esc>xk$3hi
        inoremap PP package ;<CR><CR>use warnings;<CR>use strict;<CR><CR>1;<Esc>Hwi
        inoremap SUB sub {<CR><Esc>0i  my () = @_;<CR><CR><Esc>0i}<Esc>kkkwi 
        map <F12> :!perl -c %<CR>

        autocmd BufNewFile,BufRead *.p? compiler perl

    endif

    call CustomMacrosEnableBasicCompletion()

endfun

augroup custom_macros
    autocmd!
    autocmd BufEnter * call InitalizeVimBuffer()
augroup END
