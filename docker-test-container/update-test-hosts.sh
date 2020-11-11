current_path="$(dirname $0)"
hosts_file="$current_path/hosts"

ips="$($current_path/prepare-ssh.sh | grep 172 | cut -b 1-11 )"

echo "[test]" > $hosts_file

for ip in $ips
do
	echo "$ip ansible_user=test" >> $hosts_file
done