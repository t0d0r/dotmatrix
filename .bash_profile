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
alias r='rails'
alias mvim='mvim --servername `basename $PWD`'
alias mysql='mysql5'
alias mysqlstart='sudo /opt/local/bin/mysqld_safe5'
alias mysqlstop='/opt/local/bin/mysqladmin5 -u root shutdown'

#export PS1="dir.= \W> "
export PS1="\[\033]0;\W\007\] \W> "

test -r /sw/bin/init.sh && . /sw/bin/init.sh

# PATH for DarwinPorts
export PATH="~/bin:/opt/local/bin:/opt/local/sbin:$PATH"
export MANPATH="/opt/local/share/man:$MANPATH"
scname=".scriptype."`date +"%y%m%d%H%M%S"`
#script -qa ~/$scname && logout

# this file must be kept away from github :)
[[ -s "$HOME/.bash_env" ]] && source "$HOME/.bash_env"

# Ruby Version Manager
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

