curl -sfL https://get.rke2.io | sudo sh -
# curl -sfL https://get.rke2.io | sudo INSTALL_RKE2_CHANNEL=latest sh -
sudo systemctl enable rke2-server.service
sudo systemctl start rke2-server.service
sudo cp /etc/rancher/rke2/rke2.yaml /home/vagrant/rke2vagrantkubeconfig
sudo chown vagrant:vagrant /home/vagrant/rke2vagrantkubeconfig


# install kubectl
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl


# sudo journalctl -u rke2-server -f

# sudo /var/lib/rancher/rke2/bin/kubectl get node --kubeconfig=/etc/rancher/rke2/rke2.yaml
# sudo cat /var/lib/rancher/rke2/server/node-token
# sudo /var/lib/rancher/rke2/bin/crictl
# sudo /var/lib/rancher/rke2/bin/ctr


#sudo mkdir /etc/rancher /etc/rancher/rke2
#sudo nano /etc/rancher/rke2/config.yaml