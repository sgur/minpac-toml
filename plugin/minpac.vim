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


" let s:filename = expand('<sfile>:p:h:h') . '/pack/minpac.toml'
command! -bang -nargs=1 -complete=file MinpacUpdate
      \ call minpac#loader#load(<q-args>, function('minpac#update'), {'restart': <bang>0})

command! -nargs=1 -complete=file MinpacClean
      \ call minpac#loader#load(<q-args>, function('minpac#clean'))


let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim:set et:
