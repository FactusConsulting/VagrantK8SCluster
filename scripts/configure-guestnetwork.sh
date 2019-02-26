echo "Configuring networking on guest machine, and seting up /vagrant share"
sudo cp /home/vagrant/01-netcfg.yaml /etc/netplan
sudo netplan apply
echo "Netplan applied. Ping host to check if working:"
ping 192.168.10.1 -c 4

sudo mkdir /vagrant -p
sudo umount /vagrant

echo "username=$1" > .smbcredentials
echo "password=$2" >> .smbcredentials
chmod 6
00 ~/.smbcredentials
grep -qF "//192.168.10.1" /etc/fstab || sudo echo "//192.168.10.1/vagrant //vagrant cifs vers=3.0,credentials=/home/vagrant/.smbcredentials,iocharset=utf8,sec=ntlm 0 0 " >> /etc/fstab
#sudo echo "//192.168.10.1/vagrant //vagrant cifs vers=3.0,credentials=/home/vagrant/.smbcredentials,iocharset=utf8,sec=ntlm 0 0 " >> /etc/fstab
sudo mount -a
# sudo mount -t cifs -o vers=3.0,username=$1,password=$2,uid=1000,gid=1000 //192.168.10.1/vagrant /vagrant
echo "/vagrant folder mounted. Running ls to check if works:"
ls /vagrant