" --------------------------------------------------------------------------------
" maintainer:   Gabriel Adomnicai <gabesoft@gmail.com>
" purpose:      vim basic settings
" --------------------------------------------------------------------------------

" set up pathogen
" --------------------------------------------------------------------------------
execute pathogen#infect()

" enable syntax and filetype settings
" --------------------------------------------------------------------------------
set nocompatible
if has('autocmd')
    filetype plugin on
    filetype indent on
endif
if has('syntax') && !exists('g:syntax_on')
    syntax enable
endif

" vim directory path
" --------------------------------------------------------------------------------
let $VIMHOME=expand('<sfile>:p:h')
if has("win32")
    let $VIMHOME=expand('$VIMHOME/vimfiles')
elseif has("macunix")
    let $VIMHOME=expand('$VIMHOME/.vim')
else
    let $VIMHOME=expand('$VIMHOME/.vim')
endif

" default font
" --------------------------------------------------------------------------------
if has("gui_running")
    if has("win32")
        set guifont=Monaco:h10:cANSI
    elseif has("macunix")
        set guifont=Monaco:h12
    else
        set guifont=Monaco\ 12
    endif
endif

" transparency
" --------------------------------------------------------------------------------
if has("gui_running")
    set transparency=5
endif

" mac os specific
" --------------------------------------------------------------------------------
if has("macunix") && has("gui")
    set macmeta                     "enable the alt key
endif
if has("macunix")
    let g:Grep_Xargs_Options='-0'   "disable xargs
endif

" leader
" --------------------------------------------------------------------------------
let mapleader=","

" source utility functions
" --------------------------------------------------------------------------------
source $VIMHOME/functions.vim

" create directories if not existent
" --------------------------------------------------------------------------------
call MkDir($VIMHOME . "/tmp")
call MkDir($VIMHOME . "/tmp/bak")
call MkDir($VIMHOME . "/tmp/swp")
call MkDir($VIMHOME . "/tmp/und")
call MkDir($VIMHOME . "/tmp/viw")

" set directory paths
" --------------------------------------------------------------------------------
set backupdir=$VIMHOME/tmp/bak      "backup
set directory=$VIMHOME/tmp/swp      "swap
set undodir=$VIMHOME/tmp/und        "undo
set viewdir=$VIMHOME/tmp/viw        "view

" don't change directory on file open, buffer switch, etc
" --------------------------------------------------------------------------------
set noautochdir

" file backup and undo
" --------------------------------------------------------------------------------
set undofile
set backup
set backupskip=/tmp/*,/private/tmp/*"   "make vim able to edit crontab files

" use a tags file (if any)
" --------------------------------------------------------------------------------
set tags=tags

" update the system clipboard on copy/paste
" --------------------------------------------------------------------------------
set clipboard=unnamed

" colors
" --------------------------------------------------------------------------------
color nazca
set background=dark
highlight clear SignColumn

" white space and indenting
" --------------------------------------------------------------------------------
set autoindent
set smartindent
set linebreak
set nowrap
set backspace=indent,eol,start

" output encoding
" --------------------------------------------------------------------------------
if &encoding ==# 'latin1' && has('gui_running')
    set encoding=utf-8
endif

" invisible characters
" --------------------------------------------------------------------------------
set list                    " display invisible characters
let &showbreak="> "
if &listchars ==# 'eol:$'
    set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
    if &termencoding ==# 'utf-8' || &encoding ==# 'utf-8'
        let &listchars = "tab:\u21e5 ,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7"
    endif
endif

" brace matching
" --------------------------------------------------------------------------------
set showmatch
set matchtime=2

" tabs
" --------------------------------------------------------------------------------
set smarttab
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

set nrformats-=octal
set shiftround

set ttimeout
set ttimeoutlen=100

" search behavior
" --------------------------------------------------------------------------------
set ignorecase
set incsearch
set smartcase
set nogdefault
set nohlsearch

" insert mode completion
" --------------------------------------------------------------------------------
set complete-=i
set completeopt=longest,menuone,preview

" auto reload changed files
" --------------------------------------------------------------------------------
set autoread
set fileformats+=mac

" user interface settings
" --------------------------------------------------------------------------------
set laststatus=2            "status bar (0=never, 1=default, 2=always)
set number
set ruler
set showcmd
set wildmenu
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*rbc,*.class,.svn,vendor/gems/*,node_modules
set showmode
set statusline=%F%m%r%h%w\ %n:%{&ff}:%Y\ L=%04l/%L[%p%%]\ C=%04c/%{len(getline(line(\".\")))}\ %{&wrap?'w':'\ '}\ %{&diff?'d':'\ '}
set mousehide
set nomodeline
set guioptions=
set showtabline=0
set title
set foldenable
set cursorline

" don't sound on errors
" --------------------------------------------------------------------------------
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" diff should split vertically
" --------------------------------------------------------------------------------
set diffopt=vertical

" always report the number of lines changed
" --------------------------------------------------------------------------------
set report=0

" command line history
" --------------------------------------------------------------------------------
if &history < 2000
    set history=2000
endif

if &tabpagemax < 50
    set tabpagemax=50
endif

set viminfo^=!

" cursor padding
" --------------------------------------------------------------------------------
if !&scrolloff
    set scrolloff=1
endif
if !&sidescrolloff
    set sidescrolloff=5
endif

set display+=lastline

" allow color schemes to do bright colors without forcing bold.
" --------------------------------------------------------------------------------
if &t_Co == 8 && $TERM !~# '^linux'
    set t_Co=16
endif

if !exists('g:netrw_list_hide')
    let g:netrw_list_hide = '^\.,\~$,^tags$'
endif

" load matchit.vim, but only if the user hasn't installed a newer version.
" --------------------------------------------------------------------------------
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
    runtime! macros/matchit.vim
endif

" set what is saved during a session 
" --------------------------------------------------------------------------------
set sessionoptions=blank,buffers,curdir,folds,help,resize,tabpages,winsize

" command window height
" --------------------------------------------------------------------------------
set cmdwinheight=20

" command line height
" --------------------------------------------------------------------------------
set cmdheight=1

" don't redraw while executing macros
" --------------------------------------------------------------------------------
set lazyredraw

" buffers
" --------------------------------------------------------------------------------
set hidden          " allow hide unsaved buffers
set equalalways
set splitbelow
set splitright

" source additional settings
" --------------------------------------------------------------------------------
source $VIMHOME/coremap.vim         " core key mappings
source $VIMHOME/corecmd.vim         " core auto commands
source $VIMHOME/bundle.vim          " plugin settings

" resolve JSLint error
" --------------------------------------------------------------------------------
let $JS_CMD='node'
