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

alias mutt.local="mutt -f /var/mail/$USER"
alias pg.start='postgres -D /usr/local/var/postgres'
alias less='less -R'
alias groovysh="groovysh -C off"
alias rvm-prompt='PS1="\$(~/.rvm/bin/rvm-prompt) $PS1"'
alias pgw="ping -c 3 -s 1472 `netstat -rn| grep default | tr -s ' '| cut -d ' ' -f 2`"
alias lockme='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'
alias ppjson=json_reformat
alias rbenv.init='eval "$(rbenv init -)"'
alias dotmatrix='eval $(~/bin/dotmatrix)'

alias aea='ansible all -m shell -o -a '
alias sca="./scp_all.rb"
alias sea="./ssh_exec_all.rb"
alias tree='find . -print | sed -e '\''s;[^/]*/;|____;g;s;____|; |;g'\'''
alias lmk='say '\''Process complete.'\'''
#alias rbenv="CC=/usr/local/bin/gcc-4.2 rbenv"

# this fix crontab -e issue with vi
export EDITOR=vim

# history related
export HISTIGNORE="??"
export HISTCONTROL=ignoreboth
export HISTSIZE=1024

#export PS1="dir.= \W> "
#export PS1="\[\033]0;\W\007\] \W> "
export PS1="\[\e[32;1m\]\W> \[\e[0m\]"

# PATH for DarwinPorts
export PATH="~/bin:/opt/local/bin:/opt/local/sbin:$PATH"
export MANPATH="/opt/local/share/man:$MANPATH"
scname=".scriptype."`date +"%y%m%d%H%M%S"`
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

  ;;
esac

# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# locale fix for mosh /t0d0r
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

# Path to the bash it configuration
export BASH_IT="/Users/t0d0r/.bash_it"

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='bobby'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/xvzf/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# Load Bash It
# source $BASH_IT/bash_it.sh
