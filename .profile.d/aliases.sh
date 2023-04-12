# linux flavour
# if [ -x /usr/bin/dircolors ]; then
#     test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
#     alias ls='ls --color=auto'
#     #alias dir='dir --color=auto'
#     #alias vdir='vdir --color=auto'
#
#     alias grep='grep --color=auto'
#     alias fgrep='fgrep --color=auto'
#     alias egrep='egrep --color=auto'
# fi
# if [ -x /usr/local/bin/trash ]; then
#   alias rm='trash'
# fi

alias ls='ls -G' # *bsd option for coloring
alias ll='ls -al'

alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'

[ -f /usr/local/bin/trash ] && alias rm="trash"

alias less='less -R'
alias r='rails'
alias mvim='mvim --servername `basename $PWD` --remote-tab-silent'

#alias +='pushd .'
#alias ++='popd'
alias aea='ansible all -m shell -o -a '
alias beep='echo -en "\007"'
alias code='code -n'
alias dotmatrix='eval $(~/bin/dotmatrix)'
alias groovysh="groovysh -C off"
alias less='less -R'
alias lmk='say '\''Process complete.'\'''
alias lockme='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'
alias moon='curl -s wttr.in/Moon'
alias mutt.local="mutt -f /var/mail/$USER"
alias pg.start='pg_ctl -D /usr/local/var/postgresql@11 start'
alias pg.stop='pg_ctl -D /usr/local/var/postgresql@11 stop'
alias redis.start='redis-server /usr/local/etc/redis.conf'
alias redis.stop='echo no info how to stop it...'
alias pgw="ping -c 3 -s 1472 `netstat -rn| grep default | tr -s ' '| cut -d ' ' -f 2`"
alias ppjson=json_reformat
alias rbenv.init='eval "$(rbenv init -)"'
alias rehash='hash -r'
alias rpry="pry -r ./config/environment"
alias rvm-prompt='PS1="\$(~/.rvm/bin/rvm-prompt) $PS1"'
alias sca="./scp_all.rb"
alias sea="./ssh_exec_all.rb"
alias ssh.agent='eval "$(ssh-agent -s)"'
alias t='todo.sh'
alias todo='todo.sh'
alias tree='find . -print | sed -e '\''s;[^/]*/;|____;g;s;____|; |;g'\'''
alias weather='curl -s wttr.in | head -7'
alias rpry="pry -r ./config/environment"
alias be="bundle exec"
alias Sketch.app='timehack Sketch'
alias pssh='parallel-ssh -h hosts -P'
alias psshs='parallel-ssh -h hosts -P sudo'
alias pscp='parallel-scp -r -v -h hosts'
#alias rbenv="CC=/usr/local/bin/gcc-4.2 rbenv"
alias zabbix="cat ~/tmp/zabbix.status | egrep -v 'PROBLEM ACK' | sed -e 's#PROBLEM NACK ##' |  clog"

if [ -d ~/.aws ]; then
	alias aws.threeding='aws --profile threeding'
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
