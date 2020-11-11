command=$(history | awk '{$1="";print substr($0,2)}' |tail -n2 | head -n1)
path=$(pwd)

printf "running command in new tab: \n  -> $command\n"


if type xdotool &> /dev/null
then
	EW=$(xdotool search --onlyvisible --classname Gnome-terminal|head -1)
	xdotool windowactivate --sync $EW
	xdotool key --clearmodifiers ctrl+shift+t && $command
else
	gnome-terminal --working-directory=$path -- "$command"
fi