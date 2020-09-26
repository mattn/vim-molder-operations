function! molder#extension#operations#init() abort
  nnoremap <silent> <buffer> n :<c-u>call molder#extension#operations#newdir()<cr>
  nnoremap <silent> <buffer> d :<c-u>call molder#extension#operations#delete()<cr>
  nnoremap <silent> <buffer> r :<c-u>call molder#extension#operations#rename()<cr>
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
      if delete(l:path, 'f') == -1
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

