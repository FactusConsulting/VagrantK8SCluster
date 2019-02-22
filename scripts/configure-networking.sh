# ifconfig eth1 192.168.10.$1
# route add default gw 192.168.10.1 eth1
sudo netplan apply
#systemd-resolve --status