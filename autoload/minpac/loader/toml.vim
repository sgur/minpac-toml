scriptencoding utf-8

let s:Toml = vital#minpac_loader#new().import('Text.TOML')

" Interface {{{1

function! minpac#loader#toml#load(path) abort
  let prefs = s:load_toml(a:path)
  if !has_key(prefs, 'plugins')
    echohl WarningMsg | echomsg "[minpac-loader] No plugins entry found." | echohl NONE | return
    return
  endif
  return prefs
endfunction

" Internal {{{1

function! s:load_toml(path) abort "{{{
  return s:Toml.parse_file(a:path)
endfunction "}}}

" Initialization {{{1


" 1}}}
