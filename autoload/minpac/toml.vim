scriptencoding utf-8

let s:Toml = vital#minpac_loader#new().import('Text.TOML')

" Interface {{{1

function! minpac#toml#load(path) abort
  let repos = s:load_toml(a:path)
  call s:add(repos)
endfunction

" Internal {{{1

function! s:load_toml(path) abort "{{{
  let dict = s:Toml.parse_file(a:path)
  return get(dict, 'plugins', [])
endfunction "}}}

function! s:add(list) abort "{{{
  for item in a:list
    let config = item
    let url = remove(config, 'url')
    call minpac#add(url, config)
  endfor
endfunction "}}}

" Initialization {{{1


" 1}}}
