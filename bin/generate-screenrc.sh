#!/bin/bash

profile=$1

ssh_config="$HOME/.ssh/customers/${profile}/config"

debug() {
	echo >&2 "${@}"
}

debug "# ${ssh_config}"
#cat -n ${ssh_config} | head | sed 's/^/#/g'

if [ ! -f ${ssh_config} ]; then
	echo >&2 "Cannot find configuration for ${profile}, avalable profiles are:"
	find $HOME/.ssh/customers/ -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | cat -n
	exit 1
fi

c=1

for i in `grep -i "^host " ${ssh_config} | sed 's/^host //gi' | sort -u `; do
	c=$(($c+1));

	case $i in
		*\**)
			# skipping lines with '*' in the hostname
			continue
		;;

		*)
			debug "# $i"
			title=`echo "${i}" | sed 's/oddspedia\.//g'`
			echo "screen -t $title $c ssh-retry $i"
		;;
	esac
done


## old code
exit 1

for i in `grep -i "^host odds" ../.ssh/customers/oddspedia/config | sed 's/^host //g' | sort -u `; do
	c=$(($c+1));
	case $i in
		'oddspedia.*')
			echo "do nothing for $i"
		;;

		*)
			title=`echo "${i}" | sed 's/oddspedia\.//g'`
			echo "screen -t $title $c ssh-retry $i" |  tee -a  oddspedia
		;;
	esac
done
