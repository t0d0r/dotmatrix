#!/bin/sh


PATH="$PATH:/sw/bin:/Developer/usr/bin"
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
alias mutt.local="mutt -f /var/mail/$USER"
#alias mysql='mysql'
#alias mysqlstart='sudo /opt/local/bin/mysqld_safe5'
#alias mysqlstop='/opt/local/bin/mysqladmin5 -u root shutdown'
#alias mysqlstart='mysql.server start'
#alias mysqlstop='/usr/local/bin/mysqladmin -u root shutdown'
#alias pgstart="sudo /opt/local/etc/LaunchDaemons/org.macports.postgresql84-server/postgresql84-server.wrapper start"
#alias pgstop="sudo /opt/local/etc/LaunchDaemons/org.macports.postgresql84-server/postgresql84-server.wrapper stop"
#alias pgstart="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start"
#alias pgstop="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log stop"
alias pg.start='postgres -D /usr/local/var/postgres'
alias less='less -R'
alias groovysh="groovysh -C off"
alias rvm-prompt='PS1="\$(~/.rvm/bin/rvm-prompt) $PS1"'
alias pgw="ping -c 3 -s 1472 `netstat -rn| grep default | tr -s ' '| cut -d ' ' -f 2`"
alias lockme='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'
alias ppjson=json_reformat
#alias rbenv="CC=/usr/local/bin/gcc-4.2 rbenv"

# this fix crontab -e issue with vi
export EDITOR=vim

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

# interactive or not, that is the question...
case "$-" in
  *i*)
    # this file must be kept away from github :)
    [[ -s "$HOME/.bash_env" ]] && source "$HOME/.bash_env"
    # Ruby Version Manager
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
    # bash completion
    [[ -s "/opt/local/etc/bash_completion" ]] && source /opt/local/etc/bash_completion
    # mercurial completion
    [[ -s "$HOME/.bash_completion_hg" ]] && source "$HOME/.bash_completion_hg"
    # fortune
    [[ -s "/usr/local/bin/fortune" ]] && echo && /usr/local/bin/fortune
    # rbenv /rvm replacement/
    [[ -d "$HOME/.rbenv" ]] && eval "$(rbenv init -)"
    # mysql
    [[ -s "$HOME/bin/mysql_env.sh" ]] && source "$HOME/bin/mysql_env.sh"
  ;;
esac

# this fix mvim environment
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# locate fix for mosh /t0d0r
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

#export PATH=$PATH:/usr/local/opt/go/libexec/bin
export GOPATH=/Users/t0d0r/work/gocode

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
