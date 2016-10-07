" Vim indent file
" Language: CSS
" Maintainer: Nikolai Weibull <now@bitwi.se>
" Latest Revision: 2010-12-22

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetCSSIndent()
setlocal indentkeys=0{,0},!^F,o,O
setlocal nosmartindent

if exists("*GetCSSIndent")
  finish
endif

function! s:PrevNonBlankNonComment(lnum)
  let lnum = a:lnum

  while lnum > 1
    let lnum = prevnonblank(lnum)
    let line = getline(lnum)

    if line =~ '\*/'
      while lnum > 1 && line !~ '/\*'
        let lnum -= 1
      endwhile
      if line =~ '^\s*/\*'
        let lnum -= 1
      else
        break
      endif
    else
      break
    endif
  endwhile

  return lnum
endfunction

function! s:CountBraces(lnum, open)
  let nopen = 0
  let nclose = 0
  let line = getline(a:lnum)
  let pattern = '[{}]'
  let i = match(line, pattern)

  while i != -1
    let idattr = synIDattr(synID(a:lnum, i + 1, 0), 'name')
    let notCommentOrString = idattr !~ 'css\%(Comment\|StringQ\{1,2}\)'
    if notCommentOrString
      if line[i] == '{'
        let nopen += 1
      elseif line[i] == '}'
        if nopen > 0
          let nopen -= 1
        else
          let nclose += 1
        endif
      endif
    endif
    let i = match(line, pattern, i + 1)
  endwhile

  return a:open ? nopen : nclose
endfunction

function! GetCSSIndent()
  let line = getline(v:lnum)

  if line =~ '^\s*\*'
    return cindent(v:lnum)
  endif

  let pnum = s:PrevNonBlankNonComment(v:lnum - 1)
  if pnum == 0
    return 0
  endif

  return indent(pnum) + s:CountBraces(pnum, 1) * &sw - s:CountBraces(v:lnum, 0) * &sw
endfunction
