info(){
	echo "INFO -- $1"
}

info "installing buildx"
export DOCKER_BUILDKIT=1
docker build --platform=local -o . git://github.com/docker/buildx
mkdir -p ~/.docker/cli-plugins
mv buildx ~/.docker/cli-plugins/docker-buildx

info "enabling arm"
docker run --rm --privileged docker/binfmt:820fdd95a9972a5308930a2bdfb8573dd4447ad3

# verify first line is enabled
if [ ! $(cat /proc/sys/fs/binfmt_misc/qemu-aarch64 | head -n 1) = "enabled" ]; then
	info "failed: cat /proc/sys/fs/binfmt_misc/qemu-aarch64 does not show 'enabled'"
	exit 1;
fi

info "creating buildx builder"
docker buildx create --use --name armbuilder
docker buildx use armbuilder
docker buildx inspect --bootstrap