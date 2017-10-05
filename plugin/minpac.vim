" minpac
" Version: 0.0.1
" Author: sgur
" License: MIT License

if exists('g:loaded_minpac_loader')
  finish
endif
let g:loaded_minpac_loader = 1

let s:save_cpo = &cpoptions
set cpoptions&vim


function! s:load(path, fn_execute) abort "{{{
  call minpac#loader#init()
  call minpac#init({'jobs': minpac#loader#nproc()})

  let filename = expand(a:path)

  if !filereadable(filename)
    return
  endif

  let ext = fnamemodify(filename, ':e')
  if ext is? 'toml'
    call minpac#loader#toml#load(filename)
  endif
  if ext is? 'json'
    call minpac#loader#json#load(filename)
  endif

  call call(a:fn_execute, [])
endfunction "}}}


" let s:filename = expand('<sfile>:p:h:h') . '/pack/minpac.toml'
command! -nargs=1 -complete=file MinpacUpdate
      \ call s:load(<q-args>, function('minpac#update'))

command! -nargs=1 -complete=file MinpacClean
      \ call s:load(<q-args>, function('minpac#clean'))

let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim:set et:
