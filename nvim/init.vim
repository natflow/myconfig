" :source % to update current instance with any changes in this file

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
    Plug 'andbar-ru/vim-unicon' " uniform contrast across colors, like solarized but higher contrast
        set termguicolors " enable true colors in terminal
        highlight SignColumn guibg=#1f1f1f
        highlight Todo guifg=red
        set nohlsearch
    Plug 'ctrlpvim/ctrlp.vim'
        map <leader>t :CtrlP<cr>
        map <leader>b :CtrlPBuffer<cr>
        map <leader>f :CtrlPClearAllCaches<cr>
        let g:ctrlp_working_path_mode = '' " always use the cwd
        set wildmenu
        " when tab-completing commands
        " * first tab shows a list (sorted by last used) if there are multiple matches, and completes to the longest substring
        " * second tab shows a list (sorted by last used) if there are multiple matches, and completes to a full command
        set wildmode=list:lastused:longest,list:lastused:full
        " which files/dirs should be ignored in fuzzy opening
        set wildignore+=.git,node_modules,env/**/*.py,venv/**/*.py,vendor
        set wildignore+=*.pyc,*min.css,*min.js,*.db
        set wildignore+=*.jpg,*.JPG,*.jpeg,*.JPEG,*.png,*.PNG,*.gif,*.GIF,*.pdf,*.PDF
        set wildignore+=*.psd,*.PSD,*.svg,*.SVG
        set wildignore+=build,dist
    Plug 'editorconfig/editorconfig-vim'
    Plug 'ervandew/supertab'
    Plug 'gioele/vim-autoswap'
    Plug 'itchyny/lightline.vim'
        set noshowmode
        let g:lightline = {
            \ 'colorscheme': 'jellybeans',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'relativepath', 'modified' ] ]
            \ }
            \ }
    Plug 'mhinz/vim-grepper'
        let g:grepper = {}
        let g:grepper.tools = ['git']
        let g:grepper.git = {}
        let g:grepper.git.grepprg = 'git grep --line-number --column'
        " ,g to enter the prompt, then jump to the first result
        map <leader>g :Grepper -jump<cr>
        " :Grepper -buffers " searches just the open files
        " ,n to go to next quickfix result
        " ,p to go to prior quickfix result
        " ,G to close the quickfix window
        map <leader>n :cnext<cr>
        map <leader>p :cprevious<cr>
        map <leader>G :cclose<cr>
    Plug 'sheerun/vim-polyglot'
call plug#end()

" for whatever reason, this can't be inside the plug calls above
colorscheme unicon
set background=dark

" auto switch background to whatever the system is set to
function! SetBackgroundMode(...)
    let s:new_bg = "light"
    let s:mode = systemlist("defaults read -g AppleInterfaceStyle")
    if v:shell_error == 0 && s:mode[0] == "Dark"
        let s:new_bg = "dark"
    endif
    if &background !=? s:new_bg
        let &background = s:new_bg
    endif
endfunction
call SetBackgroundMode()
call timer_start(5000, "SetBackgroundMode", {"repeat": -1})


" tabs, spaces, inserts, shifts... also see ~/.editorconfig
set smarttab
set shiftround
set autoindent
set backspace=indent,eol,start " backspace from beginning of line will go to end of previous line

" search
set showmatch " briefly jumps to matching bracket/parentheses/brace
set incsearch " searches while you type

set ruler " always show line/column number
set hidden " allow multiple buffers to be used
set showcmd " show what command you're starting as you're doing it
set clipboard=unnamedplus " use OS clipboard as default yank/paste
set linebreak " soft line wrap
let &showbreak = '+++ ' " string to put at the beginning of wrapped lines
set vb " disable audible bell by enabling the (non-functional) visual bell

" case
set ignorecase
set smartcase " smart case-sensitivity searching/replacing

" be forgiving about :W, :Q, :Wq, :WQ, :Bd, :BD
command! Q q
command! W w
command! Wq wq
command! WQ wq
command! Qa qa
command! Wa wa
command! Wqa wqa
command! WQa wqa
command! Bd bd
command! BD bd
" ex-mode is never wanted
map Q q

" paste into command-line
cmap <c-v> <c-r>+
" go to the beginning/end of the command-line, using common shell shortcut
cmap <c-a> <c-b>

" press spacebar to run the macro recorded in q
nnoremap <Space> @q

" no toolbars, scrollbars
set guioptions-=T
set guioptions-=l
set guioptions-=r

" remove trailing whitespace on save
autocmd BufWritePre * if !&binary && &filetype != 'diff' | :%s/\s\+$//e | endif

" set filetypes on otherwise unrecognized files
autocmd! BufRead,BufNewFile Tiltfile* set filetype=python
autocmd! BufRead,BufNewFile *.sls,minion,roster set filetype=yaml
autocmd! BufRead,BufNewFile Dockerfile* set filetype=dockerfile
autocmd! BufRead,BufNewFile Jenkinsfile set filetype=groovy
autocmd! BufRead,BufNewFile Vagrantfile set filetype=ruby
