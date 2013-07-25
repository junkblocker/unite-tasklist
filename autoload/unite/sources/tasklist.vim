let s:unite_source = {
      \ 'name': 'tasklist',
      \ 'description': 'task list from the current file',
      \ }

function! s:unite_source.gather_candidates(args, context)
  let l:candidates = []
  let l:tpath = expand('%:p')
  let l:tbufnr = bufnr('%')
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
  endif
  let l:tcnt = 1
  for s:tline in getbufline('%', 1, '$')
    if s:tline =~ l:regexp
      call extend(l:candidates, [{
            \ "word": s:tline,
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
