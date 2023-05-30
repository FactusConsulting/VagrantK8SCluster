#!/bin/bash -x
sudo swapoff -a
sudo sed -i.bak '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab  #Turning off swap permanently through fstabsdocker
mkdir -p /etc/rancher/rke2
sudo cp /home/vagrant/config.yaml /etc/rancher/rke2/config.yaml

sudo systemctl stop ufw
sudo systemctl disable ufw

mkdir /home/vagrant/.kube
