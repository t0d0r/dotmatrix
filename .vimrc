
" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=500		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq
" , #perl # comments
map ,# :s/^/#/<CR>
" ,/ C/C++/C#/Java // comments
map ,/ :s/^/\/\//<CR>
" ,< HTML comment
map ,< :s/^\(.*\)$/<!-- \1 -->/<CR><Esc>:nohlsearch<CR>
" c++ java style comments
map ,* :s/^\(.*\)$/\/\* \1 \*\//<CR><Esc>:nohlsearch<CR>

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" t0d0r settings starts here
" also take look in ~/.gvimrc

" Fix crontab temp file problem: 'must be edited in place'
if expand('%:r:r') =~? "crontab"
	set nobackup
	colorscheme zellner
endif

" settings for viewoutput.vim
let g:viewoutput_newbuffer="tabedit"

set noerrorbells
set visualbell
set nocompatible
set history=500
" add dictionary to CTRL-P completion, and remove include search
" set dictionary=/usr/share/dict/words
set complete+=k
set complete-=i
" highlightings
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/

" maps to work with ruby
map <F7>	:ccl<CR>
map <F8>	:make %<CR>
map <F9>	:copen<CR>
map ,R		:compiler ruby<CR>
map ,r		:make %<CR>
" edit and reload .vimrc
map ,v		:sp ~/.vimrc<CR>
map ,V		:source ~/.vimrc<CR>

set lcs=tab:\ \ ,eol:$,trail:~,extends:>,precedes:<

augroup BgHighlight
    autocmd!
    "highlight LineNr ctermfg=3 guibg=red
    "autocmd WinEnter * call matchadd('LineNr', '.*', 10, 1682)
    "autocmd WinLeave * call matchdelete(1682)
    autocmd WinEnter * highlight LineNr guifg=red
    autocmd WinLeave * highlight LineNr guifg=yellow
    "autocmd WinEnter * set number
    "autocmd WinLeave * set nonumber
augroup END

doautocmd BgHighlight WinEnter -
