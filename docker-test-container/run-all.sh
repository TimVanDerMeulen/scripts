test_network_name="homelab-test"
container_label="homelab"

test_network="$(docker network inspect $(docker network ls -q) | grep $test_network_name)"
if [ -z "$test_network" ]; then
	docker network create --subnet=172.24.0.0/16 $test_network_name
	echo "created subnet $test_network_name"
fi

images="$(docker image list -a | grep "$container_label " | awk '{print $1}')"

for image in $images
do
	printf "%15s" "running $image "
	docker run -d --net $test_network_name $image
done