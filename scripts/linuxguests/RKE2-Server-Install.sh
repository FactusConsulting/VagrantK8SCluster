curl -sfL https://get.rke2.io | sudo INSTALL_RKE2_TYPE=server sh -
curl -sfL https://get.rke2.io | sudo INSTALL_RKE2_CHANNEL=latest sh -
sudo systemctl enable rke2-server.service
sudo systemctl start rke2-server.service

sudo cp /etc/rancher/rke2/rke2.yaml /home/vagrant/rke2vagrantkubeconfig  && sudo chown vagrant:vagrant /home/vagrant/rke2vagrantkubeconfig
vagrant scp cp11:~/rke2vagrantkubeconfig rke2vagrantkubeconfig
k9s --kubeconfig .\rke2vagrantkubeconfig


sudo /var/lib/rancher/rke2/bin/kubectl get node --kubeconfig /etc/rancher/rke2/rke2.yaml
sudo /var/lib/rancher/rke2/bin/crictl -r unix:///var/run/k3s/containerd/containerd.sock



sudo /var/lib/rancher/rke2/bin/kubectl get node --kubeconfig=/etc/rancher/rke2/rke2.yaml
# sudo cat /var/lib/rancher/rke2/server/node-token


#sudo mkdir /etc/rancher /etc/rancher/rke2
#sudo nano /etc/rancher/rke2/config.yaml