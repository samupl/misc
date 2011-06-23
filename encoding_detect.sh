#!/usr/bin/env bash
#
# bash encoding detection.
# author: samu 
# irc:    samu @ irc.pirc.pl
#
# This should basically detect users terminal encoding. 
# NOTE: I did this for a test. Then I've written it in python, for my needs, so I am not going to develop this script anymore.


echo -ne "\nżółćżółć"
oldstty=$(stty -g)
stty raw -echo min 0

echo -en "\033[6n" > /dev/tty
IFS=';' read -r -d R -a pos
stty $oldstty

row=$((${pos[0]:2} - 1))
col=$((${pos[1]} - 1))

clear

if [ "$col" == 8 ]; then
	echo "UTF";
else 
	echo "ISO";
fi


