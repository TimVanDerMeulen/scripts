needsUpdate="$($TTOOLS_INTERNAL_FUNCTIONS_FOLDER/needsUpdate.sh "$TTOOLS_BASE_FOLDER" "$TTOOLS_BASE_FOLDER/aliases.bash_aliases" "\.git|example")"
if [ "$needsUpdate" ]; then
	echo "we need to build a wall!"
	echo "$needsUpdate"
	
	# TODO 
	# perform update
fi

echo "TODO in here: update.sh"