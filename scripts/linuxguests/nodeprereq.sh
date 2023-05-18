#!/bin/bash -x

# If rocky linux
sudo systemctl stop firewalld
sudo systemctl disable firewalld
# sudo systemctl disable nm-cloud-setup.timer

sudo cat >> /etc/NetworkManager/conf.d/rke2-canal.conf << EOF
[keyfile]
unmanaged-devices=interface-name:cali*;interface-name:flannel*
EOF

# IPtables if rocky linux - not currently needed
# sudo yum install iptables-services -y
# sudo systemctl start iptables
# sudo systemctl enable iptables
# sudo systemctl status iptables
# sudo modprobe iptable-nat



#Generic across ubuntu and rocky linux

##### Not needed for RKE2

curl -k https://releases.rancher.com/install-docker/20.10.sh  | sh
sudo usermod -aG docker $USER
sudo usermod -aG docker vagrant
sudo systemctl enable docker
sudo systemctl start docker
sudo swapoff -a
sudo sed -i.bak '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab  #Turning off swap permanently through fstabsdocker
sudo update-ca-trust  #rocket os specific

#Maybe docker prepull?