scriptencoding utf-8

let s:Toml = vital#minpac_loader#new().import('Text.TOML')

" Interface {{{1

function! minpac#loader#toml#load(path) abort
  let prefs = s:load_toml(a:path)
  if !has_key(prefs, 'plugins')
    echohl WarningMsg | echomsg "No plugins entry found." | echohl NONE | return
    return
  endif
  call map(copy(prefs.plugins), 's:add(v:val)')
endfunction

" Internal {{{1

function! s:load_toml(path) abort "{{{
  return s:Toml.parse_file(a:path)
endfunction "}}}

function! s:add(plugin) abort "{{{
  let config = a:plugin
  try
    let url = remove(config, 'url')
    call minpac#add(url, config)
  catch /^Vim\%((\a\+)\)\=:E716/
    echohl ErrorMsg | echomsg v:exception | echohl NONE
  endtry
endfunction "}}}

" Initialization {{{1


" 1}}}
