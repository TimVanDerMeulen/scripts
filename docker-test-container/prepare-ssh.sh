network_name="homelab-test"

getIp(){
	container_id="$1"
	echo "$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container_id)"
}

containers=$(docker ps -q -f network=$network_name)

for container_id in $containers
do
	stats="$(docker ps --format '{{ .ID }}\t{{ .Status }}\t{{ .Image }}' -f id=$container_id | grep $container_id)"
	ip="$(getIp $container_id)"
	echo "$ip $stats"
done

echo "use the following command to ssh into container"
echo "ssh -o StrictHostKeyChecking=no test@<container-ip>"
echo ""