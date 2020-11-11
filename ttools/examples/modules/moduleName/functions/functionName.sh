# optional: declare info() functions that returns a short text description of the function
info(){
	echo "You know what it does ;)" 
}

# you might want to offer a help option for the user
help(){
	# this help method lists all functions found under the function dir
	echo "$(exec functions/internal/listFunctions.sh "path to module")"
}

# do what ever the function is supposed to do
# ideally you wrap everything in a method inside this sh and call after the parameter parsing


# if parameters are required and not optional you might want to test this first
if [[ "$#" -gt 0 ]]; then
	help
fi

# parameters can be parsed as follows:

while [ "$#" -gt 0 ]
do
	case $1 in
	  help)
	  	help
		exit 0
	  -foo)
	    # given parameter is '-foo'
		foo=true
		;;
	  -bar)
	    # given parameter is '-bar'
		bar=true
		;;
	  *)
	  	# default value
		# if nothing above matched this is executed
	  	default="$1"
	  	;;
	esac
	# move parameter pointer to next one
	shift
done

if [ $foo ]; then
	echo "parameter 'foo' was found"
fi