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


function! s:load(path, fn_execute, ...) abort "{{{
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

  let restart_on_changed = a:0 && type(a:1) == v:t_dict && get(a:1, 'restart', 0)
  call call(a:fn_execute, [
        \ '',
        \ restart_on_changed ? {'do': function('s:hook_restart_on_update_finished')} : {}
        \ ])
endfunction "}}}

function! s:hook_restart_on_update_finished(hooktype, updated, installed) abort "{{{
  if a:updated == 0 && a:installed == 0 | return | endif
  if get(g:, 'loaded_restart', 0) && exists(':Restart') == 2
    Restart
  endif
endfunction "}}}


" let s:filename = expand('<sfile>:p:h:h') . '/pack/minpac.toml'
command! -bang -nargs=1 -complete=file MinpacUpdate
      \ call s:load(<q-args>, function('minpac#update'), {'restart': <bang>0})

command! -nargs=1 -complete=file MinpacClean
      \ call s:load(<q-args>, function('minpac#clean'))

let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim:set et:
