echo "Setting ip address to 192.168.10.$1"
sudo ifconfig eth1 192.168.10.$1
sudo route add default gw 192.168.10.1 eth1
echo nameserver 192.168.1.26 >> /etc/resolv.conf
echo nameserver 8.8.8.8 >> /etc/resolv.conf