scriptencoding utf-8

let s:Toml = vital#minpac_toml#new().import('Text.TOML')

" Interface {{{1

function! minpac_toml#toml#load(path) abort
  let prefs = s:load_toml(a:path)
  if !has_key(prefs, 'plugin')
    return {}
  endif
  return prefs
endfunction

" Internal {{{1

function! s:load_toml(path) abort "{{{
  return s:Toml.parse_file(a:path)
endfunction "}}}

" Initialization {{{1


" 1}}}
