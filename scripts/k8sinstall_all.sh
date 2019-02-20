#!/usr/bin/env bash

echo "In k8sInstall_all.sh"
echo "Updating all packages"

#Initial update
# sudo apt purge '^hplip'
# sudo apt install hplip-data hplip-gui -y


sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive dpkg --configure -aq
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq --force-yes
sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -yq --force-yes

sudo apt-get update
sudo apt-get --yes  -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confdef" upgrade
sudi apt-get --yes  -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confdef" dist-upgrade
#sudo DEBIAN_FRONTEND=noninteractive apt-get -yq upgrade
#sudo apt-get dist-upgrade -y

#Docker:
# echo "Installing Docker"
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# sudo apt-get update
# sudo apt-get install -y docker-ce=18.06.1~ce~3-0~ubuntu
# sudo systemctl enable docker
# sudo systemctl start docker

# #Kubernetes:
# echo "Installing Kubernetes"
# curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
# sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
# sudo apt-get update
# sudo apt-get install -y kubeadm kubectl kubelet kubernetes-cni

# sudo swapoff -a
# sudo apt autoremove -y

