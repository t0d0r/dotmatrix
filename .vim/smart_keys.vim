function! IsQuickfixOpen()
  return len(filter(range(1, winnr('$')), 'getwinvar(v:val, "&buftype") == "quickfix"')) > 0
endfunction

function! SmartPrev()
  if IsQuickfixOpen()
    cprev
  else
    bprev
  endif
endfunction

function! SmartNext()
  if IsQuickfixOpen()
    cnext
  else
    bnext
  endif
endfunction

function! ToggleOrFocusNERDTree()
  if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
    if bufname("%") == t:NERDTreeBufName
      NERDTreeToggle
    else
      execute bufwinnr(t:NERDTreeBufName) . "wincmd w"
    endif
  else
    NERDTreeToggle
  endif
endfunction

augroup nerdtree_tab
  autocmd!
  autocmd FileType nerdtree nnoremap <buffer> <Tab> <C-W>w
augroup END

autocmd QuickFixCmdPost [^l]* cwindow
autocmd QuickFixCmdPost    l* lwindow

nnoremap <F4> :call ToggleOrFocusNERDTree()<CR>
nnoremap <F7> :call SmartPrev()<CR>
" Toggle copen
nnoremap <F8> :if &buftype ==# 'quickfix' \| cclose \| else \| copen \| endif<CR>
nnoremap <F9> :call SmartNext()<CR>
" shift + f7,f8,f9
nnoremap <F19> :tabprev<CR>
nnoremap <F20> :tabedit %<CR>
nnoremap <F21> :tabnext<CR>
nnoremap <S-F7> :tabprev<CR>
nnoremap <S-F8> :tabedit %<CR>
nnoremap <S-F9> :tabnext<CR>
