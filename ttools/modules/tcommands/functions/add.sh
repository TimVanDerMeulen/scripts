commands_list_file="$(dirname $0)/../commands.list"
lastCommandsScript="$(dirname $0)/internal/getLastCommandsExecuted.sh"

addIfNotExist(){
	if [ ! $1 ]; then
		return 1
	fi
	
	if grep -q $1 "$commands_list_file"; then
		echo "This command is already registered! ($1)"
	else  
		echo "$1" >> $commands_list_file
	fi

}

chooseFrom(){
	if [[ "$#" -gt 0 ]]; then
		echo "$1"
	fi
	
	# TODO call /functions/internal/displayTabled.sh
	# echo selected command

}

if [[ "$#" -gt 0 ]]; then
	addIfNotExist "$1"
	exit 0
fi

lastCommand=$($lastCommandsScript 1)
while true; 
do
	printf "last command: \n$lastCommand\n\n"

	read -p "Save last command? (YES, show more / amount to show): " input

	case $input in
	  [Yy][Ee][Ss])
		param=1
		;;
	  *)
		param=${input:-1}
		;;
	esac

	if [[ "$param" =~ ^[0-9]+$ ]]; then
	
		if [ "$param" -eq 1 ]; then
			commandToAdd="$lastCommand"
		else
			$($lastCommandsScript $param)
		fi
		
		addIfNotExist "$commandToAdd"
		exit 0
	fi

	#echo "-----------------------"
	echo "	$param is not a number!"
	#echo "-----------------------"
done