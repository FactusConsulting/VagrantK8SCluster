curl -sfL https://get.rke2.io | sudo INSTALL_RKE2_TYPE=server sh -
sudo systemctl enable rke2-server.service
sudo systemctl start rke2-server.service
sudo cp /etc/rancher/rke2/rke2.yaml /home/vagrant/rke2vagrantkubeconfig  && sudo chown vagrant:vagrant /home/vagrant/rke2vagrantkubeconfig

