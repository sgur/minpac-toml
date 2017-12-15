scriptencoding utf-8



" Interface {{{1

function! minpac#loader#json#load(path) abort
  let prefs = s:load_json(a:path)
  if !has_key(prefs, 'plugins')
    return {}
  endif
  call map(prefs.plugins, 's:normalize(v:val)')
  return prefs
endfunction

" Internal {{{1

function! s:load_json(path) abort "{{{
  let str = join(readfile(a:path), ' ')
  let json = json_decode(str)
  let plugins = has_key(json, 'plugins')
        \ ? map(json.plugins, 'type(v:val) == v:t_string ? {"url": v:val} : v:val')
        \ : json.start + map(json.opt, 'extend(v:val, {''type'': ''opt''}, ''keep'')')
  return {
        \ 'plugins' : plugins
        \ }
endfunction "}}}

function! s:normalize(entry) abort "{{{
  if type(a:config) == v:t_dict
    return a:entry
  else
    return {'url': a:entry}
  endif
endfunction "}}}


" Initialization {{{1



" 1}}}
