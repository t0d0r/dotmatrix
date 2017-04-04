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

