set PATH ~/bin /Applications/MacVim.app/Contents/bin $PATH
set fish_greeting ""
#set fish_greeting "Your computer account is overdrawn.  Please see Big Brother."
#set fish_greeting "Real Users never know what they want, but they always know when your program doesn't deliver it."
if status --is-interactive
	fortune computers

	# function fish_greeting
	# 	set -l cows_dir /usr/local/Cellar/cowsay/3.03/share/cows
	# 	set -l avatar (ls $cows_dir | gshuf -n1|cut -d'.' -f1)
	# 	echo $avatar
	# 	cowsay -f $avatar 'Le chat miaule, what should I do?'
	# end

	alias ls='exa -g'
	alias aea='ansible all -m shell -o -a '
	alias beep='echo -en "\007"'
	alias groovysh="groovysh -C off"
	alias less='less -R'
	alias lmk='say '\''Process complete.'\'''
	alias lockme='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'
	alias moon='curl -s wttr.in/Moon'
	alias mutt.local="mutt -f /var/mail/$USER"
	alias pg.start='postgres -D /usr/local/var/postgres'
	alias pg.stop='pg_ctl stop -D /usr/local/var/postgres'
	alias pgw="ping -c 3 -s 1472 `netstat -rn| grep default | tr -s ' '| cut -d ' ' -f 2`"
	alias ppjson=json_reformat
	alias rehash='hash -r'
	alias rpry="pry -r ./config/environment"
	alias rvm-prompt='PS1="\$(~/.rvm/bin/rvm-prompt) $PS1"'
	alias sca="./scp_all.rb"
	alias sea="./ssh_exec_all.rb"
	alias ssh.edit="vim ~/.ssh/config"
	alias t='todo.sh'
	alias todo='todo.sh'
	alias tree='find . -print | sed -e '\''s;[^/]*/;|____;g;s;____|; |;g'\'''
	alias weather='curl -s wttr.in | head -7'
	alias rm=trash

	#alias rbenv="CC=/usr/local/bin/gcc-4.2 rbenv"
end
