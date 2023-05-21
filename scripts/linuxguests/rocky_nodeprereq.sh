#!/bin/bash -x

# If rocky linux
sudo systemctl stop firewalld
sudo systemctl disable firewalld

sudo cat >> /etc/NetworkManager/conf.d/rke2-canal.conf << EOF
[keyfile]
unmanaged-devices=interface-name:cali*;interface-name:flannel*
EOF
sudo systemctl reload NetworkManager

sudo swapoff -a
sudo sed -i.bak '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab  #Turning off swap permanently through fstabsdocker
sudo update-ca-trust  #rocket os specific

mkdir -p /etc/rancher/rke2
sudo cp /home/vagrant/config.yaml /etc/rancher/rke2/config.yaml

NM_CLOUD_SETUP_SERVICE_ENABLED=`systemctl status nm-cloud-setup.service | grep -i enabled`
NM_CLOUD_SETUP_TIMER_ENABLED=`systemctl status nm-cloud-setup.timer | grep -i enabled`

if [ "$NM_CLOUD_SETUP_SERVICE_ENABLED" ]
then
  systemctl disable nm-cloud-setup.service
fi

if [ "$NM_CLOUD_SETUP_TIMER_ENABLED" ]
then
  systemctl disable nm-cloud-setup.timer
fi