" Vim filetype plugin
" Language:     Plain text
" Maintainer:   Gabriel

if exists("b:did_ftplugin")
  finish
endif

let b:did_ftplugin = 1

" abbrevs
cabbr wp call ModeTxtSettings()
cabbr spellon call SpellCheckOn()
cabbr spelloff call SpellCheckOff()

" word processing mode
function! ModeTxtSettings()
  set lbr " wrap lines at character

  nnoremap j gj
  nnoremap k gk
  nnoremap 0 g0
  nnoremap $ g$

  set wrap
  set spell spelllang=en_us
  set omnifunc=

  call SpellCheckOn()
  call ModeTxtAbbrevs()
endfunction

" spell check highlighting
function! SpellCheckOn()
  highlight SpellBad term=reverse ctermbg=1 gui=underline guisp=Red
  highlight SpellCap term=reverse ctermbg=4 gui=underline guisp=Cyan
  highlight SpellRare term=reverse ctermbg=1 gui=underline guisp=Yellow
  highlight SpellLocal term=reverse ctermbg=1 gui=underline guisp=Green
endfunction

function! SpellCheckOff()
  highlight clear SpellBad
  highlight clear SpellCap
  highlight clear SpellRare
  highlight clear SpellLocal
endfunction

function! ModeTxtAbbrevs()
  iab Im I'm
  iab im I'm
  iab id I'd
  iab Id I'd
  iab ill I'll
  iab Ill I'll
  iab i I
endfunction

function! AbbrAsk(abbr, expansion)
  let l:ans = confirm("change '" . a:abbr . "' to '" . a:expansion . "'?", "&yes\n&no", 1)
  return l:ans == 1 ? a:expansion : a:abbr
endfunction

autocmd BufEnter,BufNewFile *.txt call ModeTxtSettings()
autocmd ColorScheme * call SpellCheckOff()
