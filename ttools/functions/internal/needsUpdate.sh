help(){
	echo "usage: 'update \"/path/to/folder\" \"/path/to/what/should/be/older\" [\"wordToIgnore|wordToIgnore2|...\"]'"
}

secondsSinceLastChanged(){
	echo "$(stat -c %Y $1)"
}

if [ "$#" -lt 2 ]; then
	help
	exit 2
fi

baseFolder="$1"
compare="$2"
ignorePattern="$3"

allFolders="$(cd $baseFolder; find . | grep -v -E "$ignorePattern")"
compareSeconds=$(secondsSinceLastChanged $compare)

for folder in $allFolders
do
	folderSeconds=$(secondsSinceLastChanged $baseFolder/$folder)
	if [ $folderSeconds -gt $compareSeconds ]; then
		echo "folder needs update"
		exit 1 # needs update
	fi
done

exit 0 # up to date