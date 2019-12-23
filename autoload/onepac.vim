scriptencoding utf-8



" Interface {{{1

function! onepac#cli(force_restart, visual, ...) abort
  if a:visual > 0
    let path = fnamemodify(tempname(), 'r') . '.toml'
    call writefile(getline(line("'<"), line("'>")), path)
    let fns = [{'fn': function('minpac#update')}]
    let fns += [{'fn': {-> delete(path)}}]
    call onepac#load(path, fns)
    return
  endif
  let args = uniq(sort(copy(a:000)))
  let cmd = {}
  for op in ['clean', 'update']
    let idx = index(args, '-' . op)
    if idx > -1
      let cmd[op] = 1
      call remove(args, idx)
    endif
  endfor
  if empty(cmd)
    let cmd['update'] = 1 " Update as default
  endif

  let path = get(filter(map(args, 'expand(v:val)'), 'filereadable(v:val)'), 0, '')
  if empty(path)
    echoerr '[onepac] pacakge list file (*.toml, *.json) required.'
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
    echoerr '[onepac] No command specified'
    return
  endif
  call onepac#load(path, fns)
endfunction

function! onepac#complete(arglead, cmdline, cursorpos) abort
  let args = split(a:cmdline, '\s\+')[1:]
  let cmds = empty(a:arglead) || a:arglead[0] is# '-'
        \ ? filter(['-clean', '-update'], 'index(args, v:val) == -1')
        \ : []
  return cmds + getcompletion(a:arglead, 'file')
endfunction

function! onepac#load(path, cmd_list) abort
  call minpac#init({'jobs': onepac#nproc()})

  let filename = expand(a:path, 1)

  if !filereadable(filename)
    echoerr '[onepac] Unable to open:' a:path
    return
  endif

  let ext = fnamemodify(filename, ':e')
  let prefs = {}
  if ext is? 'toml'
    let prefs = onepac#toml#load(filename)
  endif
  if ext is? 'json'
    let prefs = onepac#json#load(filename)
  endif
  if empty(get(prefs, 'plugins', []))
    echoerr '[onepac] no plugin entries found'
    return
  endif

  call map(
        \ filter(
        \   map(copy(prefs.plugins), 's:parse(v:val)'),
        \   '!empty(v:val)'),
        \ 'minpac#add(v:val[0], v:val[1])')

  for cmd in a:cmd_list
    let restart_on_changed = get(cmd, 'restart', 0)
    call call(cmd.fn, [],
          \ restart_on_changed ? {'do': function('s:hook_restart_on_update_finished')} : {})
  endfor

endfunction

function! onepac#nproc() abort
  return s:nproc
endfunction


" Internal {{{1

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
