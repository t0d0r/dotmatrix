#!/bin/bash
#
# Checkup.sh - Script to check if host is alive and keep a log file while running.
#              It depends on fping being installed and in path.
#              Output is color-coded for easy viewing.
#
# By Raymond Kuiper (qix at the-wired dot net)
#
# Lisence:	GPLv3  (http://www.gnu.org/licenses/gpl.html)
#
# Todo: *More input validations
#	*Cleanup code?

#
# Set version number for internal reference.
#
ver=1.05

#
# Define default hosts to check, can be IP addresses or (resolvable) hostnames, seperated by spaces.
#

checkhosts="dir.bg kernel.org tcv.bg 185.184.62.2 185.184.62.3"

#
# Set the defaul t timer value.
#
timer=30


#
# Define fping path.
#
fping="fping"

#
# FPing timeout
#
timeout=50

#
# Set nolog value, if 0 logging to file is performed.
# To disable logging set to 1.
#
nolog=0


#
# Define the location of the log file.
#
log="/tmp/checkup_$(date +%s).log"

#
# Set seperator for the logfile. This allows the specification of the seperator between te fields in the logfile.
# This allows for easy importing into other tools like spreadsheets.
# For example: "," or ";" or " ".
#
seperator=","


#
# Set stop variable to sane value, later version might use it for stop signalling.
# For now use Ctrl-C.
#
stop=0


#
# Scan commandline for given arguments
#
if [ "$#" -ge 1 ]
then
	helpcnt=`echo $@ | grep -i [-]h$ | wc -l`


#
# 	If the help argument was specified, print usage info and exit
#
	if [ "$helpcnt" -ge 1 ]
		then
		cat<<EOF
Checkup.sh - Script to check if host is alive and keep a log file while running.
             It depends on fping being installed and in path.
             Output is color-coded for easy viewing.

Version $ver
By Raymond Kuiper (qix@the-wired.net)

Usage:
	-h			Show this text (Can be the only argument)
	-c host1,host2,hostN	comma seperated list of hosts to check
	-t xx			time between checks (between 5 and 3600 seconds)
	-n			No logging to file
EOF
		exit 0
		else
			for arg in "$@"
			do
				if [ "$arg" == "-n" ]
				then
					nolog=1
				elif [ "$arg" == "-t" ]
				then
					nextarg=timer
					timer=""
				elif [ "$arg" == "-c" ]
				then
					nextarg=hosts
					checkhosts=""
				elif [ "$nextarg" == "timer" ]
				then
					timer=$arg
				elif [ "$nextarg" ==  "hosts" ]
				then
					checkhosts=`echo $arg | tr "," " "`
				fi
			done
		fi
fi

#
# Let's test if the user is sane. ;)
# Check $timer and $checkhosts values. If these are not OK, cancel.
#
if [ "$timer" -le 3600 2> /dev/null ] && [ "$timer" -ge 5 2>/dev/null ]
	then
	echo 1 > /dev/null #had to put in something, or the if construct won't work :)
	else
	echo 'ERR: The timer is not valid! Please specify between 5 and 3600 seconds.' >&2
	exit 1
fi
if [ "$checkhosts" = "" ] || [ -z "$checkhosts" ]
	then
	echo 'ERR: No host to check.' >&2
        exit 1
fi



#
# Looks like we're ok, start the loop.
#
until [ $stop -eq 1 ]
do

#
# 	Basic screen layout.
#
	if [ "$nolog" -ne 1 ]
	then
		logstat=""
	else
		logstat=", no logging"
	fi
	clear
	echo -e "Host status: ($timer sec. refresh$logstat)" '\n\r'

#
#	Cycle through hosts.
#
	for host in $checkhosts
	do

#
#		Take a timestamp and test host availability
#
		timestamp=`date +%Y-%m-%d_%H:%M:%S`
		status=`$fping -t "$timeout" "$host"  2> /dev/null | grep "$host is " | cut -d " " -f 3`

#
#		set variables to use for color coding and status logging.
#		0 = unreachable (red), 1 = reachable (green), 2 = unknown (yellow)
#
		if  [ "$status" == "alive" ]
		then
			color='\E[32m'
			numstat=1
		elif [ "$status" == "unreachable" ]
		then
			color='\E[31m'
			numstat=0
		else
			color='\E[33m'
			status="unknown"
			numstat=2
		fi
#
#		Print output to screen and send to logfile if enabled.
#
		printf "$timestamp - $host is "$color"$status\n"
		if [ "$nolog" -ne "1" ]
		then
			echo "$timestamp$seperator$host$seperator$numstat" >> $log
		fi
#
#		reset screen color without clearing the screen.
#
		tput sgr0
	done
#
# Wait before we cycle.
#
sleep $timer
done

#EOF - have fun!
