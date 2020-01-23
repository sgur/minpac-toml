scriptencoding utf-8



" Interface {{{1

function! minpac_toml#load(path) abort
  if !(exists('g:minpac#opt') && exists('g:minpac#pluglist'))
    echoerr '[minpac-toml] Call minpac#init() first'
    return
  endif

  let filename = expand(a:path, 1)

  if !filereadable(filename)
    echoerr '[minpac_toml] Unable to open:' a:path
    return
  endif

  let ext = fnamemodify(filename, ':e')
  let prefs = {}
  if ext is? 'toml'
    let prefs = minpac_toml#toml#load(filename)
  endif
  if empty(get(prefs, 'plugin', []))
    echoerr '[minpac_toml] no plugin entries found'
    return
  endif

  call map(
        \ filter(
        \   map(copy(prefs.plugin), 's:parse(v:val)'),
        \   '!empty(v:val)'),
        \ 'minpac#add(v:val[0], v:val[1])')
endfunction

function! minpac_toml#wrap(...) abort
  let arg = a:0 ? a:1 : {}
  return extend({'jobs': s:nproc()}, arg, 'force')
endfunction

" Internal {{{1

function! s:nproc() abort
  return str2nr(
        \ has('win32')
        \ ? $NUMBER_OF_PROCESSORS
        \ : executable('nproc')
        \   ? systemlist('nproc')[0]
        \   : executable('sysctl')
        \     ? systemlist('sysctl -n hw.ncpu')[0]
        \     : 8)

  " macOS : sysctl -n machdep.cpu.cores_per_pacakge でもよさそう
endfunction

function! s:parse(plugin) abort "{{{
  let config = a:plugin
  " Prerocess config.do hooks
  if has_key(config, 'do') && type(config.do) == v:t_string
    let hook = substitute(config.do, "\n", '', 'g')
    let config.do = s:validate_hook(hook)
  endif

  try
    let url = remove(config, 'url')
    return [url, config]
  catch /^Vim\%((\a\+)\)\=:E716/
    echohl ErrorMsg | echomsg v:exception | echohl NONE
  endtry
  return []
endfunction "}}}

function! s:validate_hook(str) abort "{{{
  try
    if a:str =~# '^{.*->.\+}$'
      " eval as a lambada
      return eval(a:str)
    endif

    let funcname = a:str
    if funcname =~# 'function([''"].\+[''"])'
      let funcname = matchstr(a:str, 'function([''"]\zs.\+\ze[''"])')
    endif
    " Assumed as a function name
    return function(funcname)
  catch /^Vim\%((\a\+)\)\=:E\(15\|121\|129\|475\|700\)/
    " as an ex-command
    return a:str
  endtry
endfunction "}}}


" Initialization {{{1

try
  packadd minpac
catch /^Vim\%((\a\+)\)\=:E919/
finally
  if !exists('g:loaded_minpac')
    echoerr 'minpack not installed'
    finish
  endif
endtry

" 1}}}
