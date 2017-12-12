scriptencoding utf-8



" Interface {{{1

function! minpac#loader#cli(force_restart, ...) abort
  let args = uniq(sort(copy(a:000)))
  let cmd = {}
  for op in ['clean', 'update']
    let idx = index(args, '-' . op)
    if idx > -1
      let cmd[op] = 1
      call remove(args, idx)
    endif
  endfor

  let path = get(filter(map(args, 'expand(v:val)'), 'filereadable(v:val)'), 0, '')
  if empty(path)
    echohl WarningMsg | echomsg '[minpac-loader] No file specified' | echohl None
    return
  endif

  let fns = []
  if has_key(cmd, 'clean')
    let fns += [{'fn': function('minpac#clean')}]
  endif
  if has_key(cmd, 'update')
    let fns += [{'fn': function('minpac#update'), 'restart': a:force_restart}]
  endif
  if empty(fns)
    echohl WarningMsg | echomsg '[minpac-loader] No command specified' | echohl None
    return
  endif
  call minpac#loader#load(path, fns)
endfunction

function! minpac#loader#complete(arglead, cmdline, cursorpos) abort
  let args = split(a:cmdline, '\s\+')[1:]
  let cmds = empty(a:arglead) || a:arglead[0] is# '-'
        \ ? filter(['-clean', '-update'], 'index(args, v:val) == -1')
        \ : []
  return cmds + getcompletion(a:arglead, 'file')
endfunction

function! minpac#loader#load(path, cmd_list) abort
  call minpac#init({'jobs': minpac#loader#nproc()})

  let filename = expand(a:path)

  if !filereadable(filename)
    echohl WarningMsg | echomsg '[minpac-loader] Unable to open:' a:path | echohl None
    return
  endif

  let ext = fnamemodify(filename, ':e')
  let prefs = {}
  if ext is? 'toml'
    let prefs = minpac#loader#toml#load(filename)
  endif
  if ext is? 'json'
    let prefs = minpac#loader#json#load(filename)
  endif
  if empty(prefs) || empty(get(prefs, 'plugins', []))
    echohl WarningMsg | echomsg "[minpac-loader] no plugin entries found" | echohl None
    return
  endif

  call map(
        \ filter(
        \   map(copy(prefs.plugins), 's:check(v:val)'),
        \   '!empty(v:val)'),
        \ 'minpac#add(v:val[0], v:val[1])')

  for cmd in a:cmd_list
    let restart_on_changed = get(cmd, 'restart', 0)
    call call(cmd.fn, [],
          \ restart_on_changed ? {'do': function('s:hook_restart_on_update_finished')} : {})
  endfor

endfunction

function! minpac#loader#nproc() abort
  return s:nproc
endfunction


" Internal {{{1

function! s:check(plugin) abort "{{{
  let config = a:plugin
  " Prerocess config.do hooks
  if has_key(config, 'do') && type(config.do) == v:t_string
    let hook = substitute(config.do, "\n", '', 'g')
    let config.do = s:convert_hook_from(hook)
  endif

  try
    let url = remove(config, 'url')
    return [url, config]
  catch /^Vim\%((\a\+)\)\=:E716/
    echohl ErrorMsg | echomsg v:exception | echohl NONE
  endtry
  return []
endfunction "}}}

function! s:convert_hook_from(str) abort "{{{
  try
    if a:str =~# 'function(.\+)'
      " as a funcref
      return eval(a:str)
    endif
    if a:str =~# '^{.\+}$'
      " as a lambada
      return eval(a:str)
    endif
    " Assumed as a function name
    return function(a:str)
  catch /^Vim\%((\a\+)\)\=:E\(15\|121\|129\|475\|700\)/
    " as an ex-command
    return a:str
  endtry
endfunction "}}}

function! s:hook_restart_on_update_finished(hooktype, updated, installed) abort "{{{
  if !(a:updated + a:installed)
    return
  endif
  if get(g:, 'loaded_restart', 0) && exists(':Restart') == 2
    Restart
  endif
endfunction "}}}


" Initialization {{{1



" 1}}}

try
  packadd minpac
catch /^Vim\%((\a\+)\)\=:E919/
finally
  if !exists('g:loaded_minpac')
    echoerr 'minpack not installed'
    finish
  endif
endtry


let s:nproc = has('win32')
      \ ? $NUMBER_OF_PROCESSORS
      \ : executable('nproc')
      \   ? systemlist('nproc')[0]
      \   : executable('sysctl')
      \     ? systemlist('sysctl -n hw.ncpu')[0]
      \     : 4

" macOS : sysctl -n machdep.cpu.cores_per_pacakge でもよさそう
