#!/bin/sh


PATH="$PATH:/sw/bin:/Developer/usr/bin/"
export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:$PATH"

# workaround for cvs to use ssh as transfer protocol
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
alias mysql='mysql5'
alias mysqlstart='sudo /opt/local/bin/mysqld_safe5'
alias mysqlstop='/opt/local/bin/mysqladmin5 -u root shutdown'
alias pgstart="sudo /opt/local/etc/LaunchDaemons/org.macports.postgresql84-server/postgresql84-server.wrapper start"
alias pgstop="sudo /opt/local/etc/LaunchDaemons/org.macports.postgresql84-server/postgresql84-server.wrapper stop"
alias less='less -R'
alias groovysh="groovysh -C off"

# history related
export HISTIGNORE="??"
export HISTCONTROL=ignoreboth
export HISTSIZE=512

#export PS1="dir.= \W> "
#export PS1="\[\033]0;\W\007\] \W> "
export PS1="\[\e[32;1m\]\W> \[\e[0m\]"

test -r /sw/bin/init.sh && . /sw/bin/init.sh

# PATH for DarwinPorts
export PATH="~/bin:/opt/local/bin:/opt/local/sbin:$PATH"
export MANPATH="/opt/local/share/man:$MANPATH"
scname=".scriptype."`date +"%y%m%d%H%M%S"`
#script -qa ~/$scname && logout

export NODE_PATH="~/.npm"

# this file must be kept away from github :)
[[ -s "$HOME/.bash_env" ]] && source "$HOME/.bash_env"

# Ruby Version Manager
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"


[[ -s "$HOME/.bash_completion_hg" ]] && source "$HOME/.bash_completion_hg"

if [ -f /opt/local/etc/bash_completion ]; then
      . /opt/local/etc/bash_completion
fi
