VALIDATE_PATTERN="(.{0..2}[aeiou]+)*"
INPUT_FILE="data/names.list"

names="$(more $INPUT_FILE)"

echo $names

getNameParts() {
	name=$1

	name_length=`echo -n $name | wc -m`+1

	for ((left_index=0;left_index<=name_length-2;++left_index))
	do
		for ((right_index=left_index+1;right_index<=name_length-1;++right_index))
		do
			add="${name:left_index:name_length-right_index}"
			echo $add
			#combinations[$name, $left_index, $right_index]="$add"
		done

		if [ $left_index -gt 0 ]; then
			editedName="${name:0:left_index-1}${name:left_index+1:name_length-left_index-1}"
			#combinations[$name, $left_index, $left_index]="$editedName"
		fi

	done
}

combineNameParts(){
	local ignore="$@"
	for name in ${!np[@]}
	do
		if [[ ! $ignore == *"$name"* ]]; then
	
			local parts=${np["$name"]}
			for part in "$parts"
			do
				#echo "$part"
				combineNameParts $ignore $name | 
				echo $others
				for other in $others
				do
					echo "$part$other"
				done
			done
			
		fi
	done
}

declare -A np

for name in $names
do
	nameParts="$(getNameParts $name)"
	np[$name]=b$nameParts
done

#echo ${np[*]}
echo "$(combineNameParts "Kip Ina Tim")"