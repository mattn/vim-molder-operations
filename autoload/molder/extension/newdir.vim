function! molder#extension#newdir#init() abort
  nnoremap <buffer> n :<c-u>call molder#extension#newdir#newdir()<cr>
endfunction

function! molder#extension#newdir#newdir() abort
  let l:name = input('Create Directory: ')
  if empty(l:name)
    return
  endif

  if l:name == '.' || l:name == '..' || l:name =~# '[/\\]'
    call molder#error('Invalid directory name: ' .. l:name)
    return
  endif
  call mkdir(molder#curdir() .. l:name)
  call molder#reload()
endfunction
