# ifconfig eth1 192.168.10.$1
# route add default gw 192.168.10.1 eth1
sudo netplan apply
# mount -t cifs -o vers=3.0,credentials=/etc/smb_creds_vgt-fa8a1bae5c18f8b88d6ce2f75d504dea-6ad5fdbcbf2eaa93bd62f92333a2e6e5,uid=1000,gid=1000 //192.168.10.1/vgt-fa8a1bae5c18f8b88d6ce2f75d504dea-6ad5fdbcbf2eaa93bd62f92333a2e6e5 /vagrant
#systemd-resolve --status