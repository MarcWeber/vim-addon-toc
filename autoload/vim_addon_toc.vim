if !exists('g:vim_addon_toc') | let g:vim_addon_toc = {} | endif | let s:c = g:vim_addon_toc

fun! vim_addon_toc#ToCFiletype()
  if has_key(s:c, &filetype)
    call vim_addon_toc#ToC(s:c[&filetype])
  else
    echoe "not default toc regex defined for fileltype ".&filetype." :-( , do you like to provide one?"
  endif
endfun

fun! vim_addon_toc#VimRegexToGrepRegex(regex)
  " yes, this is horribly incomplete
  let s = a:regex
  for x in ['\\%(=>\\(', '\\s=>[ \\t]', '\\+=>+','\\S=>[^ \\t]']
    let m = split(x,'=>')
    let s = substitute(s, m[0], m[1], 'g')
  endfor
  return s
endf

fun! vim_addon_toc#ToC(regex)
  call system('grep --help')
  let cursorAt = -1
  let curr_line = line('.')
  if v:shell_error == 0
    " use grep implementation for speed
    let lines = []
    let r = has_key(a:regex,'grep') ? a:regex.grep : vim_addon_toc#VimRegexToGrepRegex(a:regex.vim)

    let cmd = 'grep -ne '.escape(r,'*|\ !$%[]()^'."'\"")

    let tmp = tempname()
    exec 'w ! '.cmd.' > '.tmp
    " let r = system(cmd, join(getline(0,'$'),"\n"))
    let items = readfile(tmp)
    call delete(tmp)
    for idx in range(0, len(items)-1)
      let m = matchlist(items[idx], '^\(\d\+\):\(.*\)$')
      if cursorAt == -1
       if m[1] > curr_line
         let cursorAt = idx -1 
       elseif m[1] == curr_line
         let cursorAt = idx
       endif
      endif
      call add(lines, {'nr': m[1], 'line' :m[2]})
    endfor
  else
    " use vim implemenation
    let nr=1
    let r = a:regex.vim
    let lines = []
    let idx = 0
    for l in getline(0,line('$'))
      if cursorAt == -1
        if idx > curr_line
          let cursorAt = idx -1 
       elseif idx == curr_line
          let cursorAt = idx
        endif
      endif
      if l =~ r 
        let idx += 1
        call add(lines, {'nr': idx+1, 'line' :l}) 
      endif
    endfor
  endif

  if cursorAt == -1
    let cursorAt = len(lines)-1
  endif
  " 'filter' : [{'keep' : 1, 'regex' : a:regex }],
  call tovl#ui#filter_list#ListView({
        \ 'aligned' : 0,
        \ 'keys' : ['nr','line'],
        \ 'number' : 1,
        \ 'selectByIdOrFilter' : 1,
        \ 'Continuation' : funcref#Function('exec ARGS[0]["nr"]'),
        \ 'items' : lines,
        \ 'syn_cmds' : ['runtime! syntax/'.&filetype.'.vim'],
        \ 'cmds' : ['normal zR'],
        \ 'cursorAt' : cursorAt
        \ })
endfun
