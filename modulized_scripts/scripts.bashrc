# #!/bin/bash -xv 
# use this to see every executed command with its values

####################################################################################
#
#                                     Variables
#
####################################################################################
reloadBash=false

currentDir="$(dirname $(realpath $0))"
customScriptsFile="$currentDir/customScripts.bashrc"
customScriptsDir="$currentDir/customScripts"

args=$@
declare -a FUNCTION_QUEUE

# [task name]=takes parameters
declare -A availableTasks=( [help]=false [checkRights]=false [refresh]=false [add]=true )

####################################################################################
#
#                                Functions / Tasks
#
####################################################################################

help(){
	echo "help call not implemented yet"
}

checkRights(){
	find -L $customScriptsDir -type f | while read spo; do sudo chmod +rwx "$spo"; done 
}

refresh(){
	echo "# alias for every file in $customScriptsDir" > $customScriptsFile
	find -L $customScriptsDir -type f | while read spo; do name="$(basename $spo)"; namePure="${name%.*}"; echo "alias $namePure=$customScriptsDir/$name"; done >> $customScriptsFile

	checkRights
	
	reloadBash=true
}

add(){
	for param in $@
	do
		sudo cp -a "$param" $customScriptsDir
		echo "${param} added"
	done
	
	refresh
}

####################################################################################
#
#                                      Script
#
####################################################################################

addToQueue(){
	func="$1"
	if [[ ! "$func" == "" ]]; then 
		if [[ " ${FUNCTION_QUEUE[@]} " =~ " ${func} " ]]; then
 			FUNCTION_QUEUE+=("echo scipping $func because it was already executed.")
		else
			FUNCTION_QUEUE+=("$func")
		fi
	fi
}

if [[ ${#args[@]} == 0 ]] ; then $args < "help"; fi
func=""
last=false
for param in ${args[@]}
do
	if [[ ! "$param" == "" ]]; then
		if [[ "$param" == "help" ]]; then
				help
				exit 0
		fi
		if [[ " ${!availableTasks[@]} " =~ " ${param} " ]]; then
			if [[ $last ]]; then
				addToQueue "$func"
			fi
			func="${param}"
			last=$func
		else
			if [[ ${availableTasks[$last]} ]]; then
				func="${func} ${param}"
			else
				echo "command $param not found! Use 'help' to see all commands."
				exit 1
			fi
		fi
	else
		last=false
	fi
done
if [[ $last ]]; then
	addToQueue "$func"
fi

# execute commands from queue
i=0
while ((i < ${#FUNCTION_QUEUE[@]})); do if [[ ! ("${FUNCTION_QUEUE[$i]}" == echo*) ]]; then echo "${FUNCTION_QUEUE[$i]}"; fi;	${FUNCTION_QUEUE[$i]}; i=$((i+1)); done

if [[ $reloadBash ]]; then
	exec bash # reload terminal
fi
exit 0
