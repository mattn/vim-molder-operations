function! molder#extension#operations#init() abort
  nnoremap <plug>(molder-operations-newdir) :<c-u>call molder#extension#operations#newdir()<cr>
  nnoremap <plug>(molder-operations-delete) :<c-u>call molder#extension#operations#delete()<cr>
  nnoremap <plug>(molder-operations-rename) :<c-u>call molder#extension#operations#rename()<cr>
  nnoremap <plug>(molder-operations-command) :<c-u>call molder#extension#operations#command()<cr>
  nnoremap <plug>(molder-operations-shell) :<c-u>call molder#extension#operations#shell()<cr>

  if !hasmapto('<plug>(molder-operations-newdir)')
    nmap <buffer> <leader>n <plug>(molder-operations-newdir)
  endif
  if !hasmapto('<plug>(molder-operations-delete)')
    nmap <buffer> <leader>d <plug>(molder-operations-delete)
  endif
  if !hasmapto('<plug>(molder-operations-rename)')
    nmap <buffer> <leader>r <plug>(molder-operations-rename)
  endif
  if !hasmapto('<plug>(molder-operations-command)')
    nmap <buffer> <leader>! <plug>(molder-operations-command)
  endif
  if !hasmapto('<plug>(molder-operations-shell)')
    nmap <buffer> <leader>s <plug>(molder-operations-shell)
  endif
endfunction

function! molder#extension#operations#newdir() abort
  let l:name = input('Create directory: ')
  if empty(l:name)
    return
  endif

  if l:name == '.' || l:name == '..' || l:name =~# '[/\\]'
    call molder#error('Invalid directory name: ' .. l:name)
    return
  endif
  try
    if mkdir(molder#curdir() .. l:name) ==# 0
      throw 'failed'
    endif
  catch
    call molder#error('Create directory failed')
    return
  endtry
  call molder#reload()
endfunction

function! molder#extension#operations#delete() abort
  let l:name = molder#current()
  if confirm('Delete?: ' .. l:name, "&Yes\n&No\n&Force", 2) ==# 2
    return
  endif
  let l:path = molder#curdir() .. l:name
  if isdirectory(l:path)
    try
      if delete(l:path, 'rf') == -1
        throw 'failed'
      endif
    catch
      call molder#error('Delete directory failed')
      return
    endtry
  else
    try
      if delete(l:path) == -1
        throw 'failed'
      endif
    catch
      call molder#error('Delete file failed')
      return
    endtry
  endif
  call molder#reload()
endfunction

function! molder#extension#operations#rename() abort
  let l:old = substitute(molder#current(), '/$', '', '')
  let l:new = input('Rename: ', l:old)
  if empty(l:new) || l:new ==# l:old
    return
  endif

  if l:new == '.' || l:new == '..' || l:new =~# '[/\\]'
    call molder#error('Invalid name: ' .. l:new)
    return
  endif
  try
    if rename(molder#curdir() .. l:old, molder#curdir() .. l:new) !=# 0
      throw 'failed'
    endif
  catch
    call molder#error('Rename failed')
    return
  endtry
  call molder#reload()
endfunction

function! molder#extension#operations#command() abort
  let l:path = molder#curdir() .. molder#current()
  call feedkeys(':! ' .. shellescape(l:path) .. "\<c-home>\<right>", 'n')
endfunction

function! molder#extension#operations#shell() abort
  call term_start(&shell, {'cwd': molder#curdir()})
endfunction

