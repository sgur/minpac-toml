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
  if has_key(config, 'do') && type(config.do) == v:t_string
    try
      " Assumed as an user functions
      let config.do = function(config.do)
    catch /^Vim\%((\a\+)\)\=:E\(15\|121\|129\|700\)/
      if config.do =~# '^{.\+}$'
        " as a lambada
        let config.do = eval(config.do)
      else
        " as an ex-command
      endif
    endtry
  endif

  try
    let url = remove(config, 'url')
    call minpac#add(url, config)
  catch /^Vim\%((\a\+)\)\=:E716/
    echohl ErrorMsg | echomsg v:exception | echohl NONE
  endtry
endfunction "}}}

" Initialization {{{1


" 1}}}
