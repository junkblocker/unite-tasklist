let s:unite_source = {
      \ 'name': 'tasklist',
      \ 'description': 'task list from the current file',
      \ 'hooks': {},
      \ }

"inspired from 'unite-outline'
function! s:Source_Hooks_on_init(args, context)
    let a:context.source__tasklist_source_bufnr = bufnr('%')
    let a:context.source__tasklist_source_path = expand('%:p')
endfunction

function! s:get_SID()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction
let s:SID = s:get_SID()
delfunction s:get_SID

let s:unite_source.hooks.on_init = function(s:SID . 'Source_Hooks_on_init')

function! s:unite_source.gather_candidates(args, context)
  let l:candidates = []
  let l:tpath = a:context.source__tasklist_source_path
  let l:tbufnr = a:context.source__tasklist_source_bufnr
  let l:wordlist = get(g:, 'unite_tasklist_tokens', [
        \ 'BUG',
        \ 'CAUTION',
        \ 'ERROR',
        \ 'FIXME',
        \ 'HACK',
        \ 'PATCH',
        \ 'TBD',
        \ 'TODO',
        \ 'WARNING',
        \ 'XXX',
        \])
  let l:regexp = '\v<(' . join(l:wordlist, '|') . ')>'
  if get(g:, 'unite_tasklist_ignorecase', 0)
    let l:regexp = '\c' . l:regexp
else
    let l:regexp = '\C' . l:regexp
  endif
  let l:tcnt = 1
  for s:tline in getbufline(l:tbufnr, 1, '$')
    let l:res = matchlist(s:tline, l:regexp)
    if !empty(l:res)
      call extend(l:candidates, [{
            \ "word": l:tcnt . ' ' . l:res[1] . ': ' . s:tline,
            \ "source": "tasklist",
            \ "kind": "jump_list",
            \ "action__path": l:tpath,
            \ "action__line": l:tcnt,
            \ "action__buf_nr": l:tbufnr,
            \ }])
    endif
    let l:tcnt = l:tcnt + 1
  endfor
  return l:candidates
endfunction

function! unite#sources#tasklist#define()
  return s:unite_source
endfunction
