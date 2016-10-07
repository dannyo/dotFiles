" --------------------------------------------------------------------------------
" maintainer:   Gabriel Adomnicai <gabesoft@gmail.com>
" purpose:      vim core auto commands
" --------------------------------------------------------------------------------

" resize splits when the window is resized
" --------------------------------------------------------------------------------
autocmd VimResized * exe "normal! \<c-w>="

" crontab settings
" --------------------------------------------------------------------------------
autocmd FileType crontab set nobackup nowritebackup
autocmd FileType crontab colorscheme vividchalk

" auto save on losing focus
" --------------------------------------------------------------------------------
autocmd BufLeave * silent! :wa
autocmd FocusLost * silent! :wa

" use a different color scheme on diff
" --------------------------------------------------------------------------------
autocmd FilterWritePre * if &diff | colorscheme rootwater | endif
