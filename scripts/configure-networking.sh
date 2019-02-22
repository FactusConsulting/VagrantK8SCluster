sudo su
echo "Setting ip address to 192.168.10.$1"


# ifconfig eth1 192.168.10.$1
# route add default gw 192.168.10.1 eth1
netplan apply
#systemd-resolve --status