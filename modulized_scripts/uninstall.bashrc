folderName=~/${PWD##*/}
echo $folderName

aliasFile=~/.bash_aliases

if [ -d $folderName ]; then
 echo "-> erase data"
 sudo rm -rf $folderName
 if [ -f $aliasFile ]; then
 	echo "-> forget alias"
 	sed -i '/# custom scripts.*/d' $aliasFile
 	sed -i '/.*\/scripts.*/d' $aliasFile
 fi
 echo "uninstall completed"
 exec bash # reload terminal
else
 echo "no installation found!"
fi