
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
  Plug 'powerline/powerline-fonts'
  Plug 'airblade/vim-gitgutter'
   
" Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  " Color themes
  Plug 'ParamagicDev/vim-medic_chalk'
  Plug 'bluz71/vim-nightfly-guicolors'

  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'voldikss/vim-floaterm'
  Plug 'vim-python/python-syntax'
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

set hidden " keep buffers with changes in the background
set tw=120
set tabstop=4
set autoindent                 " maintain indent of current line
set backspace=indent,start,eol " allow unrestricted backspacing in insert mode 
set showmatch
set incsearch
set hls  "highlight search
set cursorline
set number
set numberwidth=4
set autoindent
set smartindent
set ruler
set virtualedit=all
set wildmenu 
set lazyredraw  " don't bother updating screen during macro playback
set visualbell t_vb=
set splitright
set splitbelow
set encoding=UTF-8
set spell spelllang=en_us
filetype on     

set shiftwidth=8
set expandtab
" allow toggling between local and default mode
function TabToggle()
  if &expandtab
    set shiftwidth=8
    set softtabstop=0
    set noexpandtab
  else
    set shiftwidth=4
    set softtabstop=4
    set expandtab
  endif
endfunction
nmap <F9> mz:execute TabToggle()<CR>'z

set list lcs=trail:·,tab:»·
"set listchars=tab:~\ ,trail:* 

" UTF-8 support
set encoding=utf-8
set fileencoding=utf-8 
set background=dark

set nocompatible
filetype plugin on
syntax on 
silent! colorscheme nightfly

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

"   ☰      
" » ▶ «  ◀ 🔒 ☰ ␊ ␤ ¶ ㏑ ⎇ ρ Þ ∥ Ꞩ Ɇ Ξ

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
    nnoremap <leader>b :Buffers<CR>
    nnoremap <leader>F :Files<CR> 
    nnoremap <leader>g :Rg<CR>
    nnoremap <leader>wg :cd ~/vimwiki \| Rg<CR>

    :imap jj <Esc> 

    nnoremap <C-J> <C-W><C-J>
    nnoremap <C-K> <C-W><C-K>
    nnoremap <C-L> <C-W><C-L>
    nnoremap <C-H> <C-W><C-H> 

    " Move between tabs with Shift-] and Shift-[, create new tabs with \t
    nnoremap <leader>[ :tabp <CR>
    nnoremap <leader>] :tabn <CR>
    nnoremap <leader>t :tabnew <CR>

    " Use Shift-J and Shift-K for page down/up like I could with arrows.
    nnoremap <S-k> <C-u>
    nnoremap <S-j> <C-d>

    " Create new window splits with \d and \D to mimic new windows in iTerm
    nnoremap <leader>sn :new <CR>
    nnoremap <leader>vn :vnew <CR>

    nnoremap <leader>s :split <CR>
    nnoremap <leader>v :vsplit <CR>

    tnoremap <Esc> <C-\><C-n>

    nnoremap <leader>tm :terminal<CR>

    nnoremap <leader>tr :keepalt file

    nnoremap <leader>ft :FloatermNew<CR>

    if &filetype == "perl"
        inoremap IFB if (  ) {<CR>}<Esc>O <Esc>xk$3hi
        inoremap FOB for my $ (  ) {<CR>}<Esc>O <Esc>xk$6hi
        inoremap WHB while (  ) {<CR>}<Esc>O <Esc>xk$3hi
        inoremap PPP package ;<CR><CR>use warnings;<CR>use strict;<CR><CR>1;<Esc>Hwi
        inoremap PSUB sub {<CR><Esc>0i  my () = @_;<CR><CR><Esc>0i}<Esc>kkkwi 
        map <F12> :!perl -c %<CR>

        nnoremap <leader>PP :read ~/.vim/snippets/perl/package<CR>

        autocmd BufNewFile,BufRead *.p? compiler perl

    endif

    call CustomMacrosEnableBasicCompletion()

endfun

augroup custom_macros
    autocmd!
    autocmd BufEnter * call InitalizeVimBuffer()
augroup END


augroup vimwiki_auto_stuff
  au!
  au! BufRead ~/vimwiki/index.wiki,~/vimwiki/diary/diary.wiki !git -C ~/vimwiki pull origin master
  au! BufWritePost ~/vimwiki/*
     \ !git -C ~/vimwiki add "%"; 
     \ git -C ~/vimwiki commit -m "Auto commit of %:t." "%";
     \ git -C ~/vimwiki push origin HEAD

augroup END

"set lcd so fzf-vim with search from the path of the current open file
autocmd BufEnter ~/vimwiki/* silent! lcd %:p:h
"autocmd TerminalOpen  * setlocal nonumber norelativenumber
"autocmd TerminalOpen,BufEnter term://*  setlocal nonumber norelativenumber 
autocmd  TerminalOpen,BufEnter * if &buftype == 'terminal' | setlocal nonumber norelativenumber | endif
"augroup TerminalSetup
"  autocmd!
"  autocmd TerminalOpen * setlocal nonumber norelativenumber cursorline
"augroup END

"endif
