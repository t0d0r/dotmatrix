This directory is a part from Janus VIM plugin.

To install janus remove all .vim files and directories in your home and
execute:

```
curl -Lo- https://bit.ly/janus-bootstrap | bash
```

# Gui Fonts

* "Envy":http://damieng.com/blog/2008/05/26/envy-code-r-preview-7-coding-font-released
* "Monofur":http://www.dafont.com/monofur.font
* "Fira":https://www.mozilla.org/en-US/styleguide/products/firefox-os/typeface/
* "basis33":https://dl.dropboxusercontent.com/u/1975326/fonts/basis33.regular.ttf
** original source: http://www.1001fonts.com/basis33-font.html

# Bundles

List of all submodules added to additionaly to VIM.
Must be execited in 'dotmatrix' directory!

```
  git submodule add git://github.com/godlygeek/tabular.git .janus/tabular
  git submodule add https://github.com/Valloric/YouCompleteMe.git .janus/YouCompleteMe
  git submodule add https://github.com/henrik/vim-ruby-runner .janus/ruby-runner
  git submodule add https://github.com/jceb/vim-orgmode.git .janus/vim-orgmode
  git submodule add https://github.com/lambdalisue/vim-gista.git .janus/vim-gista
  git submodule add https://github.com/mhinz/vim-signify.git .janus/vim-signify
  git submodule add https://github.com/vim-scripts/Rename2.git .janus/rename2
  git submodule add https://github.com/vim-scripts/VimRepress.git .janus/vim-repress
  git submodule add https://github.com/vim-scripts/nerdtree-ack.git .janus/nerdtree-ack
  git submodule add https://github.com/vim-scripts/timestamp.vim.git .janus/timestamp.vim
  git submodule add https://github.com/vim-scripts/QFGrep.vim.git .janus/QFGrep
  git submodule add https://github.com/zainin/vim-mikrotik.git .janus/vim-mikrotik
  git submodule add https://github.com/vim-scripts/DirDiff.vim.git .janus/dirdiff
  git submodule add https://github.com/mattn/emmet-vim.git .janus/emmet
  git submodule add https://github.com/editorconfig/editorconfig-vim.git .janus/editorconfig
  git submodule add https://github.com/ngmy/vim-rubocop.git .janus/vim-rubocop
  git submodule add git@github.com:mvgrimes/vim-trackperlvars.git .janus/vim-trackperlvars
  git submodule add https://github.com/hwartig/vim-seeing-is-believing.git .janus/vim-seeing-is-believing
  git submodule add https://github.com/fatih/vim-go.git .janus/vim-go
  git submodule add https://github.com/dracula/vim.git .janus/dracula-theme
```

# Useful modules or commands

## GUI related

```vim
:FULL
:WHITE
:BLACK
:NORMAL
:MONODELL
:ENVY
:FIRA
:VT220
:CONSOLE
:RUBYMINE
```

### Folding

```vim
:Zmanual
:Zindex
:Zsyntax
```

## GIT related

```vim
:Gstatus
:Gcommit
:Gdiff
```

vim: syntax=markdown tw=80 expandtab
