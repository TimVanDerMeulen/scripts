###################################################################################
#                                Preconditions                                    #
###################################################################################

if [ ! $TTOOLS_BASE_FOLDER ]; then
	echo "TTOOLS_BASE_FOLDER not defined! Try calling this as a function of the main script."
	exit 1
fi

# check if root rights
if [ "$(id -u)" -ne 0 ]; then
	export INSTALLATION_USER=$USER
	#echo "This script needs elevated rights! Please allow it to run as root."
	exec sudo -E -- "$0" "$@"
  	exit 0
fi

echo "installation user: $INSTALLATION_USER"

###################################################################################
#                                   Config                                        #
###################################################################################

# install this under /opt/...
INSTALLATION_DIR="/opt/$(basename "$TTOOLS_BASE_FOLDER")"

# installation code
comment="# $(basename "$TTOOLS_BASE_FOLDER")"
baseFolderVariable="export TTOOLS_BASE_FOLDER=$INSTALLATION_DIR"
installationCode=". $INSTALLATION_DIR/aliases.bash_aliases"


findOrAppend(){
	fileContentCheck="$(more $1 | grep -e "$2")"
	if [ ! "$fileContentCheck" ]; then
		if [ ! "$commentAlreadySet" ]; then
			echo " " >> $1
			echo "$comment" >> $1
			commentAlreadySet=$comment
		fi
	
		echo "$2" >> $1
	fi
}

homeDir="$(cd ~;pwd)"

###################################################################################
#                                Installation                                     #
###################################################################################

# copy to installation dir
if [ ! -d "$INSTALLATION_DIR" ]; then
	mkdir $INSTALLATION_DIR
fi
cp -r $TTOOLS_BASE_FOLDER/* $INSTALLATION_DIR

# allow executing scripts and log changes
chown -R -c $INSTALLATION_USER: $INSTALLATION_DIR
chmod -R -c +rwx $INSTALLATION_DIR

# register file in .bashrc (.bash_aliasses if exists)
bashrcAliasesFileCheck="$(more $homeDir/.bashrc | grep -e ".bash_aliases")"
commentAlreadySet=""
if [ "$bashrcAliasesFileCheck" ]; then
	findOrAppend "$homeDir/.bash_aliases" "$baseFolderVariable"
	findOrAppend "$homeDir/.bash_aliases" "$installationCode"
else
	# not recommended but only choice
	findOrAppend "$homeDir/.bashrc" "$baseFolderVariable"
	findOrAppend "$homeDir/.bashrc" "$installationCode"
fi

. $homeDir/.bashrc
