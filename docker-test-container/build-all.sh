# config
container_dir="container"
extensions_dir="extensions"

container_tag="homelab"
extensions_tag="$container_tag-extension"

# found files
dockerfile_dirs="$(find $container_dir/*/Dockerfile | xargs -I {} dirname {})"
extensions="$(find $extensions_dir/*/Dockerfile | xargs -I {} dirname {})"

# preparation
echo "building extensions (xxx-$extensions_tag)"
for extension_path in $extensions
do
	extension_name="$(basename $extension_path)"
	printf "%15s" "$extension_name	"
	docker build -q -t "$extension_name-$extensions_tag" $extension_path
done

# building
echo "building containers (xxx-$container_tag)"
for container_path in $dockerfile_dirs
do
	container_name="$(basename $container_path)"
	printf "%15s" "$container_name	"
	docker build -q -t "$container_name-$container_tag" $container_path
done

echo "done"