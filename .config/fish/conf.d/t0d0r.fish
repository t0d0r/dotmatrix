# vim:noexpandtab
set PATH ~/bin /Users/t0d0r/go/bin /Applications/MacVim.app/Contents/bin $PATH
set GOPATH ~/go
set -gx  LC_ALL en_US.UTF-8
set fish_greeting ""
# disable mosh escape key
set MOSH_ESCAPE_KEY 0
#set fish_greeting "Your computer account is overdrawn.  Please see Big Brother."
#set fish_greeting "Real Users never know what they want, but they always know when your program doesn't deliver it."
if status --is-interactive
	fortune computers

	source ~/.bash_env

	# replace fancu utf+8 chars with something normal...
	set __fish_git_prompt_char_untrackedfiles '?'
	set __fish_git_prompt_char_dirtystate '+'

	# long pwd in prompt
	set fish_prompt_pwd_dir_length 0

	# function fish_greeting
	#		set -l cows_dir /usr/local/Cellar/cowsay/3.03/share/cows
	#		set -l avatar (ls $cows_dir | gshuf -n1|cut -d'.' -f1)
	#		echo $avatar
	#		cowsay -f $avatar 'Le chat miaule, what should I do?'
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
	alias pg.start='pg_ctl -D /usr/local/var/postgresql@11 start'
	alias pg.stop='pg_ctl -D /usr/local/var/postgresql@11 stop'
	alias pgw="ping -c 3 -s 1472 `netstat -rn| grep default | tr -s ' '| cut -d ' ' -f 2`"
	alias ppjson=json_reformat
	alias rehash='hash -r'
	alias rpry="pry -r ./config/environment"
	alias rvm-prompt='PS1="\$(~/.rvm/bin/rvm-prompt) $PS1"'
	alias sca="./scp_all.rb"
	alias sea="./ssh_exec_all.rb"
	alias t='todo.sh'
	alias todo='todo.sh'
	alias tree='find . -print | sed -e '\''s;[^/]*/;|____;g;s;____|; |;g'\'''
	alias weather='curl -s wttr.in | head -7'
	alias rm=trash
	alias Sketch.app='timehack Sketch'

	#alias rbenv="CC=/usr/local/bin/gcc-4.2 rbenv"

	function dotmatrix
		cd /Users/t0d0r/work/github/dotmatrix;
		git pull; git status
	end

end
