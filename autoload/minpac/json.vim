scriptencoding utf-8



" Interface {{{1

function! minpac#json#load(path) abort
  let list = s:load(a:path)
  call s:add(list)
endfunction

" Internal {{{1

function! s:load(path) abort "{{{
  let str = join(readfile(a:path), ' ')
  let json = json_decode(str)
  if has_key(json, 'plugins')
    return map(json.plugins, 'type(v:val) == v:t_string ? {"url": v:val} : v:val')
  else
    return json.start + map(json.opt, 'extend(v:val, {''type'': ''opt''}, ''keep'')')
  endif
endfunction "}}}

function! s:add(list, ...) abort "{{{
  let default = a:0 ? a:1 : {}
  for item in a:list
    if type(item) == v:t_dict
      let config = extend(copy(item), copy(default), 'keep')
      let url = remove(config, 'url')
      call minpac#add(url, config)
    else
      call minpac#add(item, default)
    endif
  endfor
endfunction "}}}


" Initialization {{{1



" 1}}}
