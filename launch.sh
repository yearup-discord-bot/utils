#!/bin/bash

# don't know if this is clever or not but... it works
# this simple script will run the application with the default 'index.js' entry
# if there isn't a clean '0' code exit it will check out the prior commit and try to run again
# it will do this recursively until it finds a stable commit


function main()
{
	node index.js >> "../logs/$(date +%m-%d-%y).${2}.log" 2>&1
	
	if [ "$?" != 0 ]; then

		let "COMMITSBEHIND+=1"

		YELLOW='\033[0;33m'
		RED='\033[0;31m'
		NC='\033[0m'

		git checkout HEAD~1

		if [ "$?" != 0 ]; then 
			echo -e "${RED}!!-- FATAL COULD NOT FIND A STABLE COMMIT! EXITING --!!${NC}"
			exit
		fi


		echo -e "${YELLOW}!!-- WARNING CURRENTLY RUNNING $COMMITSBEHIND COMMIT(S) BEHIND TIP --!!${NC}"

		main
	fi
}

COMMITSBEHIND=0

if [ "$1" = "release" ]; then
	main COMMITSBEHIND $1
elif [ "$1" = "debug" ]; then
	main COMMITSBEHIND $1
else
	echo -e "Please specify whether this is a 'release' or 'debug' launch.\nex. './launch [release or debug]'"
	exit
fi

main COMMITSBEHIND
