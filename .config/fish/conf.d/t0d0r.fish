# vim:noexpandtab syntax=bash
set PATH ~/bin /Users/$USER/go/bin /Applications/MacVim.app/Contents/bin $PATH
set PATH /usr/local/opt/python/libexec/bin $PATH

fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin

set GROOVY_HOME /usr/local/opt/groovy/libexec
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

	# replace fancy utf+8 chars with something normal...
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

	ulimit -n 2048

	alias ls='ls -G'
	#alias ls='exa -g'
	alias aea='ansible all -m shell -o -a '
	alias beep='echo -en "\007"'
	alias code='code -n'
	alias groovysh="groovysh -C off"
	alias less='less -R'
	alias lmk='say '\''Process complete.'\'''
	alias lockme='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'
	alias moon='curl -s wttr.in/Moon'
	alias mutt.local="mutt -f /var/mail/$USER"
	alias pg.start='postgres -D /opt/homebrew/var/postgresql@14'
	alias pg.stop='pg_ctl stop -D /opt/homebrew/var/postgresql@14'
	alias pgw="ping -c 3 -s 1472 `netstat -rn| grep default | tr -s ' '| cut -d ' ' -f 2`"
	alias ppjson=json_reformat
	alias rehash='hash -r'
	alias rpry="pry -r ./config/environment"
	alias rvm-prompt='PS1="\$(~/.rvm/bin/rvm-prompt) $PS1"'
	alias sca="./scp_all.rb"
	alias sea="./ssh_exec_all.rb"
	alias todo='todo.sh -t'
	alias t='todo.sh -t'
	alias tree='find . -print | sed -e '\''s;[^/]*/;|____;g;s;____|; |;g'\'''
	alias weather='curl -s wttr.in | head -7'
	alias rm=trash
	alias Sketch.app='timehack Sketch'
	alias terraform.docker='docker run --rm -it -v .:/workspace -v /Users/$USER/.ssh:/root/.ssh -v ~/.aws:/root/.aws -w /workspace -e AWS_PROFILE=oddspedia hashicorp/terraform'

	#alias rbenv="CC=/usr/local/bin/gcc-4.2 rbenv"

	todo list

	function dotmatrix
		cd /Users/$USER/work/github/dotmatrix;
		brew leaves > brew.leaves
		git pull; git status
	end

end
