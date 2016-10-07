" Vim indent file
" Language:	JavaScript
" Maintainer:	JiangMiao <jiangfriend@gmail.com>
" Last Change:  2011-10-19
" Version: 1.4.6
" Homepage: http://www.vim.org/scripts/script.php?script_id=3227
" Repository: https://github.com/jiangmiao/simple-javascript-indenter

"if exists('b:did_indent')
  "finish
"endif

" The value should be float, -1/2 should be written in -0.5
if(!exists('g:SimpleJsIndenter_CaseIndentLevel'))
  let g:SimpleJsIndenter_CaseIndentLevel = 0
endif

if(!exists('g:SimpleJsIndenter_GreedyIndent'))
  let g:SimpleJsIndenter_GreedyIndent = 1
endif

let b:did_indent = 1
let b:indented = 0
let b:in_comment = 0

setlocal indentexpr=GetJsIndent()
setlocal indentkeys+==},=),=],0=*/,0=/*,0=\,,0=;,*<Return>
"if exists("*GetJsIndent")
  "finish 
"endif

let s:expr_left  = '[[{(]'
let s:expr_right = '[)}\]]'
let s:expr_all   = '[[{()}\]]'

let s:expr_case          = '\s\+\(case\s\+[^\:]*\|default\)\s*:\s*'
let s:expr_comment_start = '/\*c'
let s:expr_comment_end   = 'c\*/'

let s:expr_comma_start = '^\s*,'
let s:expr_dot_start = '^\s*\.'
let s:expr_var = '^\s*var\s'
let s:expr_var_stop = ';'
" add $ to Fix 
" ;(function() {
"   something;
" })
let s:expr_semic_start = '^\s*;\s*$'

" Check prev line
function! DoIndentPrev(ind, str, psiline, pliline, ppsinum) 
  let ind = a:ind
  let pline = a:str
  let first = 1
  let last = 0

  let mstr = matchstr(pline, '^'.s:expr_right.'*')
  let last = strlen(mstr)
  let start_with_expr_right = last

  let ind_add = 0
  let ind_dec = 0

  while 1
    let last=match(pline, s:expr_all, last)
    if last == -1
      break
    endif

    let str = pline[last]
    let last = last + 1

    if match(str, s:expr_left) != -1
      let ind_add += 2
      break
    elseif start_with_expr_right == 0
      let ind_dec += 2
    endif
  endwhile

  let ind = a:ind + (ind_add - ind_dec) * &sw

  if (match(' '.pline, s:expr_case)!=-1)
    let ind = float2nr(ind - &sw * g:SimpleJsIndenter_CaseIndentLevel)
  endif

  if match(pline, s:expr_comment_start) != -1
    let ind = ind + 1
  endif

  if match(pline, s:expr_comment_end) != -1
    let ind = ind - 1
  endif

  if match(pline, s:expr_comma_start) != -1
    let ind = ind + 2
    if (match(pline, s:expr_var_stop) != -1 && match(pline, s:expr_right) != -1)
      let ind = ind - 4
    elseif (match(pline, s:expr_var_stop) != -1)
      let ind = ind - 8
    endif
  endif

  if (match(pline, s:expr_var_stop) != -1 && match(a:psiline, s:expr_dot_start) != -1)
    let ind = ind - 3
  endif

  if (match(pline, s:expr_var_stop) != -1 && match(pline, s:expr_comma_start) == -1 && match(a:pliline, s:expr_comma_start) != -1 && match(pline, s:expr_right) != -1)
    let ind = ind - 4
  endif

  "if (match(pline, s:expr_var_stop) != -1 && match(a:psiline, s:expr_var) != -1)
    "let ind = ind - 4
  "endif

  "if (match(pline, s:expr_var_stop) != -1 && match(pline, s:expr_right) != -1 && a:ppsinum)
    "let ind = ind - 4
  "endif

  " buggy
  if match(pline, s:expr_semic_start) != -1
    let ind = ind - 2
  endif

  return ind
endfunction


" Check current line
function! DoIndent(ind, str, pline) 
  let ind = a:ind
  let line = a:str
  let pline = a:pline
  let last = 0
  let first = 1

  let mstr = matchstr(line, '^'.s:expr_right.'*')
  let num = strlen(mstr)
  let start_with_expr_right = num

  if start_with_expr_right > 0
    let num = 2
  endif
  let ind = ind - &sw * num

  if (match(' '.line, s:expr_case)!=-1)
    let ind = float2nr(ind + &sw * g:SimpleJsIndenter_CaseIndentLevel)
  endif

  if (match(line, s:expr_comma_start) != -1)
    let ind = ind - 2
    if (match(pline, s:expr_var) != -1)
      let ind = ind + 4
    endif
  endif

  if (match(line, s:expr_dot_start) != -1 && match(pline, s:expr_dot_start) == -1)
    let ind = ind + 3
  endif

  if (match(line, s:expr_dot_start) != -1 && match(pline, s:expr_right) != -1)
    let ind = ind - 3
  endif

  if (match(line, s:expr_semic_start) != -1 && match(pline, s:expr_comma_start) != -1)
    let ind = ind - 2
  endif

  if (match(line, s:expr_comma_start) == -1 && match(pline, s:expr_comma_start) != -1 && match(pline, s:expr_var_stop) != -1)
    let ind = ind + 4
  endif

  if ind<0
    let ind=0
  endif

  return ind
endfunction

" Remove strings and comments
function! TrimLine(pline)
  let line = substitute(a:pline, '\\\\', '_','g')
  let line = substitute(line, '\\.', '_','g')
  " One line comment
  let line = substitute(line, '^\s*/\*.*\*/\s*$', '//c', 'g')
  let line = substitute(line, '^\s*//.*$', '//c', 'g')
  " remove all non ascii character
  let line = substitute(line, '[^\x00-\x7f]', '', 'g')

  " Strings
  let new_line = ''
  let sub_line = ''
  let min_pos = 0
  while 1 
    let c = ''
    let base_pos = min_pos
    let min_pos = match(line, '[''"/]', base_pos)
    if min_pos == -1
      let new_line .= strpart(line, base_pos)
      break
    endif
    let c = line[min_pos]

    let new_line .= strpart(line, base_pos, min_pos - base_pos)
    let sub_line = ''

    if c == ''''
      let sub_line = matchstr(line, "^'.\\{-}'", min_pos)
      if sub_line != ''
        let new_line .= '_'
      endif
    elseif c == '"'
      let sub_line = matchstr(line, '^".\{-}"', min_pos)
      if sub_line != ''
        let new_line .= '_'
      endif
    elseif c == '/'
      " Skip all if match a comment
      if line[min_pos+1] == '/' 
        let sub_line = matchstr(line, '^/.*', min_pos)
        if min_pos == 0 && sub_line != ''
          let new_line = '//c'
          break
        endif
      elseif line[min_pos+1] == '*'
        let sub_line = matchstr(line, '^/\*.\{-}\*/', min_pos)
      else
        " /.../ sometimes is not a regexp, (a / b); // c
        let m = matchlist(line, '^\(/[^/]\+/\)\([^/]\|$\)', min_pos)
        if len(m)
          let new_line .= '_'
          let sub_line = m[1]
        endif
      endif
    endif
    if sub_line != ''
      let min_pos = min_pos + strlen(sub_line)
    else
      let new_line .= c
      let min_pos = min_pos + 1
    endif
  endwhile
  let line = new_line
  
  " Comment
  let line = substitute(line, '/\*.*$','/*c','')
  let line = substitute(line, '^.\{-}\*/','c*/','')
  let line = substitute(line, '^\s*\*.*','','')

  " Brackets
  let new_line = ''
  while new_line != line
    let new_line = line
    let line = substitute(line,'\(([^)(]*)\|\[[^\][]*\]\|{[^}{]*}\)','_','g')
  endwhile
  
  " Trim Blank
  let line = matchlist(line, '\s*\(.\{-}\)\s*$')[1]

  return line
endfunction

function! s:GetLine(num)
  return TrimLine(getline(a:num))
endfunction

let s:expr_partial = '[+\-*/|&,]$'
let s:expr_partial2 = '[+\-*/|&]$'
function! s:IsPartial(line)
  return match(a:line, '\*/$') == -1 && match(a:line, s:expr_partial)!=-1 && ( match(a:line, s:expr_all)==-1 || s:IsOneLineIndentLoose(a:line) )
endfunction

function! s:IsComment(line)
  return a:line =~ '^\s*//' || a:line =~ '^\s*/\*.*\*/\s*$'
endfunction

function! s:SearchBack(num)
  let num = a:num
  let new_num = num
  let partial = 0
  while 1
    if new_num == 0
      break
    endif
    let line = getline(new_num)
    if !s:IsComment(line)
      let line = TrimLine(line)
      if !s:IsPartial(line)
        if partial > 0
          " Store line number to last partial
          let num = partial
        endif
        break
      endif
      " Save the partial postion
      let partial = new_num
      if match(line, s:expr_all)!=-1
        let num = new_num
        break
      endif
    endif
    let num = new_num
    let new_num = num - 1
  endwhile
  return num
endfunction

function! s:AssignIndent(line)
  let ind = 0
  let line = a:line
  let line = matchlist(line, '^\s*\(.\{-}\)\s*$')[1]

  if(match(line,'.*=.*'.s:expr_partial2) != -1)
    return ind + strlen(matchstr(line, '.*=\s*'))
  elseif(match(line,'\(var\|return\)\s\+.*=\s*') != -1)
    return ind + strlen(matchstr(line, '\(var\|return\)\s\+'))
  elseif(match(line,'\(var\|return\)\s\+') != -1)
    return ind + strlen(matchstr(line, '\(var\|return\)\s\+'))
  elseif(match(line,'^\w\s\+=\s*.*[^,]$') != -1)
    return ind + strlen(matchstr(line, '^\w\s\+=\s*'))
  endif
  return ind
endfunction

function! s:IsAssign(line)
  return match(a:line, s:expr_all) == -1 && s:AssignIndent(a:line)>0
endfunction

function! DoIndentAssign(ind, line)
  return a:ind + s:AssignIndent(a:line)
endfunction

function! s:IsOneLineIndent(line)
  return match(a:line, '^[})\]]*\s*\(if\|else\|while\|try\|catch\|finally\|for\|else\s\+if\)\s*_\=$') != -1
endfunction

function! s:IsOneLineIndentLoose(line)
  " _\= equal _? in PCRE
  return match(a:line, '^[})\]]*\s*\(if\|else\|while\|try\|catch\|finally\|for\|else\s\+if\)') != -1
endfunction


function! GetJsIndent()
  if v:lnum == 1
    return 0
  endif
  let pnum = prevnonblank(v:lnum-1)
  let pline = s:GetLine(pnum)

  let ppnum = prevnonblank(pnum - 1)
  let ppline = s:GetLine(ppnum)

  let pendsemi = match(pline, s:expr_var_stop)

  let psinum = ppnum      
  let psiline = ppline      " prev line with same indent
  while (pendsemi != -1) && (psinum > 0) && (indent(pnum) != indent(psinum)) " need to check for comment lines here
    let psinum = prevnonblank(psinum - 1)
    let psiline = s:GetLine(psinum)
  endw

  let plinum = ppnum      
  let pliline = ppline      " prev line with lower or same indent
  while (pendsemi != -1) && (plinum > 0) && (indent(pnum) < indent(plinum)) " need to check for comment lines here
    let plinum = prevnonblank(plinum - 1)
    let pliline = s:GetLine(plinum)
  endw

  let ppsinum = psinum                            " is the line previous to the previous line with same indent partial
  let ppsilineIsPartial = 0
  if (ppsinum - 1) > 0
    let ppsinum = prevnonblank(ppsinum - 1)  " we need to skip comment lines here
    let ppsiline = s:GetLine(ppsinum)
    let ppsilineIsPartial = s:IsPartial(ppsiline)
  endif

  if ((s:IsPartial(pline)||s:IsComment(pline)) && pnum == v:lnum-1)||match(pline, s:expr_left)!=-1
    let pnum = s:SearchBack(pnum)
    let ind = indent(pnum)
    let pline = s:GetLine(pnum)
    let ind = DoIndentPrev(ind, pline, psiline, pliline, ppsilineIsPartial)
    "if s:IsAssign(pline) && match(s:GetLine(v:lnum), s:expr_all)==-1
    if s:IsAssign(pline) " && match(s:GetLine(v:lnum), s:expr_all)==-1
      let ind = DoIndentAssign(ind, pline)
    endif
  else
    let fix = 1
    " Ignore the comments
    while s:IsComment(ppline)
      let ppnum = prevnonblank(ppnum-1)
      let ppline = s:GetLine(ppnum)
      let fix += 1
    endwhile

    if s:IsPartial(ppline) && ppnum == pnum- fix
      let pnum =  s:SearchBack(ppnum)
    endif

    let ind = indent(pnum)
    let pline = s:GetLine(pnum)
    let ind = DoIndentPrev(ind, pline, psiline, pliline, ppsilineIsPartial)

    let ppnum = prevnonblank(pnum-1)
    let ppline = s:GetLine(ppnum)
    if s:IsOneLineIndent(pline) && match(s:GetLine(v:lnum), s:expr_all)==-1
      let ind = ind + &sw + &sw
    endif
    if s:IsOneLineIndent(ppline)
      let ind = ind - &sw - &sw
    endif
  endif

  " If pline is indented, and ppline is partial then indent 
  " Fix for
  " function() {
  "   b( this,
  "     a(),
  "     d() ); 
  " },
  let real_pnum = prevnonblank(v:lnum-1)
  if(real_pnum!=pnum)
    let pline = s:GetLine(real_pnum)
    let ind = DoIndentPrev(ind, pline, psiline, pliline, ppsilineIsPartial)
  endif

  let line = s:GetLine(v:lnum)
  let ind = DoIndent(ind, line, pline)

  return ind
endfunction
