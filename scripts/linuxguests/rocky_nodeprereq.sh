#!/bin/bash -x

# If rocky linux
sudo systemctl stop firewalld
sudo systemctl disable firewalld

sudo cat >> /etc/NetworkManager/conf.d/rke2-canal.conf << EOF
[keyfile]
unmanaged-devices=interface-name:cali*;interface-name:flannel*
EOF

sudo swapoff -a
sudo sed -i.bak '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab  #Turning off swap permanently through fstabsdocker
sudo update-ca-trust  #rocket os specific

mkdir -p /etc/rancher/rke2
sudo cp /home/vagrant/config.yaml /etc/rancher/rke2/config.yaml


# # install kubectl
# sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
# echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
# sudo apt-get update
# sudo apt-get install -y kubectl