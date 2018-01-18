" onepac
" Version: 0.0.1
" Author: sgur
" License: MIT License

if exists('g:loaded_onepac')
  finish
endif
let g:loaded_minpac_loader = 1

let s:save_cpo = &cpoptions
set cpoptions&vim


command! -bang -nargs=* -count=0 -complete=customlist,onepac#complete Onepac
      \ call onepac#cli(<bang>0, <count>, <f-args>)

let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim:set et:
