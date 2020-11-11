if [ $# -eq 0 ]; then 
	(xdg-open $PWD ) > /dev/null 2>&1
else
	(xdg-open $@ ) > /dev/null 2>&1
fi