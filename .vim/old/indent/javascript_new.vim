" ------------------------------------------------------------------------------
" Vim indent file
" ---------------
" Language:     javascript
" Maintainer:   Gabriel Adomnicai <gabesoft@gmail.com>
" Last Change:  2012-03-31
" ------------------------------------------------------------------------------

" Standard Declarations
" ------------------------------------------------------------------------------

" only load this file when no other was loaded
" --------------------------------------------
"if exists("b:did_indent")      " TODO: uncomment when done
"finish
"endif
"let b:did_indent - 1

" Set the global log variable 1 = logging enabled, 0 = logging disabled
let g:js_indent_log = 1         " TODO: remove
if !exists("g:js_indent_log")
  let g:js_indent_log = 0
endif

" set the function that will do the indenting
" -------------------------------------------
setlocal indentexpr=GetJsIndent()
setlocal indentkeys+==},=),=],0=*/,0=/*,0=\,,0=;,*<Return>

" only define the function once
" -----------------------------
"if exists("*GetJsIndent")      " TODO: uncomment when done
"finish
"endif

" Variables
" ------------------------------------------------------------------------------
let s:exprLeft     = '[[{(]'
let s:exprLeftEnd  = s:exprLeft . '$'
let s:exprRight    = '[\]})]'
let s:exprRightEnd = s:exprRight . ';\?' . '$'
let s:exprAll      = '[[{()}\]]'

let s:exprCase     = '\s\+\(case\s\+[^\:]*\|default\)\s*:\s*'

let s:commentStart = '/\*c'
let s:commentEnd   = 'c\*/'

let s:exprPartial  = '[+\-*/|&,]$'

let s:lineComment1 = '^\s*/\*.*\*/\s*$'
let s:lineComment2 = '^\s*//.*$'

let s:exprSemiEnd  = ';$'
let s:exprVarStart = '^\s*var\s'
let s:exprDotStart = '^\s*\.'

let s:oneSpace = 1
let s:oneTab   = 4

" Aux Functions
" ------------------------------------------------------------------------------

function! s:Log(...)
  if g:js_indent_log
    echohl WarningMsg | echomsg "LOG: " string(a:000) | echohl None
  endif
endfunction

" determines if a given line is a comment line
" --------------------------------------------
function! s:Comment(line)
  return (a:line =~ s:lineComment1) || (a:line =~ s:lineComment2)
endfunction

" cleans comments, strings, and end whitespace
" -------------------------------------------
function! s:Clean(line)
  let line = a:line

  let line = substitute(line, '\\\\', '_','g')
  let line = substitute(line, '\\.', '_','g')

  " one line comment
  let line = substitute(line, s:lineComment1, '//c', 'g')
  let line = substitute(line, s:lineComment2, '//c', 'g')

  " remove all non ascii characters
  let line = substitute(line, '[^\x00-\x7f]', '', 'g')

  " strings
  let newLine = ''
  let subLine = ''
  let minPos  = 0
  while 1 
    let c        = ''
    let base_pos = minPos
    let minPos  = match(line, '[''"/]', base_pos)
    if minPos == -1
      let newLine .= strpart(line, base_pos)
      break
    endif
    let c = line[minPos]

    let newLine .= strpart(line, base_pos, minPos - base_pos)
    let subLine = ''

    if c == ''''
      let subLine = matchstr(line, "^'.\\{-}'", minPos)
      if subLine != ''
        let newLine .= '_'
      endif
    elseif c == '"'
      let subLine = matchstr(line, '^".\{-}"', minPos)
      if subLine != ''
        let newLine .= '_'
      endif
    elseif c == '/'
      " skip all if match a comment
      if line[minPos+1] == '/' 
        let subLine = matchstr(line, '^/.*', minPos)
        if minPos == 0 && subLine != ''
          let newLine = '//c'
          break
        endif
      elseif line[minPos+1] == '*'
        let subLine = matchstr(line, '^/\*.\{-}\*/', minPos)
      else
        " /.../ sometimes is not a regexp, (a / b); // c
        let m = matchlist(line, '^\(/[^/]\+/\)\([^/]\|$\)', minPos)
        if len(m)
          let newLine .= '_'
          let subLine = m[1]
        endif
      endif
    endif
    if subLine != ''
      let minPos = minPos + strlen(subLine)
    else
      let newLine .= c
      let minPos = minPos + 1
    endif
  endwhile
  let line = newLine

  " comment
  let line = substitute(line, '/\*.*$','/*c','')
  let line = substitute(line, '^.\{-}\*/','c*/','')
  let line = substitute(line, '^\s*\*.*','','')

  " brackets
  let newLine = ''
  while newLine != line
    let newLine = line
    let line = substitute(line,'\(([^)(]*)\|\[[^\][]*\]\|{[^}{]*}\)','_','g')
  endwhile

  " trim blank
  let line = matchlist(line, '\s*\(.\{-}\)\s*$')[1]

  return line
endfunction

" gets previous non-comment lines up to (and including) the 
" line with lower indent than the line with the specified number
" --------------------------------------------------------------
function! s:GetPrevData(lnum)
  let lines = []
  let lnum  = prevnonblank(a:lnum - 1)
  let orig  = lnum
  let idnt  = indent(orig)
  let curr  = idnt

  while lnum > 0
    let line = getline(lnum)
    if !s:Comment(line)
      call add(lines, line)
    endif
    if (curr < idnt) || (idnt == 0)
      break
    endif

    let lnum = prevnonblank(lnum - 1)
    let curr = indent(lnum)
  endwhile

  call s:Log('lines', len(lines), orig, lnum)
  return [orig, lines]
endfunction

" checks if the given text matches a pattern
" ------------------------------------------
function! s:Is(text, patt)
  return match(a:text, a:patt) != -1
endfunction

" populates all data needed during offset calculation
" ---------------------------------------------------
function! s:PopulateLines(lnum)
  let currNum       = a:lnum
  let currLine      = getline(currNum)
  let currLine      = s:Clean(currLine)
  let [pnum, lines] = s:GetPrevData(currNum)
  let lines         = map(lines, 's:Clean(v:val)')

  return { 
  \ 'empty'     : empty(currLine),
  \ 'currNum'   : currNum,
  \ 'prevNum'   : pnum,
  \ 'currLine'  : currLine, 
  \ 'prevLines' : lines }
endfunction

" calculates indent offset
" ------------------------
function! s:CalculateOffset(data)
  call s:Log(a:data)

  let offset = 0
  let data   = a:data
  let curr   = data['currLine']
  let lines  = data['prevLines']

  if len(lines) == 0
    return offset
  endif

  let prev   = lines[0]
  let last   = lines[-1]

  call s:Log('prev', prev)
  call s:Log('last', last)
  call s:Log('curr', curr)

  " open or close expressions
  if s:Is(prev, s:exprLeftEnd)
    let offset += s:oneTab
  endif
  if s:Is(curr, s:exprRight)
    let offset -= s:oneTab
  endif

  " var statements
  if s:Is(prev, s:exprVarStart)
    let offset += s:oneTab
  endif
  if (last != prev) && s:Is(last, s:exprVarStart) && !s:IsLeftExpr(last) && s:Is(prev, s:exprSemiEnd)
    let offset -= s:oneTab
  endif

  " commments
  if s:Is(prev, s:commentStart)
    let offset += s:oneSpace
  endif
  if s:Is(prev, s:commentEnd)
    let offset -= s:oneSpace
  endif

  return offset
endfunction

function! s:IsLeftExpr(line)
  let line = a:line
  let prev = match(line, s:exprLeft)
  let curr = prev

  while curr != -1
    let prev = curr
    let curr = match(line, s:exprLeft, curr + 1)
  endwhile

  call s:Log('IsLeftExpr', prev, strpart(line, prev + 1), line)
  if prev != -1
    let part = strpart(line, prev + 1)
    return match(part, s:exprAll) == -1
  endif

  return prev
endfunction

" Indenter
" ------------------------------------------------------------------------------
function! GetJsIndent()
  let lnum = v:lnum
  if lnum == 0
    return 0
  endif

  let data   = s:PopulateLines(lnum)
  let offset = s:CalculateOffset(data)

  let prevIndent  = indent(data['prevNum'])
  let currIndent  = prevIndent + offset

  call s:Log(lnum, currIndent, prevIndent)
  return currIndent
endfunction
