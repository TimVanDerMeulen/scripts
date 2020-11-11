listFiles(){
	if [ ! -z $FILTER ]; then
		(cd $TTOOLS_BASE_FOLDER; tree -a -C -I '.git*|examples|*.md' -P "*$FILTER*" --ignore-case -q -x --dirsfirst --prune --matchdirs $1)
	else
		(cd $TTOOLS_BASE_FOLDER; tree -a -C -I '.git*|examples|*.md' --ignore-case -q -x --dirsfirst --prune --matchdirs $1)
	fi
	
}

FILTER=''

while [ "$#" -gt 0 ]
do
	case $1 in
	  -m)
		modules=true
		;;
	  -f)
		functions=true
		;;
	  -fm)
		function_modules=true
		;;
	  *)
	  	FILTER="$1"
	  	;;
	esac
	shift
done

if [ $modules ]; then
	listFiles "modules"
fi
if [ $functions ]; then
	listFiles "functions"
fi
if [ $function_modules ]; then
	listFiles "function_modules"
fi

if [ ! $modules ] && [ ! $functions ] && [ ! $function_modules ]; then
	listFiles
fi
