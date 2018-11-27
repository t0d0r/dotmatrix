#!/bin/sh

# workaround for cvs to use ssh as transfer protocol
PATH="$HOME/bin:$PATH"
CVS_RSH=ssh
export PATH CVS_RSH

function title { echo -ne "\033]0;"$*"\007"; }

# this fix crontab -e issue with vi
export EDITOR=vim
export VISUAL=vim

# history related
export HISTIGNORE="??"
export HISTCONTROL=ignoreboth
export HISTSIZE=1024

#export PS1="dir.= \W> "
#export PS1="\[\033]0;\W\007\] \W> "
export PS1="\[\e[32;1m\]\W> \[\e[0m\]"

if [ $ITERM_SESSION_ID ]; then
  export PROMPT_COMMAND='echo -ne "\033];${PWD##*/}\007"; ':"$PROMPT_COMMAND";
fi
#scname=".scriptype."`date +"%y%m%d%H%M%S"`
#script -qa ~/$scname && logout

export NODE_PATH="~/.npm"

# interactive or not, that is the question...
case "$-" in
  *i*)
    # this file must be kept away from github :)
    [[ -s "$HOME/.bash_env" ]] && source "$HOME/.bash_env"
#    # Ruby Version Manager
#    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
    # bash completion
#    [[ -s "/opt/local/etc/bash_completion" ]] && source /opt/local/etc/bash_completion
    # mercurial completion
    [[ -s "$HOME/.bash_completion_hg" ]] && source "$HOME/.bash_completion_hg"
    # fortune
    [[ -s "/usr/local/bin/fortune" ]] && echo && /usr/local/bin/fortune
    # rbenv /rvm replacement/
    [[ -d "$HOME/.rbenv" ]] && eval "$(rbenv init -)"
#    # mysql
#    [[ -s "$HOME/bin/mysql_env.sh" ]] && source "$HOME/bin/mysql_env.sh"
    # build aleases based on ~/.screen.d
    #export PATH=$PATH:/usr/local/opt/go/libexec/bin
    export GOPATH=~/work/gocode
    export PATH=$PATH:$GOPATH/bin
    [[ -f ~/.bashrc ]] && source ~/.bashrc

    [[ `hostname` = 'do.linuxfan.org' ]] && last | head

    if [ -d ~/.profile.d ]; then
      for i in ~/.profile.d/*.sh; do
        if [ -r $i ]; then
          . $i
        fi
      done
      unset i
    fi

  ;;
esac

# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# locale fix for mosh /t0d0r
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
export PATH="/usr/local/opt/curl/bin:$PATH"
