sudo curl -sfL https://get.rke2.io | sh -
sudo cp /home/vagrant/config.yaml /etc/rancher/rke2/config.yaml
sudo systemctl enable rke2-server.service
sudo systemctl start rke2-server.service
sudo cp /etc/rancher/rke2/rke2.yaml /home/vagrant/rke2vagrantkubeconfig
sudo chown vagrant:vagrant /home/vagrant/rke2vagrantkubeconfig
# sudo journalctl -u rke2-server -f

# sudo /var/lib/rancher/rke2/bin/kubectl get node --kubeconfig=/etc/rancher/rke2/rke2.yaml
# sudo cat /var/lib/rancher/rke2/server/node-token
# sudo /var/lib/rancher/rke2/bin/crictl
# sudo /var/lib/rancher/rke2/bin/ctr