scriptencoding utf-8



" Interface {{{1

function! minpac#loader#init() abort
endfunction

function! minpac#loader#nproc() abort
  return s:nproc
endfunction

function! minpac#loader#add(plugin) abort
  let config = a:plugin
  " Prerocess config.do hooks
  if has_key(config, 'do') && type(config.do) == v:t_string
    let config.do = s:convert_hook_from(config.do)
  endif

  try
    let url = remove(config, 'url')
    call minpac#add(url, config)
  catch /^Vim\%((\a\+)\)\=:E716/
    echohl ErrorMsg | echomsg v:exception | echohl NONE
  endtry
endfunction


" Internal {{{1

function! s:convert_hook_from(str) abort
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


" Initialization {{{1



" 1}}}

try
  packadd minpac
catch /^Vim\%((\a\+)\)\=:E919/
finally
  if !exists('g:loaded_minpac')
    echoerr 'minpack not installed'
    finish
  endif
endtry


let s:nproc = has('win32')
      \ ? $NUMBER_OF_PROCESSORS
      \ : executable('nproc')
      \   ? systemlist('nproc')[0]
      \   : executable('sysctl')
      \     ? systemlist('sysctl -n hw.ncpu')
      \     : 4

" macOS : sysctl -n machdep.cpu.cores_per_pacakge でもよさそう
