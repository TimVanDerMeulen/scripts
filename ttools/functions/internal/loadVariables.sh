loadVars(){
	grep -Eiv "^ *#.*" $1 | grep "=" | while read -r line; do echo "export $line"; done
}

loopFiles(){
	for varFile in $1 ; do
		varFile="$dir$varFile"
		loadVars $varFile
	done
}

searchIn(){
	for dir in $@ ; do
		if [[ -d $dir ]]; then
			loopFiles "$(ls $dir | grep .variables)"
		fi
	done
}

path="$1"
if [[ ! -z "$path" && ! "$path" == *"/" ]]; then
	path="$path/"
fi

searchIn $path "${path}config/"