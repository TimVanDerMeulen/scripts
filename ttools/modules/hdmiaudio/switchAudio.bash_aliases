













########## rendered useless since
# cp -r /etc/pulse/ ~/.config/pulse
# does the job






































#echo "make sure the default audio is currently in use!"
#
#activeProfile="$(pacmd list-cards | grep -E 'active.*output:.*' | cut -d '<' -f 2- | cut -d '>' -f 1 | cut -d ':' -f 2)"
#outputs="$(pacmd list-cards | grep -E 'output:.*\(.*\)')"
#outputProfileNames="$(echo "$outputs" | cut -d ':' -f 2)"
#
#getProfilePriority(){
#	echo "$(echo $outputs | grep ":$1:" | cut -d '(' -f 2- | cut -d ',' -f 1 | cut -d ' ' -f 2)"
#}
#
#echo "active: $activeProfile"
#echo "outputs:"
#echo "$(getProfilePriority "$activeProfile")"
#
#echo "$(echo "$outputProfileNames" | grep -i 'hdmi')"
#
#
#
#
#
#
#
#
#
#
#
#
#exit 0

path="/sys/class/drm/"

# -------------------------------------------------------------------------------------------------------------------

checkStati(){
	stati="$(find $1 | grep -i "hdmi" | sed 's/$/\/status/')"
	
	for statusFile in $stati
	do
		if [[ -f "$statusFile" ]]; then
			status="$(more $statusFile)"
			if [ "connected" == "$status" ]; then
				echo "first one found is $statusFile"
				return
			fi
		fi
	done
}

# -------------------------------------------------------------------------------------------------------------------

while true
do
	
	checkStati $path
	
	sleep 5
done