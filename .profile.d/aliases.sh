alias ls='ls -G' # *bsd option for coloring
alias ll='ls -al'

# linux flavour
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

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
alias pg.start='postgres -D /usr/local/var/postgres/10.5'
alias pg.stop='pg_ctl stop -D /usr/local/var/postgres'
alias redis.start='redis-server /usr/local/etc/redis.conf'
alias redis.stop='echo no info how to stop it...'
alias pgw="ping -c 3 -s 1472 `netstat -rn| grep default | tr -s ' '| cut -d ' ' -f 2`"
alias ppjson=json_reformat
alias rbenv.init='eval "$(rbenv init -)"'
alias rvm-prompt='PS1="\$(~/.rvm/bin/rvm-prompt) $PS1"'
alias sca="./scp_all.rb"
alias sea="./ssh_exec_all.rb"
alias ssh.edit="vim ~/.ssh/config"
alias t='todo.sh'
alias todo='todo.sh'
alias tree='find . -print | sed -e '\''s;[^/]*/;|____;g;s;____|; |;g'\'''
alias weather='curl -s wttr.in | head -7'
alias rpry="pry -r ./config/environment"
alias be="bundle exec"

#alias rbenv="CC=/usr/local/bin/gcc-4.2 rbenv"

