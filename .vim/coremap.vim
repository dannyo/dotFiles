" --------------------------------------------------------------------------------
" maintainer:   Gabriel Adomnicai <gabesoft@gmail.com>
" purpose:      vim core key mappings
" --------------------------------------------------------------------------------

nnoremap K <NOP>

" re-assign the q functionality to Q and
" re-assign the , functionality to q
" --------------------------------------------------------------------------------
nnoremap Q q
vnoremap Q q
nnoremap q ,
vnoremap q ,

" use jj to exit insert mode (other options are <C-C> and <C-[>)
" --------------------------------------------------------------------------------
inoremap jj <ESC>

" allign variable assignments
" --------------------------------------------------------------------------------
nmap <LEADER>a :call AlignAssignments()<CR>

" toggle search higlighting
" --------------------------------------------------------------------------------
nmap <LEADER>sh :set hlsearch!<CR>

" open or create file
" --------------------------------------------------------------------------------
nmap <LEADER>e :e

" close all buffers and quit vim
" --------------------------------------------------------------------------------
nmap ZQ :qa<CR>

" buffer operations
" --------------------------------------------------------------------------------
noremap <C-TAB> :bnext<CR>
noremap <S-C-TAB> :bprev<CR>
noremap <LEADER>bl :ls<CR>
noremap <LEADER>bt :b#<CR>
noremap <LEADER>bn :bnext<CR>
noremap <LEADER>bp :bprev<CR>
noremap <LEADER>bd :bd<CR>
noremap <LEADER>bw :w<CR>

" window navigation
" --------------------------------------------------------------------------------
noremap <LEADER>k :wincmd k<CR>
noremap <LEADER>j :wincmd j<CR>
noremap <LEADER>h :wincmd h<CR>
noremap <LEADER>l :wincmd l<CR>

" window operations (this can also be done with <C-W>[s|v|c|o])
" --------------------------------------------------------------------------------
noremap <LEADER>ws :split<CR>
noremap <LEADER>wv :vsplit<CR>
noremap <LEADER>wc :hide<CR>
noremap <LEADER>wo :only<CR>

" window resize
" --------------------------------------------------------------------------------
nmap <C-RIGHT> <C-W>>
nmap <C-LEFT> <C-W><
nmap <C-UP> <C-W>+
nmap <C-DOWN> <C-W>-

" make Y consistent with C and D
" --------------------------------------------------------------------------------
nnoremap Y y$

" moving lines
" <ALT-j> move line or selected block down
" <ALT-k> move line or selected block up
" --------------------------------------------------------------------------------
nnoremap <A-j> :m+<CR>==
nnoremap <A-k> :m-2<CR>==
inoremap <A-j> <ESC>:m+<CR>==gi
inoremap <A-k> <ESC>:m-2<CR>==gi
vnoremap <A-j> :m'>+<CR>gv=gv
vnoremap <A-k> :m-2<CR>gv=gv

" prevent accidental undo in insert mode
" --------------------------------------------------------------------------------
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" search and replace
" --------------------------------------------------------------------------------
noremap <M-/> :%s/

" transpose characters insert mode
" --------------------------------------------------------------------------------
inoremap <C-T> <ESC>hxpa

" use <C-J> to split a line (<S-J> joins a line)
" --------------------------------------------------------------------------------
nnoremap <NL> i<CR><ESC>

" F1: toggle full screen
" --------------------------------------------------------------------------------
noremap <F1> :set invfullscreen!<CR>
inoremap <F1> :set invfullscreen!<CR>

" F3: insert timestamp
" --------------------------------------------------------------------------------
nnoremap <F3> a<C-R>=strftime("%m/%d/%Y %I:%M %p")<CR><Esc>
inoremap <F3> <C-R>=strftime("%m/%d/%Y %I:%M %p")<CR>

" F4: insert guid
nnoremap <F4> a<C-R>=substitute(system("uuidgen"), '.$', '', 'g')<CR>
inoremap <F4> <C-R>=substitute(system("uuidgen"), '.$', '', 'g')<CR>

" F5: toggle line wrap
" --------------------------------------------------------------------------------
nnoremap <F5> :set nowrap!<CR>
inoremap <F5> :set nowrap!<CR>

" F6: intent all lines (preserves cursor position)
" --------------------------------------------------------------------------------
nnoremap <F6> mzgg=G'zzz:delmarks z<CR>
inoremap <F6> mzgg=G'zzz:delmarks z<CR>

" F7: format json file
" --------------------------------------------------------------------------------
nnoremap <F7> mz:%!python -m json.tool<CR>'zzz:delmarks z<CR>

" F11: remove trailing whitespace (preserves cursor position)
" --------------------------------------------------------------------------------
nnoremap <F11> mz:%s/\s\+$//<CR>:let @/=''<CR>'z:delmarks z<CR>

" F12: remove trailing ^M (preserves cursor position, insert with <C-V><C-M>)
" --------------------------------------------------------------------------------
nnoremap <F12> mzHmt:%s/<C-V><cr>//ge<cr>'tzt'z:delmarks z<CR>
