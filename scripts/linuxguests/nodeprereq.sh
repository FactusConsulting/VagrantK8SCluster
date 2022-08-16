#!/bin/bash -x

# If rocky linux
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo systemctl disable nm-cloud-setup.timer


# IPtables if rocky linux - not currently needed
# sudo yum install iptables-services -y
# sudo systemctl start iptables
# sudo systemctl enable iptables
# sudo systemctl status iptables
# sudo modprobe iptable-nat



#Generic across ubuntu and rocky linux

##### Not needed for RKE2

# curl -k https://releases.rancher.com/install-docker/20.10.sh  | sh
# sudo usermod -aG docker $USER
# sudo usermod -aG docker vagrant
# sudo systemctl enable docker
# sudo systemctl start docker
sudo swapoff -a
sudo sed -i.bak '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab  #Turning off swap permanently through fstabsdocker
#sudo update-ca-trust  #rocket os specific


#Maybe docker prepull?


#install yum repositories for rke2 server and agent
cat << EOF > /etc/yum.repos.d/rancher-rke2-1-18-latest.repo
[rancher-rke2-common-latest]
name=Rancher RKE2 Common Latest
baseurl=https://rpm.rancher.io/rke2/latest/common/centos/8/noarch
enabled=1
gpgcheck=1
gpgkey=https://rpm.rancher.io/public.key

[rancher-rke2-1-18-latest]
name=Rancher RKE2 1.18 Latest
baseurl=https://rpm.rancher.io/rke2/latest/1.18/centos/8/x86_64
enabled=1
gpgcheck=1
gpgkey=https://rpm.rancher.io/public.key
EOF

yum -y install rke2-server
#yum -y install rke2-agent
cp rke2 /usr/local/bin