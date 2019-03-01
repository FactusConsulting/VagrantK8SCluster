echo "Configuring networking on guest machine, and seting up /vagrant share"
sudo cp /home/vagrant/01-netcfg.yaml /etc/netplan
sudo netplan apply
echo "Netplan applied. Ping host to check if working:"
ping 192.168.10.1 -c 10
systemd-resolve --status

sudo apt-get update
sudo apt-get install ifupdown -y

#Create a /vagrant share on the guest
sudo mkdir /vagrant -p
echo "username=$1" > .smbcredentials
echo "password=$2" >> .smbcredentials
chmod 600 .smbcredentials
grep -qF "//192.168.10.1" /etc/fstab || sudo echo "//192.168.10.1/vagrant /vagrant cifs vers=3.0,credentials=/home/vagrant/.smbcredentials,iocharset=utf8 0 0 " >> /etc/fstab
sudo mount -a
echo "/vagrant folder mounted. Running ls to check if works:"
ls /vagrant

echo "Ping host again to check if working:"
ping 192.168.10.1 -c 4