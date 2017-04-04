#!/bin/sh

# workaround for cvs to use ssh as transfer protocol
PATH="$HOME/bin:$PATH"
CVS_RSH=ssh
export PATH CVS_RSH

alias ls='ls -G'
alias ll='ls -al'
alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'
alias less='less -R'
alias r='rails'
alias mvim='mvim --servername `basename $PWD`'

alias aea='ansible all -m shell -o -a '
alias dotmatrix='eval $(~/bin/dotmatrix)'
alias groovysh="groovysh -C off"
alias less='less -R'
alias lmk='say '\''Process complete.'\'''
alias lockme='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'
alias moon='curl -s wttr.in/Moon'
alias mutt.local="mutt -f /var/mail/$USER"
alias pg.start='postgres -D /usr/local/var/postgres'
alias pgw="ping -c 3 -s 1472 `netstat -rn| grep default | tr -s ' '| cut -d ' ' -f 2`"
alias ppjson=json_reformat
alias rbenv.init='eval "$(rbenv init -)"'
alias rvm-prompt='PS1="\$(~/.rvm/bin/rvm-prompt) $PS1"'
alias sca="./scp_all.rb"
alias sea="./ssh_exec_all.rb"
alias t='todo.sh'
alias todo='todo.sh'
alias tree='find . -print | sed -e '\''s;[^/]*/;|____;g;s;____|; |;g'\'''
alias weather='curl -s wttr.in | head -7'
alias rpry="pry -r ./config/environment"

#alias rbenv="CC=/usr/local/bin/gcc-4.2 rbenv"
function title { echo -ne "\033]0;"$*"\007"; }

# this fix crontab -e issue with vi
export EDITOR=vim

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
    if [ -d ~/.screen.d ]; then
      for i in `ls ~/.screen.d`; do
        alias screen.${i}="screen -list | grep ${i} && screen -r -D ${i} || screen -S ${i} -c ~/.screen.d/${i}"
      done
    fi
    #export PATH=$PATH:/usr/local/opt/go/libexec/bin
    export GOPATH=/Users/t0d0r/work/gocode
    [[ -f ~/.bashrc ]] && source ~/.bashrc

    [[ -d ~/Documents/todo ]] && echo && /usr/local/bin/todo.sh ls

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
