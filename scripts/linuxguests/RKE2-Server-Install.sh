curl -sfL https://get.rke2.io | sudo INSTALL_RKE2_TYPE=server sh -

sudo cp -f /usr/local/share/rke2/rke2-cis-sysctl.conf /etc/sysctl.d/60-rke2-cis.conf
sudo systemctl restart systemd-sysctl

if grep -q 'Rocky Linux' /etc/os-release; then
  echo "This is a Rocky Linux machine."
  sudo cp -f /usr/local/share/rke2/rke2-cis-sysctl.conf /etc/sysctl.d/60-rke2-cis.conf
  sudo systemctl restart systemd-sysctl
else
  echo "This is not a Rocky Linux machine."
fi

sudo systemctl enable rke2-server.service
sudo systemctl start rke2-server.service

# Only copy the kubeconfig back to the host when its the cp11 server. The first controlplane
hostname=$(hostname)
if [ "$hostname" == "cp11" ]; then
    sudo cp /etc/rancher/rke2/rke2.yaml /home/vagrant/rke2vagrantkubeconfig  && sudo chown vagrant:vagrant /home/vagrant/rke2vagrantkubeconfig
    sudo sed -i 's/127.0.0.1/vagrantcluster/g' /home/vagrant/rke2vagrantkubeconfig
    sudo cp /home/vagrant/rke2vagrantkubeconfig /vagrant/rke2vagrantkubeconfig
fi

sudo ln -s /var/lib/rancher/rke2/bin/kubectl /usr/local/bin/kubectl
sudo echo "alias k='kubectl'" >> /home/vagrant/.bashrc
mkdir /home/vagrant/.kube
sudo cp -i /etc/rancher/rke2/rke2.yaml /home/vagrant/.kube/config
sudo chown -R vagrant /home/vagrant/.kube/
