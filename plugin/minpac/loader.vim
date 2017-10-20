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
command! -bang -nargs=+ -complete=customlist,minpac#loader#complete MinpacCli
      \ call minpac#loader#cli(<bang>0, <f-args>)

let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim:set et:
