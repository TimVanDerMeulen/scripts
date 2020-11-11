path="$1"
if [[ ! -z "$path" && ! "$path" == *"/" ]]; then
	path="$path/"
fi

echo "$(cd $TTOOLS_BASE_FOLDER; find ${path}functions -not -path '*/internal/*' | grep .sh$ | xargs -I {} basename {} .sh)" | tr ' ' '\n'