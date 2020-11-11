help(){
	echo "$(exec $TTOOLS_BASE_FOLDER/functions/internal/listFunctions.sh)"
}

loadVariables(){
	if [[ "$1" ]]; then
		eval "$($TTOOLS_BASE_FOLDER/functions/internal/loadVariables.sh $1)"
	else
		eval "$($TTOOLS_BASE_FOLDER/functions/internal/loadVariables.sh $TTOOLS_BASE_FOLDER)"
	fi
}

if [ ! "$TTOOLS_BASE_FOLDER" ]; then
	TTOOLS_BASE_FOLDER="$(realpath "$0")"
	if [ -f "$TTOOLS_BASE_FOLDER" ]; then
		TTOOLS_BASE_FOLDER="$(dirname "$TTOOLS_BASE_FOLDER")"
	fi
	echo "TTOOLS_BASE_FOLDER not set! Guessing it to be '$TTOOLS_BASE_FOLDER' for now."
	export TTOOLS_BASE_FOLDER=$TTOOLS_BASE_FOLDER
fi

if [[ "$#" -gt 0 ]]; then
	loadVariables
	
	FUNCTION=$1
	shift
	
	if [ -f "$TTOOLS_FUNCTIONS_FOLDER/$FUNCTION.sh" ]; then
		sh -a "$TTOOLS_FUNCTIONS_FOLDER/$FUNCTION.sh" $@
		exit 0
	elif [ -d "$TTOOLS_FUNCTION_MODULES_FOLDER/$FUNCTION" ]; then
		MODULE=$FUNCTION
		FUNCTION=$1
		shift
		
		loadVariables "$TTOOLS_FUNCTION_MODULES_FOLDER/$MODULE"
		
		if [ -f "$TTOOLS_FUNCTION_MODULES_FOLDER/$MODULE/functions/$FUNCTION.sh" ]; then
			exec "$TTOOLS_FUNCTION_MODULES_FOLDER/$MODULE/functions/$FUNCTION.sh" $@
			exit 0
		elif [ -f "$TTOOLS_FUNCTION_MODULES_FOLDER/$MODULE/run.sh" ]; then
			exec "$TTOOLS_FUNCTION_MODULES_FOLDER/$MODULE/run.sh" $FUNCTION $@
			exit 0
		else
			echo "Could not find function $FUNCTION for $MODULE"
		fi
	else
		echo "Could not find function $FUNCTION"
	fi
	
	exit 1
fi

help