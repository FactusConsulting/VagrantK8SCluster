#!/usr/bin/env bash

sudo hostnamectl set-hostname master #Eller hvilket andet hostname der nu skal til ...

echo "Setting swap to off"
sudo swapoff -a

#Init the k8s master
echo "kubeadm init ..."
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/12

#Next, as the Kubernetes master node initialization output suggested execute the bellow commands as a regular user to start using Kubernetes cluster:
echo "Kubeadm completed. Copying config to be available to this root user, to vagrant user and to host"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

yes | sudo cp -rf /etc/kubernetes/admin.conf /vagrant/kubeconfig
#Get it locally with [Environment]::SetEnvironmentVariable("KUBECONFIG", "Local-Path-To-Config", "Machine")

#From MS
#Confirm that the update strategy of kube-proxy DaemonSet is set to RollingUpdate:
echo "######### Checking that kube-proxy Daemonset to RollingUpdate"
kubectl get ds/kube-proxy -o go-template='{{.spec.updateStrategy.type}}{{"\n"}}' --namespace=kube-system

echo "######### Set kube-proxy to only run on linux nodes"
kubectl patch ds/kube-proxy --patch "$(cat /vagrant/kubernetessetup/node-selector-patch.yml)" -n=kube-system

sleep 10s
echo "######### Checking that kube-proxy has been set correctly to linux nodes"
kubectl get ds -n kube-system  #Check for beta.kubernetes.io/os=linux under Node Selectors

echo "######### Bridged IPv4 traffic to iptables chains when using Flannel."
#For more information check https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
sudo sysctl net.bridge.bridge-nf-call-iptables=1

echo "######### Flannel network setup"
kubectl apply -f /vagrant/kubernetessetup/kube-flannel.yml
sleep 10s
echo "######### Setting flannel network pod to only run on linux nodes"
kubectl patch ds/kube-flannel-ds-amd64 --patch "$(cat /vagrant/kubernetessetup/node-selector-patch.yml)" -n=kube-system
sleep 10s

echo "######### Check that nodeselector has been set on the Flannel Daemon set"
echo "######### ...  all namespaces: "
kubectl get pods --all-namespaces
echo "######### ...  Flannel Daemon has nodeselector?: "
kubectl get ds -n kube-system

#Non windows:
#kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

sudo kubeadm token create --print-join-command  > /vagrant/join_cmd.sh

#Above was run as root. Make it available for the vagrant user as well.
mkdir -p /home/vagrant/.kube
sudo cp -u /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant//.kube/config

