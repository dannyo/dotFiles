" --------------------------------------------------------------------------------
" maintainer:   Gabriel Adomnicai <gabesoft@gmail.com>
" purpose:      vim plugin settings
" --------------------------------------------------------------------------------

" Ctrlp - https://github.com/kien/ctrlp.vim
" --------------------------------------------------------------------------------
let g:ctrlp_map = '<LEADER>t'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = { 'dir':  '\v[\/]\.(git|hg|svn)$', 'file': '\v\.(exe|so|dll)$' }

" NERDTree - https://github.com/scrooloose/nerdtree
" --------------------------------------------------------------------------------
let NERDTreeIgnore = ['\.pyc$', '\.rbc$', '\~$']
let NERDTreeWinPos = 'right'
let NERDTreeWinSize = 35
let NERDTreeDirArrows = 1
let NERDTreeShowLineNumbers = 1
let NERDTreeShowHidden = 0
let NERDTreeChristmasTree = 1
let NERDTreeHighlightCursorline = 1
nnoremap <LEADER>nt :NERDTreeToggle<CR>
nnoremap <LEADER>nf :NERDTreeFind<CR>
nnoremap <LEADER>nc :NERDTreeClose<CR>

" Syntastic - https://github.com/scrooloose/syntastic
" requires jsl for javascript
"     - download from http://www.javascriptlint.com/download.htm
" or  - brew install jslint
" navigate errors with :lnext, :lprev
" --------------------------------------------------------------------------------
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 0     " don't display the error list at the bottom
nnoremap <LEADER>mn :lnext
nnoremap <LEADER>mp :lprev

" Butane - https://github.com/Soares/butane.vim
" --------------------------------------------------------------------------------
noremap <leader>bc :Bclose<CR>

" CopyPath - https://github.com/vim-scripts/copypath.vim
" --------------------------------------------------------------------------------
let g:copypath_copy_to_unnamed_register = 1
nnoremap <LEADER>cp :CopyPath<CR>
nnoremap <LEADER>cf :CopyFileName<CR>

" EasyMotion - https://github.com/Lokaltog/vim-easymotion
" ----------------------------------------
" <EasyMotion_lader_key>w       : word motion
" <EasyMotion_lader_key>W       : W motion
" <EasyMotion_lader_key>t       : t motion
" <EasyMotion_lader_key>T       : T motion
" <EasyMotion_lader_key>f       : f motion
" <EasyMotion_lader_key>F       : F motion
" <EasyMotion_lader_key>b       : b motion
" <EasyMotion_lader_key>B       : B motion
" <EasyMotion_lader_key>e       : e motion
" <EasyMotion_lader_key>E       : E motion
" <EasyMotion_lader_key>ge      : ge motion
" <EasyMotion_lader_key>gE      : gE motion
" <EasyMotion_lader_key>j       : j motion
" <EasyMotion_lader_key>k       : k motion
" <EasyMotion_lader_key>n       : n motion
" <EasyMotion_lader_key>N       : N motion
" --------------------------------------------------------------------------------
let g:EasyMotion_leader_key = '<LEADER><LEADER>'

" Fugitive - https://github.com/tpope/vim-fugitive
" add to status line: set statusline+=%{fugitive#statusline()}
" --------------------------------------------------------------------------------

" Surround - https://github.com/tpope/vim-surround
" --------------------------------------------------------------------------------

" FuzzyFinder - https://github.com/vim-scripts/FuzzyFinder
" --------------------------------------------------------------------------------
nnoremap <LEADER>fb :FufBuffer<CR>
nnoremap <LEADER>ff :FufFile<CR>

" Powerline - https://github.com/Lokaltog/powerline
"           - https://powerline.readthedocs.org/en/latest/
"           - http://alexyoung.org/2012/01/13/using-powerline-with-mac-os/
" cp -R .vim/bundle/powerline/powerline/config_files/* .config/powerline/
" --------------------------------------------------------------------------------
let g:powerline_config_path = expand($VIMHOME) . '/config/powerline'
let g:Powerline_symbols = 'unicode' 
set rtp+=$VIMHOME/bundle/powerline/powerline/bindings/vim
set noshowmode

" Grep - https://github.com/vim-scripts/grep.vim"
" --------------------------------------------------------------------------------
nnoremap <LEADER>sf :Rgrep<CR>
nnoremap <LEADER>sb :Bgrep<CR>

" UltiSnips - https://github.com/SirVer/ultisnips/tree/master/UltiSnips
"           - http://bazaar.launchpad.net/~sirver/ultisnips/trunk/view/head:/doc/UltiSnips.txt
" --------------------------------------------------------------------------------
let g:UltiSnipsExpandTrigger = '<C-J>'
let g:UltiSnipsListSnippets = '<C-A-K>'
let g:UltiSnipsSnippetsDir = expand($VIMHOME) . '/snips'
let g:UltiSnipsSnippetDirectories = [ 'snips' ]

" ArgTextObj - https://github.com/vim-scripts/argtextobj.vim
" --------------------------------------------------------------------------------
let g:argumentobject_force_toplevel = 0
