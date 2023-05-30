curl -sfL https://get.rke2.io | sudo INSTALL_RKE2_TYPE=server sh -
sudo systemctl enable rke2-server.service
sudo systemctl start rke2-server.service


# Only copy the kubeconfig back to the host when its the cp11 server. The first controlplane
hostname=$(hostname)

# Check if hostname is 'cp11'
if [ "$hostname" == "cp11" ]; then
    sudo cp /etc/rancher/rke2/rke2.yaml /home/vagrant/rke2vagrantkubeconfig  && sudo chown vagrant:vagrant /home/vagrant/rke2vagrantkubeconfig
    sudo sed -i 's/127.0.0.1/vagrantcluster/g' /home/vagrant/rke2vagrantkubeconfig
    sudo cp /home/vagrant/rke2vagrantkubeconfig /vagrant/rke2vagrantkubeconfig
fi


sudo ln -s /var/lib/rancher/rke2/bin/kubectl /usr/local/bin/kubectl
echo 'export KUBECONFIG="/home/vagrant/.kube/config"' >> ~/.bashrc
echo "alias k='kubectl'" >> ~/.bashrc
mkdir /home/vagrant/.kube
sudo cp -i /etc/rancher/rke2/rke2.yaml /home/vagrant/.kube/config
sudo chown $(id -u):$(id -g) /home/vagrant/.kube/config
