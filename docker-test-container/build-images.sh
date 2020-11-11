# config
image_dir="images"
image_tag="homelab-iso-"
build_flag="done"
container_info="container.info"

info(){
	echo "INFO -- $1"
}

# check kernel
kernel="$(uname -m)"
echo "detected kernel: $kernel"

# found images
images="$(find $image_dir/*/*.iso)"
info "found images:"
echo $images

# build
build_container()
{
	image=$1
	image_dir="$(dirname $image)"
	image_name="$(basename $image)"
	LOG_FILE="$image_dir/log.txt"
	finish_flag=$image_dir/$build_flag
	
	if [ -f $image_dir/$container_info ]; then
		kernel_needed="$(more $image_dir/$container_info | grep kernel | cut -d ':' -f2 | tr -d '[:space:]')"
		
		if [[ ! "$kernel" == *"$kernel_needed"* ]]; then
			info "ignoring $image because of mismatch between kernels!"
			echo "	needed: $kernel_needed"
			echo "	host: $kernel"
			return
		fi
	fi
	
	if [ -f $finish_flag ]; then
		info "nothing todo for $image"
		return
	fi
	
	exec 1>$LOG_FILE
	exec 2>&1
	info "image: $image"
	
	rootfs="$image_dir/rootfs"
	unsquashfs="$image_dir/unsquashfs"
	
	info "preparing needed directories"
	mkdir -p -v $rootfs $unsquashfs
	
	info "mounting iso"
	sudo mount -o loop $image $rootfs
	if [ ! $(df | grep $rootfs) ]; then
		info "Failed to mount $image to $rootfs"
		return
	fi
	
	info "looking for filesystem file"
	filesystem_file="$(find $image_dir -type f | grep filesystem.squashfs$)"
	if [ ! -f $filesystem_file ]; then
		info "Could not find filesystem file!"
		return
	fi
	
	info "extracting filesystem file: $filesystem_file"
	sudo unsquashfs -f -d $unsquashfs $filesystem_file
	
	info "importing to docker"
	container_image_name="$image_tag$(basename $image_dir)"
	sudo tar -C $unsquashfs -c . | docker import - $container_image_name
	info "imported as $container_image_name"
	
	info "cleanup"
	sudo umount -d $rootfs
	sudo rm -r $rootfs $unsquashfs
	
	echo "$container_image_name" > $finish_flag
}

declare -a builds

for iso in $images
do
	build_container $iso &
	builds+=($!)
done

info "waiting for builds: $builds"
for build in $builds
do
	wait $build
done

info "all builds done"

declare -a success
declare -a failure
for iso in $images
do
	if [ -f $(dirname $iso)/$build_flag ]; then
		success+=($iso)
	else
		failure+=($iso)
	fi
done

echo ""
info "success:"
for iso in $success
do
	echo "	$iso"
done

info "failure:"
for iso in $failure
do
	echo "	$iso"
done