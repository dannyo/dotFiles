" global color settings regardless of color scheme
function! GlobalColorSettings()
  if has("gui")
    set guicursor=n-v-c:block-Cursor
    set guicursor+=i:ver20-iCursor
    set guicursor+=n-v-c:blinkon0
  endif
  "highlight Cursor     guifg=red    guibg=yellow
  highlight Cursor     guifg=yellow    guibg=red
  highlight iCursor    guifg=white  guibg=red
  highlight NonText    guifg=#4A4A59
  highlight SpecialKey guifg=#4A4A59
  highlight SpellBad   term=reverse ctermbg=1 gui=underline guisp=Red
  hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
  hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
  set showcmd     
  "nnoremap n nzv:call PulseCursorLine()<cr>
  "nnoremap N Nzv:call PulseCursorLine()<cr>
endfunction

" smart space completion
function! SmartSpace()
  "check if at beginning of line or after a space
  if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
    return "\<SPACE>"
  else
    if &omnifunc != ''
      "omni-completion
      return "\<C-X>\<C-O>"
    elseif &dictionary != ''
      "dictionary completion
      return "\<C-X>\<C-K>"
    else
      "known-word completion
      return "\<C-N>"
    endif
  endif
endfunction

function! MkDir (dir)
  if !isdirectory(a:dir)
    if exists("*mkdir")
      call mkdir(a:dir, 'p')
      echo "Created directory: " . a:dir
    else
      echo "Please create directory: " . a:dir
    endif
  endif
endfunction

function! s:Spaces(count)
  let list = range(a:count)
  call map(list, '" "')
  return join(list, '')
endfunction

function! s:GetAlignPattern(len)
  if a:len > 3
    let p1 = s:Spaces(a:len)
    let p2 = s:Spaces(a:len - 2) . ', '
    let p3 = s:Spaces(a:len - 4) . 'var '
    return '\%(' . p1 . '\|' . p2 . '\|' . p3 .'\)'
  elseif a:len > 1
    let p1 = s:Spaces(a:len)
    let p2 = s:Spaces(a:len - 2) . ', '
    return '\%(' . p1 . '\|' . p2 . '\)'
  else
    return s:Spaces(a:len)
  endif
endfunction

function! AlignAssignments ()
    " Patterns needed to locate assignment operators...
    let ASSIGN_OP   = '[-+*/%|&]\?=\@<!=[=~]\@!'
    let ASSIGN_LINE = '^\(.\{-}\)\s*\(' . ASSIGN_OP . '\)\(.*\)$'

    " Locate block of code to be considered (same indentation, no blanks)
    let curr_match = matchstr(getline('.'), '\m^\s*\(var\s\|,\s\)\?')
    let match_len  = len(curr_match)
    let curr_pat   = s:GetAlignPattern(match_len)
    let indent_pat = '^' . curr_pat . '\S'

    "let indent_pat = '^' . matchstr(getline('.'), '^\s*') . '\S'
    let firstline  = search('^\%('. indent_pat . '\)\@!','bnW') + 1
    let lastline   = search('^\%('. indent_pat . '\)\@!', 'nW') - 1
    if lastline < 0
        let lastline = line('$')
    endif

    " Decompose lines at assignment operators...
    let lines = []
    for linetext in getline(firstline, lastline)
        let fields = matchlist(linetext, ASSIGN_LINE)
        call add(lines, fields[1:3])
    endfor

    " Determine maximal lengths of lvalue and operator...
    let op_lines = filter(copy(lines),'!empty(v:val)')
    let max_lval = max( map(copy(op_lines), 'strlen(v:val[0])') ) + 1
    let max_op   = max( map(copy(op_lines), 'strlen(v:val[1])'  ) )

    " Recompose lines with operators at the maximum length...
    let linenum = firstline
    for line in lines
        if !empty(line)
            let newline
            \    = printf("%-*s%*s%s", max_lval, line[0], max_op, line[1], line[2])
            call setline(linenum, newline)
        endif
        let linenum += 1
    endfor
endfunction

function! PulseCursorLine()
  let current_window = winnr()

  if &cursorline 
    return
  endif

  windo set nocursorline
  execute current_window . 'wincmd w'

  setlocal cursorline

  redir      => old_hi
  silent execute 'hi CursorLine'
  redir END
  let old_hi = split(old_hi, '\n')[0]
  let old_hi = substitute(old_hi, 'xxx', '', '')

  hi CursorLine guibg=#2a2a2a ctermbg=233
  redraw
  sleep 20m

  hi CursorLine guibg=#333333 ctermbg=235
  redraw
  sleep 20m

  hi CursorLine guibg=#3a3a3a ctermbg=237
  redraw
  sleep 20m

  hi CursorLine guibg=#444444 ctermbg=239
  redraw
  sleep 20m

  hi CursorLine guibg=#3a3a3a ctermbg=237
  redraw
  sleep 20m

  hi CursorLine guibg=#333333 ctermbg=235
  redraw
  sleep 20m

  hi CursorLine guibg=#2a2a2a ctermbg=233
  redraw
  sleep 20m

  execute 'hi ' . old_hi

  windo set cursorline
  execute current_window . 'wincmd w'

  windo set nocursorline
endfunction

