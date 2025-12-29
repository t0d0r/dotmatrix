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

nnoremap <C-a> <nop>
nnoremap <C-x> <nop>
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
inoremap <F3> <C-R>=strftime("<%Y-%m-%d %a %H:%M>")<CR>
nnoremap <F3> i<C-R>=strftime("<%Y-%m-%d %a %H:%M>")<CR><Esc>
nnoremap <F4> :call NERDTreeToggleFix()<CR>
nnoremap <F4> :call ToggleOrFocusNERDTree()<CR>
nnoremap <S-F4> :NERDTreeFocus<CR>
nnoremap <F5> :GundoToggle<CR>
nnoremap <F6> :BuffergatorToggle<CR>
"nnoremap <F7> :call SmartPrev()<CR>
" Toggle copen
"nnoremap <F8> :if &buftype ==# 'quickfix' \| cclose \| else \| copen \| endif<CR>
"nnoremap <F9> :call SmartNext()<CR>
map <F7> [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
map <F8> :echo synIDattr(synID(line("."),col("."),1),"name")<CR>
" shift + f7,f8,f9
nnoremap <F19> :tabprev<CR>
nnoremap <F20> :tabedit %<CR>
nnoremap <F21> :tabnext<CR>
nnoremap <S-F7> :tabprev<CR>
nnoremap <S-F8> :tabedit %<CR>
nnoremap <S-F9> :tabnext<CR>
