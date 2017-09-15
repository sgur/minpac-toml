scriptencoding utf-8



" Interface {{{1

function! minpac#loader#init() abort
endfunction

function! minpac#loader#nproc() abort
  return s:nproc
endfunction


" Internal {{{1


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
