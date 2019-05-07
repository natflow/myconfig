if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

filetype plugin indent on
syntax on

" change leader from default of the hard-to-reach \ to the easier ,
let mapleader = ","

call plug#begin('~/.config/nvim/plugged')
    Plug 'ctrlpvim/ctrlp.vim'
        map <leader>t :CtrlP<cr>
        map <leader>b :CtrlPBuffer<cr>
        map <leader>f :CtrlPClearAllCaches<cr>
        let g:ctrlp_working_path_mode = 'wra'
            " 'w' - modifier to "r": start search from the cwd instead of the current file's directory       map <leader>t :CtrlP<cr>
            " 'r' - the nearest ancestor of the current file that contains one of these directories or files: .git .hg .svn .bzr _darcs
            " 'a' - the directory of the current file, unless it is a subdirectory of the cwd
        set wildmenu
        set wildmode=longest,list,full
        " which files/dirs should be ignored in command-t
        set wildignore+=.git,node_modules,htmlcov
        set wildignore+=*.pyc,*min.css,*min.js,*.db
        set wildignore+=*.jpg,*.JPG,*.png,*.PNG,*.gif,*.GIF,*.pdf,*.PDF
        set wildignore+=*.psd,*.PSD,*.svg,*.SVG
    Plug 'mhinz/vim-grepper'
        " ,g to enter the prompt, then jump to the first result
        map <leader>g :Grepper -jump -tool git<cr>
        " :Grepper -buffers " searches just the open files
        " ,n to go to next quickfix result
        " ,p to go to prior quickfix result
        " ,G to close the quickfix window
        map <leader>n :cnext<cr>
        map <leader>p :cprevious<cr>
        map <leader>G :cclose<cr>
    Plug 'joshdick/onedark.vim'
        highlight SignColumn guibg=#1f1f1f
        highlight Todo guifg=red
        set nohlsearch
        set guifont=DejaVu\ Sans\ Mono:h8
    Plug 'sheerun/vim-polyglot'
    Plug 'ervandew/supertab'
call plug#end()

colorscheme onedark " for whatever reason, this can't be inside the plug calls above


set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set softtabstop=4

set shiftround
set autoindent

set showmatch "briefly jumps to matching bracket/parentheses/brace
set incsearch "searches while you type

set ruler "always show line/column number
set hidden "allow multiple buffers to be used
set showcmd " show what you're doing
set clipboard=unnamedplus " use OS clipboard as default yank/paste
set linebreak "soft line wrap
let &showbreak = '+++ ' "string to put at the beginning of wrapped lines
set vb "disable audible bell by enabling the (non-functional) visual bell
set backspace=indent,eol,start " backspace from beginning of line will go to end of previous line

set ignorecase
set smartcase " smart case-sensitivity searching/replacing

" save a shift press
map ; :
" be forgiving about :W, :Q, :Wq, :WQ, :Bd, :BD
com! Q q
com! W w
com! Wq wq
com! WQ wq
com! Qa qa
com! Wa wa
com! Wqa wqa
com! WQa wqa
com! Bd bd
com! BD bd
" ex-mode is never wanted
map Q q

" press spacebar to run the macro recorded in q
nnoremap <Space> @q

" no toolbars, scrollbars
set guioptions-=T
set guioptions-=l
set guioptions-=r

" remove trailing whitespace on save
"autocmd BufWritePre * :%s/\s\+$//e

" python files with non-"py" extensions
au! BufRead,BufNewFile *.wsgi set filetype=python
au! BufRead,BufNewFile *.tac set filetype=python
au! BufRead,BufNewFile *.rpy set filetype=python
" salt
au! BufRead,BufNewFile *.sls set filetype=yaml
au! BufRead,BufNewFile minion set filetype=yaml
au! BufRead,BufNewFile roster set filetype=yaml
" etc
au! BufRead,BufNewFile Vagrantfile set filetype=ruby
au! BufRead,BufNewFile Jenkinsfile set filetype=groovy
au! BufRead,BufNewFile Dockerfile* set filetype=dockerfile
" shorter indentation
au! BufRead,BufNewFile *.yaml setlocal shiftwidth=2
