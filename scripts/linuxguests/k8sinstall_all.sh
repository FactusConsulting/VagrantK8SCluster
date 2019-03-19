#!/usr/bin/env bash

echo "In k8sInstall_all.sh"
echo "Updating all packages"

#Initial update
export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=critical
sudo -E apt-get -qy update
echo "########### Running upgrade ###########"
sudo -E apt-get -qy -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade
echo "########### Running dist-upgrade ###########"
sudo -E apt-get -qy -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" dist-upgrade
echo "########### Running autoclean ###########"
sudo -E apt-get -qy autoclean


#Docker:
echo "############# Installing Docker ############"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo -E apt-get -qy update
sudo -E apt-get -qy -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" install docker-ce
# sudo -E apt-get -qy -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" install docker-ce=18.06.1~ce~3-0~ubuntu
sudo systemctl enable docker
sudo systemctl start docker
docker run hello-world

# #Kubernetes:
echo "############# Installing Kubernetes ############"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo -E apt-get -qy update
sudo -E apt-get -qy -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" install kubeadm kubectl kubelet #kubernetes-cni
sudo apt-mark hold kubelet kubeadm kubectl docker-ce
#sudo apt-get install -y kubeadm kubectl kubelet kubernetes-cni

sudo apt autoremove -y

sudo swapoff -a
sudo sed -i.bak '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab  #Turning off swap permanently through fstab
