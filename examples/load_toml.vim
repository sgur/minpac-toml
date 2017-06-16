scriptencoding utf-8

try
  packadd minpac
catch /^Vim\%((\a\+)\)\=:E919/
endtry

if !exists('g:loaded_minpac')
  execute '!git clone --depth 1 https://github.com/k-takata/minpac ~/.vim/pack/tools/opt/minpac'
  echoerr 'minpack not installed'
  finish
endif

function! s:nproc() abort "{{{
  return has('unix') && executable('nproc')
        \ ? get(systemlist('nproc'), 0, 2)
        \ : 8
endfunction "}}}

call minpac#init({'jobs': s:nproc()})
call minpac#toml#load(expand("<sfile>:h") . "/minpac.toml")

call minpac#update()
