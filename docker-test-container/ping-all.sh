network_name="homelab-test"
test_host_file="hosts"

getIp(){
	container_id="$1"
	echo "$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container_id)"
}

containers=$(docker ps -q -f network=$network_name)

./update-test-hosts.sh

ansible test -u test -k -i hosts -m ping