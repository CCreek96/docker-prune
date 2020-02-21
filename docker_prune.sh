#!/bin/bash

set -e

function docker_prune() {
	local option=$1
	local commands=$2

	# Ensure volumes command is only passed to system option
	if [[ "$commands" =~ "--volumes" ]]; then
		if [[ "$option" == "system" ]]; then
			echo "running prune: docker $option prune -f $commands"
			docker $option prune -f $commands
		else
			echo "WARN: the --volumes command is only allowed with system option"
			echo "removing the offending command and retrying"
			commands="${commands/" --volumes"/""}"
			echo "new commands: $commands"
			docker_prune "$option" "$commands"
		fi
	# Ensure all command is only passed to system option
	elif [[ "$commands" =~ "-a" ]]; then
		if [[ "$option" == "system" ]] || [[ "$option" == "image" ]]; then
			echo "running prune: docker $option prune -f $commands"
			docker $option prune -f $commands
		else
			echo "WARN: the --all & -a commands are only allowed with system or image options"
			echo "removing the offending command and retrying"
			if [[ "$commands" =~ "--all" ]]; then
				commands="${commands/" --all"/""}"
			fi
			if [[ "$commands" =~ "-a" ]]; then
				commands="${commands/" -a"/""}"
			fi
			echo "new commands: $commands"
			docker_prune "$option" "$commands"
		fi
	# allow other commands to run
	else
		echo "running prune: docker $option prune -f $commands"
		docker $option prune -f $commands
	fi
}

while true; do
	usr_cmds="$@"
	#echo "user specified commands: $commands"
	# pass given options or default to system
	if [ -z "$OPTIONS" ] || [[ "$OPTIONS" =~ "system" ]]; then
		docker_prune "system" "$usr_cmds"
	else	
		for opt in $(echo "$OPTIONS" | tr ',' ' '); do
			docker_prune "$opt" "$usr_cmds"
		done
	fi
	
	# wait for $SLEEP seconds
	if [ -n "$SLEEP" ]; then
        	echo "Sleeping for $SLEEP seconds..."
        	sleep "$SLEEP"
        	echo 
    	else
        	exit 0
    	fi
done
