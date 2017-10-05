scriptencoding utf-8



" Interface {{{1

function! minpac#loader#misc#hooks#convert_from(str) abort
  try
    " Assumed as an user functions
    return function(a:str)
  catch /^Vim\%((\a\+)\)\=:E\(15\|121\|129\|700\)/
    if a:str =~# '^{.\+}$'
      " as a lambada
      return eval(a:str)
    else
      " as an ex-command
      return a:str
    endif
  endtry
endfunction


" Internal {{{1


" Initialization {{{1



" 1}}}
